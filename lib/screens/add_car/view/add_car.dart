import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/add_car/bloc/add_car_bloc.dart';
import 'package:spocate/screens/add_car/bloc/add_car_event.dart';
import 'package:spocate/screens/add_car/bloc/add_car_state.dart';
import 'package:spocate/screens/add_car/repo/add_car_repo.dart';
import 'package:spocate/screens/add_car/repo/add_car_request.dart';
import 'package:spocate/screens/car_color/repo/car_colors_response.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';
import 'package:spocate/screens/car_model/repo/car_models_response.dart';
import 'package:spocate/utils/network_utils.dart';

class AddCar extends StatefulWidget {
  final AddCarNavFrom data;

  const AddCar({Key key, @required this.data}) : super(key: key);

  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  TextEditingController _carMakeTextController = TextEditingController();
  TextEditingController _carModelTextController = TextEditingController();
  TextEditingController _carColorTextController = TextEditingController();
  TextEditingController _carNumberTextController = TextEditingController();

  AddCarBloc _addCarBloc;
  String userId;
  var car;
  var carModel ;
  var carColor;

  @override
  void initState() {
    SharedPrefs().setLastVisitedScreen(AppBarConstants.APP_BAR_ADD_CAR);
    print("initState AddCar");
    final AddCarRepository addCarVerifyRepository =
        AddCarRepository(webservice: Webservice(), sharedPrefs: SharedPrefs());
    _addCarBloc = AddCarBloc(repository: addCarVerifyRepository);

    _getUserDetail();

    super.initState();
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_ADD_CAR),
        body: MultiBlocListener(
          child: _buildAddCarView(),
          listeners: [
            BlocListener<AddCarBloc, AddCarState>(
                cubit: _addCarBloc,
                listener: (context, state) {
                  _blocAddCarListener(context, state);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddCarView() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.ADD_CAR_LABEL_MAKE,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _carMakeTextController,
              enableInteractiveSelection: true,
              readOnly: true,
              showCursor: false,
              decoration: AppStyles.addCarTextInputDecorationStyle(),
              onTap: () async {
                car = await Navigator.pushNamed(
                    context, RouteConstants.ROUTE_CAR_MAKE_LIST) as CarMake;
                setState(() {
                  if (car != null) {
                    _carMakeTextController.text = car.makeName;
                  }
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.ADD_CAR_LABEL_MODEL,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _carModelTextController,
              enableInteractiveSelection: true,
              readOnly: true,
              showCursor: false,
              decoration: AppStyles.addCarTextInputDecorationStyle(),
              onTap: () async {
                if (_carMakeTextController.text.isEmpty) {
                  AppWidgets.showSnackBar(context, MessageConstants.MESSAGE_CAR_MAKE_EMPTY);
                } else {
                  var carModel = await Navigator.pushNamed(
                    context,
                    RouteConstants.ROUTE_CAR_MODEL_LIST,
                    arguments: car,
                  ) as CarModel;

                  setState(() {
                    if (carModel != null) {
                      _carModelTextController.text = carModel.modelName;
                    }
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.ADD_CAR_LABEL_COLOR,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _carColorTextController,
              enableInteractiveSelection: true,
              readOnly: true,
              showCursor: false,
              decoration: AppStyles.addCarTextInputDecorationStyle(),
              onTap: () async {
                /* users are allowed to pick a car color when car model is picked first*/
                if (_carModelTextController.text.isEmpty) {
                  AppWidgets.showSnackBar(context, MessageConstants.MESSAGE_CAR_MODEL_EMPTY);
                }
                else{
                  carColor = await Navigator.pushNamed(
                      context,
                      RouteConstants.ROUTE_CAR_COLOR_LIST) as ColorList;
                  setState(() {
                    if (carColor != null) {
                      _carColorTextController.text = carColor.colorname;
                    }
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_16,
                right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.ADD_CAR_LABEL_NUMBER,
              style: AppStyles.textLabelStyle(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16,
                top: SizeConstants.SIZE_8,
                right: SizeConstants.SIZE_16),
            child: TextFormField(
              textCapitalization: TextCapitalization.characters,
              style: TextStyle(fontSize: SizeConstants.SIZE_18),
              controller: _carNumberTextController,
              decoration: AppStyles.addCarTextInputDecorationStyle(),
              /* inputFormatters is given here to allow users to type in only character and numerical
              *  note*: special characters are not allowed
              * */
              inputFormatters:[FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_64,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              child: Text(
                WordConstants.ADD_CAR_BUTTON_ADD,
                style: AppStyles.buttonFillTextStyle(),
              ),
              style: AppStyles.buttonFillStyle(),
              onPressed: () {
                _submitAddCar(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAddCar(BuildContext context) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        if (_carMakeTextController.text.isEmpty) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_CAR_MAKE_EMPTY);
        } else if (_carModelTextController.text.isEmpty) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_CAR_MODEL_EMPTY);
        } else if (_carColorTextController.text.isEmpty) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_CAR_COLOR_EMPTY);
        } else if (_carNumberTextController.text.isEmpty) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_CAR_NUMBER_EMPTY);
        } else {
          var addCarRequest = AddCarRequest(
              userId: userId,
              mode: WebConstants.ADD_CAR_MODE_ADD,
              isDefault: "0",
              carMake: _carMakeTextController.text.toString(),
              carModel: _carModelTextController.text.toString(),
              carColor: _carColorTextController.text.toString(),
              carNumber: _carNumberTextController.text.toString());
          _addCarBloc.add(AddCarClickEvent(addCarRequest: addCarRequest));
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocAddCarListener(BuildContext context, AddCarState state) {
    if (state is AddCarEmpty) {}
    if (state is AddCarLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is AddCarError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is AddCarSuccess) {
      AppWidgets.hideProgressBar();
      _navigateRespectiveScreens();
    }
  }

  _navigateRespectiveScreens() {
    if(widget.data == AddCarNavFrom.Login || widget.data == AddCarNavFrom.OTP){
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    }else if(widget.data == AddCarNavFrom.MyCars){
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_MY_CARS, (route) => false);
    }else if( widget.data == AddCarNavFrom.MyCarsSourceDestination){
      Navigator.pop(context,true);
    }
  }
}

