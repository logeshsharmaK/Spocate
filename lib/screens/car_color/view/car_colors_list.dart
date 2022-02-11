import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/car_color/bloc/car_colors_bloc.dart';
import 'package:spocate/screens/car_color/bloc/car_colors_event.dart';
import 'package:spocate/screens/car_color/bloc/car_colors_state.dart';
import 'package:spocate/screens/car_color/repo/car_colors_repo.dart';
import 'package:spocate/screens/car_color/repo/car_colors_response.dart';
import 'package:spocate/utils/network_utils.dart';

class CarColorList extends StatefulWidget {

  const CarColorList({Key key}) : super(key: key);

  @override
  _CarColorListState createState() => _CarColorListState();
}

class _CarColorListState extends State<CarColorList> {
  TextEditingController _searchTextController = TextEditingController();

  CarColorListBloc _carColorListBloc;

  List<ColorList> _carColorList = [];
  List<ColorList> _searchCarColorList = [];
  bool isListEmpty = false;

  @override
  void initState() {
    print("initState CarColorList");
    final CarColorListRepository repository =
        CarColorListRepository(webservice: Webservice());
    _carColorListBloc = CarColorListBloc(repository: repository);

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
        _carColorListBloc.add(CarColorListInitEvent());
      }else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
    // await Webservice().postAPICallOnlyAction(WebConstants.ACTION_CAR_COLOR_LIST).then((value) => print("Car color Response $value"));
  }

  _searchCars() {
    List<ColorList> _tempCarColorList = [];
    _tempCarColorList.addAll(_carColorList);
    if (_searchTextController.text.isNotEmpty) {
      _tempCarColorList.retainWhere((_carColor) {
        String searchTerm = _searchTextController.text.toLowerCase().trim();
        String carColor = _carColor.colorname.toLowerCase().trim();
        return carColor.contains(searchTerm);
      });
      setState(() {
        if (_tempCarColorList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarColorList = _tempCarColorList;
        }
      });
    } else if (_searchTextController.text == "") {
      setState(() {
        if (_carColorList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
          _searchCarColorList = _carColorList;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_CARS_COLOR),
            body:MultiBlocListener(
              child: _buildSearchView(),
              listeners: [
                BlocListener<CarColorListBloc, CarColorListState>(
                    cubit: _carColorListBloc,
                    listener: (context, state) {
                      _blocCarColorListListener(context, state);
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
                  child: Text(MessageConstants.MESSAGE_NO_DATA_FOUND),
                ),
              )
            : ListView.builder(
                itemCount: _searchCarColorList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchCarColorList[index].colorname),
                    onTap: () {
                      Navigator.pop(context, _searchCarColorList[index]);
                    },
                  );
                },
              ),
      ))
    ]));
  }

  _blocCarColorListListener(BuildContext context, CarColorListState state) {
    if (state is CarColorListEmpty) {}
    if (state is CarColorListLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is CarColorListError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is CarColorListSuccess) {
      AppWidgets.hideProgressBar();
      print("CarColorListSuccess ${state.carColorListResponse.colorList.length}");
      setState(() {
        _carColorList = state.carColorListResponse.colorList;
        _searchCarColorList = _carColorList;
        if (_searchCarColorList.isEmpty) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }
}
