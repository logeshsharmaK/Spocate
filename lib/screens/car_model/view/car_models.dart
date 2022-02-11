import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';
import 'package:spocate/screens/car_model/bloc/car_models_bloc.dart';
import 'package:spocate/screens/car_model/bloc/car_models_event.dart';
import 'package:spocate/screens/car_model/bloc/car_models_state.dart';
import 'package:spocate/screens/car_model/repo/car_models_repo.dart';
import 'package:spocate/screens/car_model/repo/car_models_response.dart';
import 'package:spocate/utils/network_utils.dart';

class CarModelList extends StatefulWidget {
  final CarMake data;

  const CarModelList({Key key, @required this.data}) : super(key: key);

  @override
  _CarModelListState createState() => _CarModelListState();
}

class _CarModelListState extends State<CarModelList> {
  TextEditingController _searchTextController = TextEditingController();
  TextEditingController _carModelApplyTextController = TextEditingController();

  CarModelListBloc _carModelListBloc;

  List<CarModel> _carModelList = [];
  List<CarModel> _searchCarModelList = [];
  bool isListEmpty = false;

  @override
  void initState() {
    print("initState CarModelList");
    final CarModelListRepository repository =
        CarModelListRepository(webservice: Webservice());
    _carModelListBloc = CarModelListBloc(repository: repository);

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
        _carModelListBloc
            .add(CarModelListInitEvent(makeName: _validateCarMakeName(widget.data.makeName)));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
    // await Webservice().getAPICall("${WebConstants.ACTION_CARS_MODEL_LIST}${widget.data.makeName}${WebConstants.ACTION_CARS_MODEL_LIST_QUERY}").then((value) => print("Car model Response $value"));
  }

  String _validateCarMakeName(String carMakeName){
    return carMakeName.endsWith(".") ? carMakeName.split(".")[0].trim() : carMakeName.trim();
  }

  _searchCars() {
    List<CarModel> _tempCarModelList = [];
    _tempCarModelList.addAll(_carModelList);
    if (_searchTextController.text.isNotEmpty) {
      _tempCarModelList.retainWhere((_carModel) {
        String searchTerm = _searchTextController.text.toLowerCase().trim();
        String carModel = _carModel.modelName.toLowerCase().trim();
        return carModel.contains(searchTerm);
      });
      setState(() {
        if (_tempCarModelList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarModelList = _tempCarModelList;
        }
      });
    } else if (_searchTextController.text == "") {
      setState(() {
        if (_carModelList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarModelList = _carModelList;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_CARS_MODEL),
            body: MultiBlocListener(
              child: _buildSearchView(),
              listeners: [
                BlocListener<CarModelListBloc, CarModelListState>(
                    cubit: _carModelListBloc,
                    listener: (context, state) {
                      _blocCarModelListListener(context, state);
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
        padding: const EdgeInsets.only(left: SizeConstants.SIZE_16),
        child: isListEmpty
            ? Container(
                child: Center(
                  child: Column(
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
                            style: TextStyle(fontSize: SizeConstants.SIZE_18),
                            controller: _carModelApplyTextController,
                            showCursor: true,
                            decoration: AppStyles.textInputDecorationStyle(
                                WordConstants.CAR_MODEL_HINT_TEXT_APPLY_CAR),
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
                            if (_carModelApplyTextController.text.isNotEmpty ||
                                _carModelApplyTextController.text != "") {
                              Navigator.pop(
                                  context,
                                  CarModel(
                                      modelName:
                                          _carModelApplyTextController.text));
                            } else {
                              AppWidgets.showSnackBar(
                                  context,
                                  MessageConstants
                                      .MESSAGE_CAR_MODEL_APPLY_EMPTY);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _searchCarModelList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchCarModelList[index].modelName),
                    onTap: () {
                      Navigator.pop(context, _searchCarModelList[index]);
                    },
                  );
                },
              ),
      ))
    ]));
  }

  _blocCarModelListListener(BuildContext context, CarModelListState state) {
    if (state is CarModelListEmpty) {}
    if (state is CarModelListLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is CarModelListError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is CarModelListSuccess) {
      AppWidgets.hideProgressBar();
      print("CarModelListSuccess ${state.carModelListResponse.count}");
      setState(() {
        _carModelList = state.carModelListResponse.results;
        _searchCarModelList = _carModelList;
        if (_searchCarModelList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }
}
