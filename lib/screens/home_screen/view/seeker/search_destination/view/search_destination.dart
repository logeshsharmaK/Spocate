import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/source_and_dest.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/dest_locate_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/dest_locate_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/dest_locate_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_add/favorite_add_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_add/favorite_add_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_add/favorite_add_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_list/favorite_list_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_list/favorite_list_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_list/favorite_list_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_remove/favorite_remove_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_remove/favorite_remove_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/favorite/favorite_remove/favorite_remove_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_add_request/favorite_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_list/favorite_list_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_remove_request/favorite_remove_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/favorite/favorite_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/prediction/predictions.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';
import 'package:spocate/utils/app_utils.dart';
import 'package:spocate/utils/network_utils.dart';

class SearchDestination extends StatefulWidget {
  final SourceLocation sourceLocation;

  const SearchDestination({Key key, this.sourceLocation}) : super(key: key);

  @override
  _SearchDestinationState createState() =>
      _SearchDestinationState(sourceLocation);
}

class _SearchDestinationState extends State<SearchDestination> {
  final SourceLocation sourceLocation;

  _SearchDestinationState(this.sourceLocation);

  bool isFavoriteListNotEmpty = false;
  bool isRecentListNotEmpty = false;

  TextEditingController _searchGooglePlacesTextController =
      TextEditingController();

  GooglePlace googlePlaceAutoComplete;

  // List<AutocompletePrediction> autoCompletePredictions = [];

  bool isSearchActive = false;
  GoogleMapController _googleMapController;
  CameraPosition _cameraPositionOnMap;

  String destAddress;
  String destPostalCode;
  double destLatitude;
  double destLongitude;
  CarItem _carItem;

  List<Prediction> predictionPlaces = [];
  List<Prediction> favoritePlaces = [];
  List<Prediction> recentPlaces = [];

  // String destAddress ="Openwave Computing Service, PVT, LTD";
  // String destPostalCode = "600034";
  // double destLatitude = 13.065344;
  // double destLongitude=80.236468;

  String userId;

  // SourceLocation sourceLocation;

  DestLocateBloc _destLocateBloc;
  FavoriteListBloc _favoriteListBloc;
  FavoriteAddBloc _favoriteAddBloc;
  FavoriteRemoveBloc _favoriteRemoveBloc;

  @override
  void initState() {
    print("initState SearchDestination");
    googlePlaceAutoComplete = GooglePlace(WordConstants.GOOGLE_PLACES_API_KEY);
    // Initial Camera Position
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        zoom: 18.0);

    final DestLocateRepository repository = DestLocateRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());
    _destLocateBloc = DestLocateBloc(repository: repository);
    _favoriteListBloc = FavoriteListBloc(repository: repository);
    _favoriteAddBloc = FavoriteAddBloc(repository: repository);
    _favoriteRemoveBloc = FavoriteRemoveBloc(repository: repository);

    // Get Car info
    _getCarInfo();
    // Get User Id
    _getUserDetail();

    // Get Source Location details
    // _getSourceLocationDetails();

    super.initState();
  }

  Future<void> _getCarInfo() async {
    await SharedPrefs().getCarInfo().then((carInfo) {
      setState(() {
        print("carInfo => $carInfo");
        _carItem = carInfo;
      });
    });
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");

      // Get Favorite List
      _getFavoriteAndRecentList();
    });
  }

  Future<void> _getFavoriteAndRecentList() async {
    var favoriteListRequest = FavoriteListRequest(customerId: userId);
    _favoriteListBloc
        .add(FavoriteListClickEvent(favoriteListRequest: favoriteListRequest));
  }

  // Future<void> _getSourceLocationDetails() async {
  //   await SharedPrefs().getSourceLocationDetails().then((location) {
  //     sourceLocation = location;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_DESTINATION),
      // To avoid showing button over the keyboard whenever keyboard enabled
      resizeToAvoidBottomInset: false,
      body: MultiBlocListener(
        child: _buildSearchDestView(),
        listeners: [
          BlocListener<DestLocateBloc, DestLocateState>(
              cubit: _destLocateBloc,
              listener: (context, state) {
                _blocDestLocateListener(context, state);
              }),
          BlocListener<FavoriteListBloc, FavoriteListState>(
              cubit: _favoriteListBloc,
              listener: (context, state) {
                _blocFavoriteListListener(context, state);
              }),
          BlocListener<FavoriteAddBloc, FavoriteAddState>(
              cubit: _favoriteAddBloc,
              listener: (context, state) {
                _blocFavoriteAddListener(context, state);
              }),
          BlocListener<FavoriteRemoveBloc, FavoriteRemoveState>(
              cubit: _favoriteRemoveBloc,
              listener: (context, state) {
                _blocFavoriteRemoveListener(context, state);
              }),
        ],
      ),
    );
  }

  Widget _buildSearchDestView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            // keyboardType: TextInputType.multiline,
            // maxLines: 2,
            // minLines: 1,
            autocorrect: false,
            style: TextStyle(
                fontSize: SizeConstants.SIZE_18,
                color: Colors.black,
                backgroundColor: Colors.white),
            controller: _searchGooglePlacesTextController,
            decoration: InputDecoration(
                hintText: "Search Destination",
                contentPadding: EdgeInsets.all(12.0),
                suffixIcon: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                  onTap: () {
                    print("Close Clicked");
                    _searchGooglePlacesTextController.clear();
                    // autoCompletePredictions.clear();
                    predictionPlaces.clear();
                    setState(() {
                      isSearchActive = false;
                    });

                    // isSearchActive = false;
                    // AppUtils.hideKeyboard(context);
                    // predictions = [],
                  },
                ),
                suffixIconConstraints: BoxConstraints(
                  minWidth: 10,
                  minHeight: 10,
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)))),
            onChanged: (searchText) {
              print("searchText $searchText");
              if (searchText.isNotEmpty) {
                NetworkUtils()
                    .checkInternetConnection()
                    .then((isInternetAvailable) {
                  if (isInternetAvailable) {
                    setState(() {
                      isSearchActive = true;
                    });
                    if (searchText.length > 2) {
                      _getGooglePlacesAutoSuggestions(searchText);
                    }
                  }
                });
              } else {
                setState(() {
                  isSearchActive = false;
                });
                // autoCompletePredictions.clear();
                predictionPlaces.clear();
              }
            },
          ),
        ),
        Expanded(
          child: _buildSearchListOrFavoriteList(),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            _buildCarInfoViewLatest(),
            Positioned(
              child: ElevatedButton(
                  child: Text(
                    "Change",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.black87)),
                  onPressed: () async {
                    var isPopup = await Navigator.pushNamed(context,
                        RouteConstants.ROUTE_MY_CARS_FOR_CHANGE_CAR) as bool;
                    /*CarItem  carItem = await   as CarItem;*/
                    setState(() {
                      if (isPopup != null && isPopup) {
                        _getCarInfo();
                      }
                    });
                  }),
              top: -10,
              right: 8,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchListOrFavoriteList() {
    if (isSearchActive) {
      // Show Map and Hide List
      return _buildSearchList();
    } else {
      return _buildRecentAndFavoriteListView();
    }
  }

  Widget _buildSearchList() {
    return ListView.separated(
      itemCount: predictionPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: predictionPlaces[index].isFavorite
              ? _favoriteIcons(index, SearchDestinationFrom.FROMSEARCH)
              : _unFavoriteIcons(index, SearchDestinationFrom.FROMSEARCH),
          title: Text(
            predictionPlaces[index].mainAddress,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(predictionPlaces[index].secondaryAddress,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
          onTap: () {
            print("Step1 prediction ${predictionPlaces[index].toString()}");
            setState(() {
              _searchGooglePlacesTextController.text =
                  predictionPlaces[index].mainAddress +
                      ", " +
                      predictionPlaces[index].secondaryAddress;
              isSearchActive = false;
              AppUtils.hideKeyboard(context);
            });
            _getAddressFromPrediction(SearchDestinationSubmits.SUBMIT,
                predictionPlaces[index], index);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          color: Colors.black45,
        );
      },
    );
  }

  Widget _buildRecentAndFavoriteListView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(
            visible: isRecentListNotEmpty ,
              child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.grey),
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(MessageConstants.MESSAGE_RECENT_PLACES,
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                    )),
              ),
            ),
            width: MediaQuery.of(context).size.width,
          )
          ),
          Flexible(child: _buildRecentList()),
          Visibility(
              visible: isRecentListNotEmpty ,
              child: Divider(height: 10)
          ),
          Visibility(
              visible: isFavoriteListNotEmpty ,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.grey),
                    child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: const Align(
                          alignment: Alignment.center,
                          child: Text(MessageConstants.MESSAGE_FAVOURITE_PLACES,
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        )),
                  ),
                ),
                width: MediaQuery.of(context).size.width,
              )
          ),
          Flexible(child: _buildFavoriteList()),
        ],
      ),
    );
  }

  Widget _buildFavoriteList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: favoritePlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: favoritePlaces[index].isFavorite
              ? _favoriteIcons(index, SearchDestinationFrom.FROMFAVORITE)
              : _unFavoriteIcons(index, SearchDestinationFrom.FROMFAVORITE),
          title: Text(
            favoritePlaces[index].mainAddress,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(favoritePlaces[index].secondaryAddress,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
          onTap: () {
            _getAddressFromPrediction(
                SearchDestinationSubmits.SUBMIT, favoritePlaces[index], index);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          color: Colors.black45,
        );
      },
    );
  }

  Widget _buildRecentList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: recentPlaces.length,
      itemBuilder: (context, index) {
        return ListTile(
          trailing: recentPlaces[index].isFavorite
              ? _favoriteIcons(index, SearchDestinationFrom.FROMRECENT)
              : _unFavoriteIcons(index, SearchDestinationFrom.FROMRECENT),
          title: Text(
            recentPlaces[index].mainAddress,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(recentPlaces[index].secondaryAddress,
              style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400)),
          onTap: () {
            _getAddressFromPrediction(
                SearchDestinationSubmits.SUBMIT, recentPlaces[index], index);
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 0.5,
          color: Colors.black45,
        );
      },
    );
  }

  Widget _favoriteIcons(int predictionIndex, SearchDestinationFrom from) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.favorite,
              // color: Colors.black87,
              color: Colors.blue[400],
              size: 25.0,
            ),
          ),
          onTap: () async {
            /*
            * By tapping Favorite icon
            *  1. set prediction item as un favorite.
            *  2. call remove favorite service.
            * */
            if (from == SearchDestinationFrom.FROMSEARCH) {
              setState(() {
                predictionPlaces[predictionIndex].isFavorite = false;
              });
              _getAddressFromPrediction(SearchDestinationSubmits.REMOVE,
                  predictionPlaces[predictionIndex], predictionIndex);
            } else if (from == SearchDestinationFrom.FROMFAVORITE) {
              setState(() {
                favoritePlaces[predictionIndex].isFavorite = false;
              });
              _getAddressFromPrediction(SearchDestinationSubmits.REMOVE,
                  favoritePlaces[predictionIndex], predictionIndex);
            } else {
              setState(() {
                recentPlaces[predictionIndex].isFavorite = false;
              });
              _getAddressFromPrediction(SearchDestinationSubmits.REMOVE,
                  recentPlaces[predictionIndex], predictionIndex);
            }
          },
        )
      ],
    );
  }

  Widget _unFavoriteIcons(int predictionIndex, SearchDestinationFrom from) {
    return Column(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.favorite_outline_sharp,
                size: 25.0, color: Colors.blue[400]),
          ),
          onTap: () async {
            /*
            * By tapping unFavorite icon
            *  1. set prediction item as favorite.
            *  2. call add favorite service.
            * */
            if (from == SearchDestinationFrom.FROMSEARCH) {
              setState(() {
                predictionPlaces[predictionIndex].isFavorite = true;
              });
              _getAddressFromPrediction(SearchDestinationSubmits.ADD,
                  predictionPlaces[predictionIndex], predictionIndex);
            } else if (from == SearchDestinationFrom.FROMRECENT) {
              setState(() {
                recentPlaces[predictionIndex].isFavorite = true;
              });
              _getAddressFromPrediction(SearchDestinationSubmits.ADD,
                  recentPlaces[predictionIndex], predictionIndex);
            }
            // else{
            //   _getAddressFromPrediction(
            //     SearchDestinationSubmits.add,
            //     favorite: favoritePlaces[predictionIndex],
            //   );
            // }
          },
        )
      ],
    );
  }

  Widget _buildCarInfoViewLatest() {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
          SizeConstants.SIZE_16, SizeConstants.SIZE_12),
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
          SizeConstants.SIZE_16, SizeConstants.SIZE_12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.directions_car_sharp,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: VerticalDivider(
                thickness: 1,
                width: 1,
                color: Colors.white70,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text('${_carItem?.carmake != null ? _carItem.carmake : ""}',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(height: 12),
                  Text(
                      '${_carItem?.carmodel != null ? _carItem.carmodel : ""} ',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(height: 12),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.white70,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${_carItem?.carnumber != null ? _carItem.carnumber : ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: Colors.white70,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${_carItem?.carcolor != null ? _carItem.carcolor : ""}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getGooglePlacesAutoSuggestions(String searchText) async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        try {
          var suggestionList =
              await googlePlaceAutoComplete.queryAutocomplete.get(searchText);
          if (suggestionList != null && suggestionList.predictions.isNotEmpty) {
            // autoCompletePredictions.clear();
            predictionPlaces.clear();
            print(
                "suggestionList secondaryText ${suggestionList.predictions.first.structuredFormatting.secondaryText}");
            suggestionList.predictions.forEach((prediction) {
              if (prediction.structuredFormatting.secondaryText != null) {
                setState(() {
                  // autoCompletePredictions.add(prediction);
                  predictionPlaces.add(Prediction(
                      isFavorite: false,
                      mainAddress: prediction.structuredFormatting.mainText,
                      secondaryAddress:
                          prediction.structuredFormatting.secondaryText,
                      placeId: prediction.placeId));
                });
              }
            });
            for (int i = 0; i <= favoritePlaces.length; i++) {
              for (int j = 0; j < predictionPlaces.length; j++) {
                if (favoritePlaces[i].secondaryAddress ==
                        predictionPlaces[j].secondaryAddress &&
                    favoritePlaces[i].mainAddress ==
                        predictionPlaces[j].mainAddress) {
                  setState(() {
                    predictionPlaces[j].isFavorite = true;
                    predictionPlaces[j].favoriteId =
                        favoritePlaces[i].favoriteId;
                  });
                }
              }
            }
          } else {
            AppWidgets.showSnackBar(context, suggestionList.status);
            print('suggestion status ${suggestionList.status}');
          }
        } catch (_) {
          print('Places searched exception $_');
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _getAddressFromPrediction(
      SearchDestinationSubmits searchDestinationSubmits,
      Prediction prediction,
      int index) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _getDetailResultFromPrediction(prediction).then((detailResult) {
          // Jalal Feedback on 4 Jun 2021 to once address clicked then redirecting to route instead of showing the selected address in map
          // Update Camera position to locate our current position in Map
          // _cameraPositionOnMap = CameraPosition(
          //     target: LatLng(detailResult.geometry.location.lat,
          //         detailResult.geometry.location.lng),
          //     zoom: 18.0);
          // _googleMapController.animateCamera(
          //     CameraUpdate.newCameraPosition(_cameraPositionOnMap));

          print("Location latitude ${detailResult.geometry.location.lat}");
          print("Location longitude ${detailResult.geometry.location.lng}");

          destLatitude = detailResult.geometry.location.lat;
          destLongitude = detailResult.geometry.location.lng;

          _getAddressFromDetailResult(detailResult).then((address) {
            print("Address addressLine ${address.addressLine}");
            print("Address postalCode ${address.postalCode}");

            destAddress = address.addressLine;
            destPostalCode = address.postalCode;

            // Jalal Feedback on 4 Jun 2021 to navigate next screen just clicking the address instead of clicking locate button
            if (searchDestinationSubmits == SearchDestinationSubmits.SUBMIT) {
              _searchGooglePlacesTextController.text = address.addressLine;
              submitLocateDestination(prediction);
            } else if (searchDestinationSubmits ==
                SearchDestinationSubmits.ADD) {
              print("SearchDestinationSubmits.add");
              submitAddFavouriteAddress(prediction, destLatitude.toString(),
                  destLongitude.toString(), destAddress, destPostalCode, index);
            } else if (searchDestinationSubmits ==
                SearchDestinationSubmits.REMOVE) {
              print("SearchDestinationSubmits.remove");
              submitRemoveFavouriteAddress(prediction, index);
            }
          });
        });
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<DetailsResult> _getDetailResultFromPrediction(
      Prediction prediction) async {
    DetailsResult detailsResult;
    var addressWithPlaceId = await googlePlaceAutoComplete.details
        .get(prediction.placeId, fields: "name,geometry");
    if (addressWithPlaceId != null && addressWithPlaceId.result != null) {
      detailsResult = addressWithPlaceId.result;
      // print("Step2 name ${detailsResult.name}");
    }
    return detailsResult;
  }

  Future<Address> _getAddressFromDetailResult(
      DetailsResult detailsResult) async {
    var location = detailsResult.geometry.location;
    // print("Location latitude ${location.lat}");
    // print("Location latitude ${location.lng}");
    final destinationCoordinate = Coordinates(location.lat, location.lng);
    var destAddress = await Geocoder.local
        .findAddressesFromCoordinates(destinationCoordinate);
    // print("Step4 addressLine ${destAddress.first.addressLine}");
    // print("Step4 postalCode ${destAddress.first.postalCode}");
    return destAddress.first;
  }

  Future<void> submitLocateDestination(Prediction prediction) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        if (_searchGooglePlacesTextController.text.trim().isNotEmpty) {
          var destLocateRequest = DestLocateRequest(
            userId: userId,
            sourceLat: sourceLocation.sourceLatitude.toString(),
            sourceLong: sourceLocation.sourceLongitude.toString(),
            sourceAddress: sourceLocation.sourceAddress.toString(),
            sourcePinCode: sourceLocation.sourcePostalCode.toString(),
            destLat: destLatitude.toString(),
            destLong: destLongitude.toString(),
            destAddress: destAddress.toString(),
            destPinCode: destPostalCode.toString(),
            destinationMainAddress: prediction.mainAddress,
            destinationSubAddress: prediction.secondaryAddress,
            destinationPlaceId: prediction.placeId,
          );
          _destLocateBloc
              .add(DestLocateClickEvent(destLocateRequest: destLocateRequest));
        } else {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_DEST_SEARCH_EMPTY);
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> submitAddFavouriteAddress(
      Prediction prediction,
      String favLatitude,
      String favLongitude,
      String favAddressLine,
      String favPostalCode,
      int index) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var favoriteRequest = FavoriteRequest(
            customerId: userId,
            favouriteaddress: favAddressLine,
            favouritesubaddress: prediction.secondaryAddress,
            mainAddress: prediction.mainAddress,
            favouritelat: favLatitude,
            favouritelong: favLongitude,
            favouritepincode: favPostalCode,
            placeId: prediction.placeId,
            isrecent: "0");
        _favoriteAddBloc.add(FavoriteAddClickEvent(
            favoriteRequest: favoriteRequest, index: index));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> submitRemoveFavouriteAddress(
      Prediction prediction, int index) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var favoriteRemoveRequest =
            FavoriteRemoveRequest(favouriteid: prediction.favoriteId);
        _favoriteRemoveBloc.add(FavoriteRemoveClickEvent(
            favoriteRemoveRequest: favoriteRemoveRequest, index: index));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocDestLocateListener(BuildContext context, DestLocateState state) {
    if (state is DestLocateEmpty) {}
    if (state is DestLocateLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is DestLocateError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is DestLocateSuccess) {
      AppWidgets.hideProgressBar();
      print("Dest Locate Success ${state.destLocateResponse.message}");
      Navigator.pushNamed(context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION,
          arguments: SourceAndDest(
              sourceLocation: sourceLocation,
              destLocation: DestLocation(
                  destLatitude: destLatitude,
                  destLongitude: destLongitude,
                  destAddress: destAddress,
                  destPostalCode: destPostalCode)));
    }
  }

  _blocFavoriteListListener(BuildContext context, FavoriteListState state) {
    if (state is FavoriteListEmpty) {}
    if (state is FavoriteListLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is FavoriteListError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is FavoriteListSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "favouriteList Response Success  ${state.favoriteResponse.favouriteList}");
      print("recentList Response Success ${state.favoriteResponse.recentList}");
      favoritePlaces.clear();
      recentPlaces.clear();
      _addResponseListToLocalFavoriteAndRecentList(
          state.favoriteResponse.favouriteList,
          state.favoriteResponse.recentList);
    }
  }

  _blocFavoriteAddListener(BuildContext context, FavoriteAddState state) {
    if (state is FavoriteAddEmpty) {}
    if (state is FavoriteAddLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is FavoriteAddError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is FavoriteAddSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "Favorite Add Response Success ${state.favoriteAddResponse.message}");
      favoritePlaces.clear();
      recentPlaces.clear();
      _addResponseListToLocalFavoriteAndRecentList(
          state.favoriteAddResponse.favouriteList,
          state.favoriteAddResponse.recentList);
      predictionPlaces.forEach((predictionItems) {
        if (predictionItems.mainAddress ==
                state.favoriteAddResponse.favouriteList[0].favouriteaddress &&
            predictionItems.secondaryAddress ==
                state
                    .favoriteAddResponse.favouriteList[0].favouritesubaddress) {
          predictionItems.isFavorite = true;
          predictionItems.favoriteId =
              state.favoriteAddResponse.favouriteList[0].favouriteid.toString();
        }
      });
    }
  }

  _blocFavoriteRemoveListener(BuildContext context, FavoriteRemoveState state) {
    if (state is FavoriteRemoveEmpty) {}
    if (state is FavoriteRemoveLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is FavoriteRemoveError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is FavoriteRemoveSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "Favorite Remove Response Success ${state.favoriteRemoveResponse.message}");
      favoritePlaces.clear();
      recentPlaces.clear();
      _addResponseListToLocalFavoriteAndRecentList(
          state.favoriteRemoveResponse.favouriteList,
          state.favoriteRemoveResponse.recentList);
    }
  }

  void _addResponseListToLocalFavoriteAndRecentList(
      List<FavouriteList> favouriteList, List<RecentList> recentList) {
    setState(() {
      favouriteList.forEach((favoriteItem) {
        favoritePlaces.add(Prediction(
            placeId: favoriteItem.placeId,
            mainAddress: favoriteItem.mainAddress,
            secondaryAddress: favoriteItem.favouritesubaddress,
            addressLine: favoriteItem.favouriteaddress,
            postalCode: favoriteItem.favouritepincode,
            latitude: favoriteItem.favouritelat,
            longitude: favoriteItem.favouritelong,
            isFavorite: true,
            favoriteId: favoriteItem.favouriteid.toString()));
        print("favouritePlaces ${favoriteItem.favouriteaddress}");
        print("favouritePlaces ${favoriteItem.favouritesubaddress}");
        print("favouritePlaces ${favoriteItem.favouriteid}");
      });
      recentList.forEach((favoriteItem) {
        recentPlaces.add(Prediction(
            placeId: favoriteItem.placeId,
            mainAddress: favoriteItem.mainAddress,
            secondaryAddress: favoriteItem.favouritesubaddress,
            addressLine: favoriteItem.favouriteaddress,
            postalCode: favoriteItem.favouritepincode,
            latitude: favoriteItem.favouritelat,
            longitude: favoriteItem.favouritelong,
            isFavorite: false,
            favoriteId: favoriteItem.favouriteid.toString()));
        print("favouritePlaces ${favoriteItem.favouriteaddress}");
        print("favouritePlaces ${favoriteItem.favouritesubaddress}");
        print("favouritePlaces ${favoriteItem.favouriteid}");
      });
      _checkRecentForFavorite();
      if (favoritePlaces.isNotEmpty) {
        isFavoriteListNotEmpty = true;
      } else {
        isFavoriteListNotEmpty = false;
      }

      if (recentPlaces.isNotEmpty) {
        isRecentListNotEmpty = true;
      } else {
        isRecentListNotEmpty = false;
      }
    });
  }

  _checkRecentForFavorite() {
    if (favoritePlaces.isNotEmpty) {
      for (int j = 0; j < favoritePlaces.length; j++) {
        setState(() {
          recentPlaces.removeWhere((element) =>
              element.mainAddress == favoritePlaces[j].mainAddress);
          // recentPlaces[j].isFavorite = true;
          // recentPlaces[j].favoriteId =
          //     favoritePlaces[i].favoriteId;
        });
      }
    }
  }
}
