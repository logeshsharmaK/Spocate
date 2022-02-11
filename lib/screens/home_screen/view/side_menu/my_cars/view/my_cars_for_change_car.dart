import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/delete/my_car_delete_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/delete/my_car_delete_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/delete/my_car_delete_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/my_cars_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/update/my_cars_update_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/bloc/update/my_cars_update_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/delete/my_car_delete_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/delete/my_car_delete_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/update/my_cars_update_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/update/my_cars_update_request.dart';
import 'package:spocate/utils/network_utils.dart';

import '../../side_menu_drawer.dart';
import '../bloc/my_cars_bloc.dart';
import '../bloc/my_cars_state.dart';
import '../bloc/update/my_cars_update_event.dart';

class MyCarsForChangeCar extends StatefulWidget {
  const MyCarsForChangeCar({Key key}) : super(key: key);

  @override
  _MyCarsForChangeCarState createState() => _MyCarsForChangeCarState();
}

class _MyCarsForChangeCarState extends State<MyCarsForChangeCar> {
  MyCarsBloc _myCarsBloc;
  MyCarsUpdateBloc _myCarsUpdateBloc;
  MyCarDeleteBloc _myCarDeleteBloc;

  List<CarItem> _myCarList = [];
  bool isListEmpty = false;

  @override
  void initState() {
    print("initState => MyCarsForChangeCar");

    final MyCarsRepository repository =
        MyCarsRepository(webservice: Webservice());
    _myCarsBloc = MyCarsBloc(repository: repository);

    final MyCarsUpdateRepository _myCarsUpdateRepository =
        MyCarsUpdateRepository(webservice: Webservice());
    _myCarsUpdateBloc = MyCarsUpdateBloc(repository: _myCarsUpdateRepository);

    final MyCarDeleteRepository _myCarDeleteRepository =
        MyCarDeleteRepository(webservice: Webservice());
    _myCarDeleteBloc = MyCarDeleteBloc(repository: _myCarDeleteRepository);

    _getMyCarList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_MY_CARS),
      body: MultiBlocListener(
        child: _buildMyCarsView(),
        listeners: [
          BlocListener<MyCarsBloc, MyCarsState>(
              cubit: _myCarsBloc,
              listener: (context, state) {
                _blocMyCarsListener(context, state);
              }),
          BlocListener<MyCarsUpdateBloc, MyCarsUpdateState>(
              cubit: _myCarsUpdateBloc,
              listener: (context, state) {
                _blocMyCarsUpdateListener(context, state);
              }),
          BlocListener<MyCarDeleteBloc, MyCarDeleteState>(
              cubit: _myCarDeleteBloc,
              listener: (context, state) {
                _blocMyCarDeleteListener(context, state);
              }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         var isPopup = await  Navigator.pushNamed(context, RouteConstants.ROUTE_ADD_CAR,
              arguments: AddCarNavFrom.MyCarsSourceDestination) as bool;
         setState(() {
           if(isPopup != null && isPopup ){
             _getMyCarList();
           }
         });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  _getMyCarList() async {
    var myCarsRequest = MyCarsRequest(customerId: await _getUserDetail());
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _myCarsBloc.add(MyCarsClickEvent(myCarsRequest: myCarsRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<String> _getUserDetail() {
    return SharedPrefs().getUserId();
  }

  Widget _buildMyCarsView() {
    return Container(
        child: Column(children: <Widget>[
      Expanded(
        child: isListEmpty
            ? Container(
                child: Center(
                  child: Text("No data found"),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(6.0),
                itemCount: _myCarList.length,
                itemBuilder: (context, index) {
                  return _buildCornerButton(_myCarList[index],index);
                },
              ),
      ),
    ]));
  }

  Widget _buildCornerButton(CarItem carItem, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        _buildCarItemView(carItem),
        Positioned(
          child: ElevatedButton(
            child: (carItem.isdefault == 1)
                ? Text(
                    "Default",
                  )
                : Text(
                    "Make Default",
                  ),
            style: (carItem.isdefault == 1)
                ? AppStyles.buttonMyCarListDefaultStyle()
                : AppStyles.buttonMyCarListMakeDefaultStyle(),
            onPressed: () async {
              if (index != 0 && DialogAction.Yes ==
                  await AppWidgets.showCustomDialogYesNo(
                      context,
                      MessageConstants.MESSAGE_MY_CAR_SET_DEFAULT_CONFIRMATION)) {
                _updateIsDefaultToService(carItem , index);
              }
            },
          ),
          top: -6,
        ),
        Positioned(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  size: 30.0,
                ),
              ),
              onTap: () async {
                if (_myCarList.length > 1) {
                  if (DialogAction.Yes ==
                      await AppWidgets.showCustomDialogYesNo(
                          context,
                          MessageConstants.MESSAGE_MY_CAR_DELETE_CONFIRMATION)) {
                    _deleteMyCar(carItem);
                  }
                } else {
                  AppWidgets.showCustomDialogOK(
                      context,
                      MessageConstants.MESSAGE_MY_CAR_DELETE_NOT_ALLOWED,
                      positiveActionText: "OK");
                }
              },
            ),
            top: 10,
            right: 10),
      ],
    );
  }

  Widget _buildCarItemView(CarItem carItem) {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_12, SizeConstants.SIZE_12,
          SizeConstants.SIZE_12, SizeConstants.SIZE_12),
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
          SizeConstants.SIZE_16, SizeConstants.SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: const Offset(
              5.0,
              5.0,
            ),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 16.0, top: 16.0),
              child: Icon(
                Icons.directions_car_sharp,
                color: Colors.black87,
                size: 32.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: VerticalDivider(
                thickness: 1,
                width: 1,
                color: Colors.black38,
              ),
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text('Car Model : ${carItem.carmodel}',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  SizedBox(height: 12),
                  Text('Car Make : ${carItem.carmake}',
                      maxLines: 1,
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87)),
                  SizedBox(height: 12),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.black38,
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
                              " ${carItem.carnumber}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        VerticalDivider(
                          thickness: 1,
                          width: 1,
                          color: Colors.black38,
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              " ${carItem.carcolor}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                  color: Colors.black87),
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

  _updateIsDefaultToService(CarItem carItem, int index) async {
    if (carItem.carmake == null) {
    } else if (carItem.carmodel == null) {
    } else if (carItem.carcolor == null) {
    } else if (carItem.carnumber == null) {
    } else {
      var myCarsUpdateRequest = MyCarsUpdateRequest(
          mode: "Edit",
          carId: carItem.id.toString(),
          customerId: await _getUserDetail(),
          carMake: carItem.carmake,
          carModel: carItem.carmodel,
          carColor: carItem.carcolor,
          carNumber: carItem.carnumber,
          isDefault: "1");

      await NetworkUtils()
          .checkInternetConnection()
          .then((isInternetAvailable) {
        if (isInternetAvailable) {
          _myCarsUpdateBloc.add(
              MyCarsUpdateClickEvent(myCarsUpdateRequest: myCarsUpdateRequest,myCarDefaultIndex: index));
        } else {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_INTERNET_CHECK);
        }
      });
    }
  }

  _deleteMyCar(CarItem carItem) async {
    var _myCarDeleteRequest = MyCarsDeleteRequest(carId: carItem.id.toString());

    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _myCarDeleteBloc.add(
            MyCarDeleteClickEvent(myCarsDeleteRequest: _myCarDeleteRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  String updateDefault(int index) {
    String returnVal = "";
    if (_myCarList[index]?.isdefault == 0) {
      returnVal = 'Set as default';
      return returnVal;
    } else {
      returnVal = 'Default';
      return returnVal;
    }
  }

  Color updateTextColor(int index) {
    if (_myCarList[index]?.isdefault == 0) {
      return Colors.black87;
    } else {
      return Colors.green;
    }
  }

  _blocMyCarsListener(BuildContext context, MyCarsState state) {
    if (state is MyCarsEmpty) {}
    if (state is MyCarsLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is MyCarsError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is MyCarsSuccess) {
      AppWidgets.hideProgressBar();
      print("MyCarsSuccess ${state.myCarsResponse.carList}");
      setState(() {
        _myCarList = state.myCarsResponse.carList;
        if (_myCarList.isEmpty || _myCarList == null) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }

  _blocMyCarsUpdateListener(BuildContext context, MyCarsUpdateState state) async{
    if (state is MyCarsUpdateEmpty) {}
    if (state is MyCarsUpdateLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is MyCarsUpdateError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is MyCarsUpdateSuccess) {
      AppWidgets.hideProgressBar();
      print("MyCarsUpdateSuccess ${state.myCarsUpdateResponse}");
      // _getMyCarList();
      print("myCarDefaultIndex => ${state.myCarDefaultIndex}");
      await SharedPrefs().addCarInfo(_myCarList[state.myCarDefaultIndex]).then((value) {
        Navigator.pop(context , true);
      });
    }
  }

  _blocMyCarDeleteListener(BuildContext context, MyCarDeleteState state) {
    if (state is MyCarDeleteEmpty) {}
    if (state is MyCarDeleteLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is MyCarDeleteError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is MyCarDeleteSuccess) {
      AppWidgets.hideProgressBar();
      print("MyCarDeleteSuccess ${state.myCarDeleteResponse.status}");
      _getMyCarList();
    }
  }

}
