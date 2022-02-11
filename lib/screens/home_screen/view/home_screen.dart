import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geocoder/geocoder.dart' as geoCoder;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/location/bg_service_handler.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_bloc.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_event.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_state.dart';
import 'package:spocate/screens/home_screen/bloc/inform_seeker/inform_seeker_bloc.dart';
import 'package:spocate/screens/home_screen/bloc/inform_seeker/inform_seeker_event.dart';
import 'package:spocate/screens/home_screen/bloc/inform_seeker/inform_seeker_state.dart';
import 'package:spocate/screens/home_screen/bloc/unpark/unpark_bloc.dart';
import 'package:spocate/screens/home_screen/bloc/unpark/unpark_event.dart';
import 'package:spocate/screens/home_screen/bloc/unpark/unpark_state.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home_repo.dart';
import 'package:spocate/screens/home_screen/repo/inform_seeker/inform_seeker_request.dart';
import 'package:spocate/screens/home_screen/repo/unpark/unpark_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';
import 'package:spocate/screens/home_screen/view/side_menu/side_menu_drawer.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';
import 'package:spocate/utils/device_utils.dart';
import 'package:spocate/utils/network_utils.dart';
import 'package:spocate/utils/notification_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  // double screenWidth;
  // double buttonWidth;

  HomeBloc _homeBloc;
  UnParkBloc _unParkBloc;
  InformSeekerBloc _informSeekerBloc;
  String userId;

  String sourceAddress;
  String sourcePostalCode;
  double sourceLatitude;
  double sourceLongitude;

  bool isNoInternetDuringInit = false;
  bool isAppSettingsClickedForLocation = false;

  CameraPosition _cameraPositionOnMap;
  GoogleMapController _googleMapController;

  bool isUserNotUnParked = false;
  String deviceId;

  int userCreditCount = 0;
  CarItem _carItem;
  ThemeData defaultTheme ;


  @override
  void initState() {
    print("initState HomeScreen");
    SharedPrefs().setLastVisitedScreen(AppBarConstants.APP_BAR_HOME);
    WidgetsBinding.instance.addObserver(this);

    final HomeRepository repository =
        HomeRepository(webservice: Webservice(), sharedPrefs: SharedPrefs());
    _homeBloc = HomeBloc(repository: repository);
    _unParkBloc = UnParkBloc(repository: repository);
    _informSeekerBloc = InformSeekerBloc(repository: repository);

    // Getting User id from shared preference and then calling device location permission and location details
    // _getUserDetail();

    // During the launch, the Home screen might not internet. So once internet enabled then calling home details webservice
    _listenNetworkChanges();

    // Initial Camera Position
    _cameraPositionOnMap =
        CameraPosition(target: LatLng(40.740156, -73.997701), zoom: 18.0);

    _checkForTokenChange();
    _getDeviceAndAppDetails();
    _getCarInfo();

    super.initState();
  }

  Future<void> _getDeviceAndAppDetails() async {
    await DeviceUtils.getDeviceID().then((value) {
      deviceId = value;
    });
  }

  _checkForTokenChange() async {
    SharedPrefs().getNotificationToken().then((tokenValue) {
      SharedPrefs().getNotificationOnTokenRefresh().then((onTokenRefreshValue) {
        if (onTokenRefreshValue != null) {
          if (onTokenRefreshValue != tokenValue) {
            print("tokenValue => $tokenValue");
            print("onTokenRefreshValue => $onTokenRefreshValue");
            AppWidgets.showSnackBar(context, MessageConstants.TOKEN_CHANGED);
          }
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // screenWidth = MediaQuery.of(context).size.width;
    // buttonWidth = screenWidth * 0.70;
    defaultTheme = Theme.of(context);

    return Scaffold(
        appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_HOME),
        drawer: SideMenuDrawer(),
        body: FocusDetector(
          child: MultiBlocListener(
            child: _buildHomeScreen(),
            listeners: [
              BlocListener<HomeBloc, HomeState>(
                  cubit: _homeBloc,
                  listener: (context, state) {
                    _blocHomeListener(context, state);
                  }),
              BlocListener<UnParkBloc, UnParkState>(
                  cubit: _unParkBloc,
                  listener: (context, state) {
                    _blocUnParkListener(context, state);
                  }),
              BlocListener<InformSeekerBloc, InformSeekerState>(
                  cubit: _informSeekerBloc,
                  listener: (context, state) {
                    _blocProviderWaitListener(context, state);
                  }),
            ],
          ),
          onFocusGained: () {
            print("onResume");
            BGServiceHandler().stopBackgroundService();
            _getUserDetail();
            _clearSharedPref();
          },
          onFocusLost: () {
            print("onPause");
          },
        ));
  }



  Widget _buildHomeScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: GoogleMap(
            padding: EdgeInsets.all(16.0),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _cameraPositionOnMap,
            onMapCreated: (GoogleMapController mapController) {
              _googleMapController = mapController;
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: Container(
            child:  Theme(
              //Inherit the current Theme and override only the accentColor property
              data: Theme.of(context).copyWith(
                  accentColor: Colors.grey[50]
              ),
              child:  SingleChildScrollView(

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          SizeConstants.SIZE_4,
                          SizeConstants.SIZE_32,
                          SizeConstants.SIZE_4,
                          SizeConstants.SIZE_16),
                      child: Stack(
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
                            top: -20,
                            right: 5,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          SizeConstants.SIZE_32,
                          SizeConstants.SIZE_16,
                          SizeConstants.SIZE_32,
                          SizeConstants.SIZE_16),
                      child: ElevatedButton(
                        onPressed: _submitLookingForParking,
                        child: Text(
                          WordConstants.HOME_BUTTON_LOCATE_SPOT,
                          style: AppStyles.buttonFillTextStyle(),
                        ),
                        style: AppStyles.buttonFillStyle(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          SizeConstants.SIZE_32,
                          SizeConstants.SIZE_16,
                          SizeConstants.SIZE_32,
                          SizeConstants.SIZE_32),
                      child: ElevatedButton(
                        onPressed: () {
                          _submitUnPark();
                        },
                        child: Text(
                          WordConstants.HOME_BUTTON_EXIT_SPOT,
                          style: AppStyles.buttonOutlineTextStyle(),
                        ),
                        style: AppStyles.buttonOutlineStyle(),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.fromLTRB(
                    //       SizeConstants.SIZE_32,
                    //       SizeConstants.SIZE_16,
                    //       SizeConstants.SIZE_32,
                    //       SizeConstants.SIZE_16),
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       showNotificationActionButtons();
                    //     },
                    //     child: Text(
                    //       "Show notification",
                    //       style: AppStyles.buttonOutlineTextStyle(),
                    //     ),
                    //     style: AppStyles.buttonOutlineStyle(),
                    //   ),
                    // ),
                  ],
                ),
              )
            )
          ),
        ),
      ],
    );
  }

  Widget _buildCarInfoViewLatest() {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_1,
          SizeConstants.SIZE_16, SizeConstants.SIZE_1),
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_12, SizeConstants.SIZE_12,
          SizeConstants.SIZE_8, SizeConstants.SIZE_12),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
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

  Future<void> _getCarInfo() async {
    await SharedPrefs().getCarInfo().then((carInfo) {
      setState(() {
        print("carInfo => $carInfo");
        _carItem = carInfo;
      });
    });
  }

  _submitLookingForParking() {
    if (userCreditCount > 0) {
      if (isUserNotUnParked) {
        AppWidgets.showCustomDialogOK(
            context, MessageConstants.MESSAGE_HOME_USER_NOT_UN_PARKED);
      } else {
        NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
          if (isInternetAvailable) {
            if (sourceLatitude != null && sourceLongitude != null) {
              _saveSourceAndNavigate(sourceLatitude, sourceLongitude,
                  sourceAddress, sourcePostalCode);
            } else {
              AppWidgets.showSnackBar(
                  context, MessageConstants.MESSAGE_WAIT_FOR_LOCATION_FETCH);
            }
          } else {
            AppWidgets.showSnackBar(
                context, MessageConstants.MESSAGE_INTERNET_CHECK);
          }
        });
      }
    } else {
      AppWidgets.showCustomDialogOK(
          context, MessageConstants.MESSAGE_SEEKER_NO_CREDITS);
    }
  }

  _clearSharedPref() {
    // Notification received and stored in shared preference which is used to conclude terminated state
    SharedPrefs().setSpState("0");
    // To control the Address and Car view visibility in provider waiting screen
    SharedPrefs().setIsSeekerDetailsToShow(false);
    // To differentiate  route to dest and spot accepted location updates logic
    SharedPrefs().setBackgroundLocationScreen("0");
    // Clear Seeker and Provider Notification Data
    SharedPrefs().clearSeekerAndProviderNotificationData();
   // Show Force cancel alert and reset to 0
    SharedPrefs().getIsSeekerForceCancelled().then((isSeekerForceCancelled) {
      if(isSeekerForceCancelled == 1){
        AppWidgets.showCustomDialogOK(
            context, MessageConstants.MESSAGE_HOME_NOTIFICATION_FOR_SEEKER_FORCE_CANCELLED);
        SharedPrefs().setIsSeekerForceCancelled(0);
      }
    });
    // Clear notification center
    NotificationUtils().cancelAllNotification();
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
      // Once the User Id is retrieved then only we can call home detail which will be called after location permissions are requested
      _checkLocationPermissionForApp();
    });
  }

  Future<void> _getHomeDetails() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var homeRequest = HomeRequest(userId: userId);
        _homeBloc.add(HomeInitEvent(homeRequest: homeRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _checkLocationPermissionForApp() async {
    await Geolocator.checkPermission().then((locationPermission) {
      print("check PermissionForApp value $locationPermission");
      if (locationPermission == LocationPermission.always) {
        _checkLocationFromDevice();
      } else if (locationPermission == LocationPermission.whileInUse) {
        _checkLocationFromDevice();
      } else if (locationPermission == LocationPermission.denied) {
        _requestPermissionForApp();
      } else if (locationPermission == LocationPermission.deniedForever) {
        AppWidgets.showCustomDialogYesNo(
                context, MessageConstants.MESSAGE_LOCATION_REJECTED_ALWAYS)
            .then((value) async {
          if (value == DialogAction.Yes) {
            isAppSettingsClickedForLocation = true;
            await Geolocator.openAppSettings().then((value) {
              print("openAppSettings $value");
            });
          }
        });
      }
    });
  }

  _requestPermissionForApp() async {
    await Geolocator.requestPermission().then((locationPermission) {
      print("request PermissionForApp value $locationPermission");
      if (locationPermission == LocationPermission.always) {
        _checkLocationFromDevice();
      } else if (locationPermission == LocationPermission.whileInUse) {
        _checkLocationFromDevice();
      } else if (locationPermission == LocationPermission.denied) {
        _checkLocationFromDevice();
      } else if (locationPermission == LocationPermission.deniedForever) {
        print("request PermissionForApp deniedForever");
        AppWidgets.showCustomDialogYesNo(
                context, MessageConstants.MESSAGE_LOCATION_REJECTED_ALWAYS)
            .then((value) async {
          if (value == DialogAction.Yes) {
            isAppSettingsClickedForLocation = true;
            await Geolocator.openAppSettings().then((value) => {
                  print("openAppSettings $value"),
                  // _checkLocationFromDevice()
                });
          }
        });
      }
    });
  }

  _checkLocationFromDevice() async {
    await Geolocator.isLocationServiceEnabled().then((value) {
      print("check Device Location value $value");
      _enableDeviceLocation();
    });
  }

  _enableDeviceLocation() async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        // Initiating the Home/Dashboard details after location permissions enabled
        // Otherwise while loading for webservice itself location alert might occur
        _getHomeDetails();

        await Geolocator.getCurrentPosition().then((position) async {
          sourceLatitude = position.latitude;
          sourceLongitude = position.longitude;

          // Update Camera position to locate our current position in Map
          _cameraPositionOnMap = CameraPosition(
              target: LatLng(sourceLatitude, sourceLongitude), zoom: 18.0);
          _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_cameraPositionOnMap));

          await _getAddressFromLocation(position.latitude, position.longitude);
        });
      } else {
        isNoInternetDuringInit = true;
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _getAddressFromLocation(double latitude, double longitude) async {
    final coordinates = geoCoder.Coordinates(latitude, longitude);
    var addresses =
        await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    sourceAddress = addresses.first.addressLine;
    sourcePostalCode = addresses.first.postalCode;
    print("sourceAddress $sourceAddress");
    print("sourcePostalCode $sourcePostalCode");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("AppLifecycleState resumed ");
      // _checkLocationFromDevice();
    } else if (state == AppLifecycleState.paused) {
      print("AppLifecycleState paused ");
    }
  }

  _listenNetworkChanges() {
    NetworkUtils().listenNetworkChanges().listen((isNetworkAvailable) {
      print("Listener $isNetworkAvailable");
      if (isNetworkAvailable && isNoInternetDuringInit) {
        _checkLocationFromDevice();
        isNoInternetDuringInit = false;
      }
    });
  }

  Future<void> _saveSourceAndNavigate(double sourceLat, double sourceLong,
      String address, String postalCode) async {
    //perungudi lat long
    // sourceLat = 12.9654;
    // sourceLong = 80.2461;
    // address = "Perungudi, Chennai, Tamil Nadu, India";
    // postalCode = "600097";
    // As we not having web api call during button click and store on bloc listener
    // Directly saving source location details before navigation to another screen
    await SharedPrefs()
        .setSourceLocationDetails(sourceLat, sourceLong, address, postalCode)
        .then((value) {
      print('Locate SourceLat $sourceLat');
      print('Locate SourceLong $sourceLong');
      Navigator.pushNamed(context, RouteConstants.ROUTE_SEARCH_DESTINATION,
          arguments: SourceLocation(
              sourceLatitude: sourceLat,
              sourceLongitude: sourceLong,
              sourceAddress: address,
              sourcePostalCode: postalCode));
    });
  }

  Future<void> showNotificationActionButtons() async {
    String importanceKey =
        NotificationImportance.High.toString().toLowerCase().split('.').last;

    String channelKey = 'importance_' + importanceKey + '_channel';

    await AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: channelKey,
        channelName: 'title',
        channelDescription: 'message',
        importance: NotificationImportance.High,
        defaultColor: Colors.red,
        playSound: true,
        soundSource: 'resource://raw/sweet',
        ledColor: Colors.red));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1001,
            channelKey: channelKey,
            title: 'Spocate',
            body: 'Have you spotted the Provider?',
            color: Colors.indigoAccent,
            payload: {'uuid': 'uuid-test'}),
        actionButtons: [
          NotificationActionButton(key: 'Yes', label: 'Yes', autoCancel: true),
          NotificationActionButton(key: 'No', label: 'No', autoCancel: false)
        ]);
  }

  Future<void> _submitUnPark() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        // sourceLatitude = 13.065609040341155;
        // sourceLongitude = 80.23662576846053;
        // sourceAddress = "Openwave Computing Services Pvt Ltd.";
        // sourcePostalCode = "600 034";

        // sourceLatitude = 12.906298977977135;
        // sourceLongitude = 80.2283879129887;
        // sourceAddress = "Accenture sholinganallur";
        // sourcePostalCode = "600119";

        // sourceLatitude = 12.903778419991026;
        // sourceLongitude = 80.22762245942018;
        // sourceAddress = "Vestas Sholinganallur";
        // sourcePostalCode = "600119";

        // sourceLatitude = 12.913846912637089;
        // sourceLongitude = 80.23014176692423;
        // sourceAddress = "Karapakkam Sivan Koil 900m";
        // sourcePostalCode = "600119";

        // sourceLat: "16.907464577832172",
        // sourceLong: "81.38407685801515",
        // sourceAddress: "marellamudi, nallajerla, Andhra pradesh,",
        // sourcePinCode: "534112",
        if (sourceLatitude != null && sourceLongitude != null) {
          var unParkRequest = UnParkRequest(
              userId: userId,
              sourceLat: sourceLatitude.toString(),
              sourceLong: sourceLongitude.toString(),
              sourceAddress: sourceAddress.toString(),
              sourcePinCode: sourcePostalCode.toString(),
              isParked: "0");
          // Webservice().postAPICall(WebConstants.ACTION_HOME_UN_PARK, unParkRequest).then((value) => print("ACTION_HOME_UN_PARK Response $value"));
          _unParkBloc.add(UnParkClickEvent(unParkRequest: unParkRequest));
        } else {
          AppWidgets.showSnackBarWithEndListener(
                  context, MessageConstants.MESSAGE_LOCATION_CHECK)
              .closed
              .then((value) {
            _checkLocationFromDevice();
          });
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitProviderDecidedWaiting(String isProviderWait) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var informSeekerRequest = InformSeekerRequest(
            userId: userId,
            sourceLat: sourceLatitude.toString(),
            sourceLong: sourceLongitude.toString(),
            sourceAddress: sourceAddress.toString(),
            sourcePinCode: sourcePostalCode.toString(),
            isParked: "0",
            isWait: isProviderWait);
        _informSeekerBloc.add(
            InformSeekerClickEvent(informSeekerRequest: informSeekerRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocHomeListener(BuildContext context, HomeState state) {
    if (state is HomeEmpty) {}
    if (state is HomeLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is HomeError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is HomeSuccess) {
      AppWidgets.hideProgressBar();

      userCreditCount = state.homeResponse.userInfo.creditCount;

      // if the user try to login 2 different device then latest device auto logout and force to login again
      // As of now the one user can able to login in one device only at a time
      if (state.homeResponse.userInfo.deviceId != deviceId) {
        AppWidgets.showCustomDialogOK(context,
                MessageConstants.MESSAGE_ALREADY_LOGGED_IN_ANOTHER_DEVICE)
            .then((value) {
          if (value == DialogAction.OK) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteConstants.ROUTE_LOGIN, (route) => false);
          }
        });
      } else {
        if (state.homeResponse.userInfo.isParked == 1) {
          setState(() {
            isUserNotUnParked = true;
          });
        } else {
          setState(() {
            isUserNotUnParked = false;
          });
        }
      }
      _getCarInfo();

      print("Home Success ${state.homeResponse.carInfo.carnumber}");
      print("Home Success ${state.homeResponse.userInfo.username}");
    }
  }

  _blocUnParkListener(BuildContext context, UnParkState state) {
    if (state is UnParkEmpty) {}
    if (state is UnParkLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is UnParkError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is UnParkSuccess) {
      AppWidgets.hideProgressBar();

      setState(() {
        isUserNotUnParked = false;
      });
      if (state.unParkResponse.parkingUser != null) {
        AppWidgets.showCustomDialogYesNo(
                context, MessageConstants.MESSAGE_PROVIDER_DECIDES_WAITING)
            .then((value) {
          if (value == DialogAction.Yes) {
            print("Yes Clicked");
            _submitProviderDecidedWaiting("1");
          } else if (value == DialogAction.No) {
            print("NO  Clicked");
            _submitProviderDecidedWaiting("0");
          }
        });
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_PROVIDER_NO_SEEKER_FOUND);
      }

      /*
      Need to un comment when FCM notification click when app is terminate state
      SharedPrefs()
          .setSourceLocationDetails(sourceLocation.sourceLatitude, sourceLocation.sourceLongitude, sourceLocation.sourceAddress, sourceLocation.sourcePostalCode)
          .then((value) {
        print('Locate SourceLat ${sourceLocation.sourceLatitude}');
        print('Locate SourceLong ${sourceLocation.sourceLongitude}');
      });*/
      // need to change the navigation inside the sharedPrefs

    }
  }

  _blocProviderWaitListener(BuildContext context, InformSeekerState state) {
    if (state is InformSeekerEmpty) {}
    if (state is InformSeekerLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is InformSeekerError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is InformSeekerSuccess) {
      AppWidgets.hideProgressBar();

      if (state.isProviderWait == "1") {
        print("SourceAndNavigate sourceLat $sourceLatitude");
        print("SourceAndNavigate sourceLong $sourceLongitude");

        SharedPrefs()
            .setSourceLocationDetails(sourceLatitude, sourceLongitude,
                sourceAddress, sourcePostalCode)
            .then((value) {
          print('ProviderWait SourceLat $sourceLatitude');
          print('ProviderWait SourceLong $sourceLongitude');
          var sourceLocation = SourceLocation();
          sourceLocation.sourceLatitude = sourceLatitude;
          sourceLocation.sourceLongitude = sourceLongitude;
          sourceLocation.sourceAddress = sourceAddress;
          sourceLocation.sourcePostalCode = sourcePostalCode;
          sourceLocation.navigatedFrom = RouteConstants.ROUTE_HOME_SCREEN;
          Navigator.pushNamed(context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
              arguments: sourceLocation);
        });
      }
    }
  }
}
