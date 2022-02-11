import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/car_make/bloc/car_makes_bloc.dart';
import 'package:spocate/screens/car_make/bloc/car_makes_event.dart';
import 'package:spocate/screens/car_make/bloc/car_makes_state.dart';
import 'package:spocate/screens/car_make/repo/car_makes_repo.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';
import 'package:spocate/utils/network_utils.dart';

class CarMakeList extends StatefulWidget {
  const CarMakeList({Key key}) : super(key: key);

  @override
  _CarMakeListState createState() => _CarMakeListState();
}

class _CarMakeListState extends State<CarMakeList> {
  TextEditingController _searchTextController = TextEditingController();
  TextEditingController _carMakeApplyTextController = TextEditingController();
  final items = List<String>.generate(100, (i) => "Item $i");

  CarMakeListBloc _carListBloc;

  List<CarMake> _carList = [];
  List<CarMake> _searchCarList = [];
  bool isListEmpty = false;

  @override
  void initState() {
    print("initState CarMakeList");
    final CarMakeListRepository repository =
    CarMakeListRepository(webservice: Webservice());
    _carListBloc = CarMakeListBloc(repository: repository);

    _searchTextController.addListener(() {
      print("Searched Value ${_searchTextController.text}");
      _searchCars();
    });
    _callWebservice();
    super.initState();
  }

  _callWebservice() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _carListBloc.add(CarMakeListInitEvent());
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
    // await Webservice().getAPICall(WebConstants.ACTION_CARS_LIST).then((value) => print("Login Response $value"));
  }

  _searchCars() {
    List<CarMake> _tempCarList = [];
    _tempCarList.addAll(_carList);
    if (_searchTextController.text.isNotEmpty) {
      _tempCarList.retainWhere((_carList) {
        String searchTerm = _searchTextController.text.toLowerCase().trim();
        String carMake = _carList.makeName.toLowerCase().trim();
        return carMake.contains(searchTerm);
      });
      setState(() {
        if (_tempCarList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarList = _tempCarList;
        }
      });
    } else if (_searchTextController.text == "") {
      setState(() {
        if (_carList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarList = _carList;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_CARS_MAKE),
            body: MultiBlocListener(
              child: _buildSearchView(),
              listeners: [
                BlocListener<CarMakeListBloc, CarMakeListState>(
                    cubit: _carListBloc,
                    listener: (context, state) {
                      _blocCarListListener(context, state);
                    }),
              ],
            )));
  }

  Widget _buildSearchView() {
    return Container(
        child: Column(children: <Widget>[
          Container(
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(SizeConstants.SIZE_16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                  child: TextFormField(
                    autocorrect: false,
                    style: TextStyle(
                        fontSize: SizeConstants.SIZE_20,
                        color: Colors.black,
                        backgroundColor: Colors.white),
                    controller: _searchTextController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(12.0),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      suffixIcon: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.close),
                        ),
                        onTap: () {
                          _searchTextController.text = "";
                          print("Close Clicked");
                        },
                      ),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 10,
                        minHeight: 10,
                      ),
                      // border: OutlineInputBorder(borderSide: BorderSide(width: 0.0),borderRadius: BorderRadius.all(Radius.circular(8.0)))
                    ),
                  ),
                ),
              )),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: SizeConstants.SIZE_16 , right: SizeConstants.SIZE_16),
                child: isListEmpty
                    ? Container(
                  child: Center(
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: SizeConstants.SIZE_16,
                                  top: SizeConstants.SIZE_8,
                                  right: SizeConstants.SIZE_16),
                              child: TextFormField(
                                style: TextStyle(
                                    fontSize: SizeConstants.SIZE_18),
                                controller: _carMakeApplyTextController,
                                showCursor: true,
                                decoration: AppStyles
                                    .textInputDecorationStyle( WordConstants.CAR_MAKE_HINT_TEXT_APPLY_CAR),

                              )),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                SizeConstants.SIZE_8,
                                SizeConstants.SIZE_8,
                                SizeConstants.SIZE_8,
                                SizeConstants.SIZE_8),
                            child: ElevatedButton(
                              child: Text(
                                WordConstants.CAR_MAKE_BUTTON_APPLY,
                                style: AppStyles.buttonFillTextStyle(),
                              ),
                              style: AppStyles.buttonFillStyle(),
                              onPressed: () {
                                if(_carMakeApplyTextController.text.isNotEmpty || _carMakeApplyTextController.text != "") {
                                  Navigator.pop(context, CarMake(
                                      makeName: _carMakeApplyTextController.text
                                  ));
                                }
                                else{
                                  AppWidgets.showSnackBar(context, MessageConstants.MESSAGE_CAR_MAKE_APPLY_EMPTY);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                  ),
                )
                    : ListView.builder(
                  itemCount: _searchCarList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchCarList[index].makeName),
                      onTap: () {
                        Navigator.pop(context, _searchCarList[index]);
                      },
                    );
                  },
                ),
              ))
        ]));
  }

  _blocCarListListener(BuildContext context, CarMakeListState state) {
    if (state is CarMakeListEmpty) {}
    if (state is CarMakeListLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is CarMakeListError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is CarMakeListSuccess) {
      AppWidgets.hideProgressBar();
      print("CarListSuccess ${state.carListResponse.count}");
      setState(() {
        _carList = state.carListResponse.results;
        _searchCarList = _carList;
        if (_searchCarList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }
}

