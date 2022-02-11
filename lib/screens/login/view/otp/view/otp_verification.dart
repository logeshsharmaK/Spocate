import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/login_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/login/bloc/login_bloc.dart';
import 'package:spocate/screens/login/bloc/login_event.dart';
import 'package:spocate/screens/login/bloc/login_state.dart';
import 'package:spocate/screens/login/repo/login_repo.dart';
import 'package:spocate/screens/login/repo/login_request.dart';
import 'package:spocate/screens/login/view/otp/bloc/otp_bloc.dart';
import 'package:spocate/screens/login/view/otp/bloc/otp_event.dart';
import 'package:spocate/screens/login/view/otp/bloc/otp_state.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_repo.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_request.dart';
import 'package:spocate/utils/app_utils.dart';
import 'package:spocate/utils/device_utils.dart';
import 'package:spocate/utils/network_utils.dart';

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key key}) : super(key: key);

  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController _otpTextController = TextEditingController();
  SharedPrefs _sharedPrefs = SharedPrefs();
  String deviceId;
  String appVersionCode;

  OTPBloc _otpBloc;
  LoginBloc _resendOTPBloc;

  String userLoginOTP;
  String isEmail;
  String userLoginUsername = "";
  String displayUserName = "";
  String notificationToken  = "";


  @override
  void initState() {
    _listenForOTP();
    _getDeviceAndAppDetails();
    _getLoginDetails();

    print("initState OTPPage");
    final OTPRepository otpVerifyRepository =
        OTPRepository(webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _otpBloc = OTPBloc(repository: otpVerifyRepository);

    // Reusing the Login webservice for ReSend OTP
    final LoginRepository otpResendRepository =
        LoginRepository(webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _resendOTPBloc = LoginBloc(repository: otpResendRepository);

    super.initState();
  }

  @override
  void dispose() {
    _otpTextController.dispose();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  Future<void> _listenForOTP() async {
    await SmsAutoFill().listenForCode;
  }

  Future<void> _getDeviceAndAppDetails() async {
    await DeviceUtils.getDeviceID().then((value) {
      deviceId = value;
    });
    await AppUtils.getAppVersionCode().then((value) {
      appVersionCode = value;
    });

  }

  Future<void> _getLoginDetails() async {
    await _sharedPrefs.getLoginOTP().then((value) {
      userLoginOTP = value;
    });
    await _sharedPrefs.getLoginUsername().then((value) {
      userLoginUsername = value;
    });

    await _sharedPrefs.getNotificationToken().then((value) {
      notificationToken = value;
    });
    await _sharedPrefs.getIsEmail().then((value) {
      isEmail = value;
      if (isEmail == WebConstants.LOGIN_WITH_EMAIL) {
        setState(() {
          displayUserName = userLoginUsername;
        });
      } else {
        setState(() {
          displayUserName = "+1 " + userLoginUsername;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_OTP_VERIFICATION),
        body: MultiBlocListener(
          child: _buildOTPView(context),
          listeners: [
            BlocListener<OTPBloc, OTPState>(
                cubit: _otpBloc,
                listener: (context, state) {
                  _blocOTPListener(context, state);
                }),
            BlocListener<LoginBloc, LoginState>(
                cubit: _resendOTPBloc,
                listener: (context, state) {
                  _blocResendOTPListener(context, state);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildOTPView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: SizeConstants.SIZE_64,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16, right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.OTP_LABEL_ENTER_OTP,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConstants.SIZE_18, color: Colors.blueGrey),
            ),
          ),
          SizedBox(
            height: SizeConstants.SIZE_32,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16, right: SizeConstants.SIZE_16),
            child: Text(
              displayUserName,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConstants.SIZE_20,
                  color: Colors.black87),
            ),
          ),
          SizedBox(
            height: SizeConstants.SIZE_64,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16, right: SizeConstants.SIZE_16),
            child: PinFieldAutoFill(
              codeLength: 4,
              controller: _otpTextController,
              onCodeChanged: (value) {
                // if (value.length < 4) {
                //   FocusScope.of(context).requestFocus(FocusNode());
                // }
              },
              decoration: UnderlineDecoration(
                textStyle: AppStyles.otpTextStyle(),
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.6)),
              ),
            ),
          ),
          SizedBox(
            height: 32.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              child: Text(
                WordConstants.OTP_BUTTON_VERIFY,
                style: AppStyles.buttonFillTextStyle(),
              ),
              style: AppStyles.buttonFillStyle(),
              onPressed: () {
                _submitOTPVerification(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_2,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              onPressed: () {
                _resendOTP(context);
              },
              child: Text(
                WordConstants.OTP_BUTTON_RESEND,
                style: AppStyles.buttonOutlineTextStyle(),
              ),
              style: AppStyles.buttonOutlineStyle(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitOTPVerification(BuildContext context) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        if (_otpTextController.text.trim().isEmpty) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_OTP_EMPTY_OTP);
        } else if (_otpTextController.text.length < 4) {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_OTP_EMPTY_OTP);
        } else {
          var otpRequest = OTPRequest(
              username: userLoginUsername,
              otpVerificationCode: _otpTextController.text,
              deviceId: deviceId,
              deviceToken: notificationToken,
              platform: DeviceUtils.getPlatform(),
              appVersion: appVersionCode);
          // Webservice()
          //     .postAPICall(WebConstants.ACTION_OTP_VERIFY, otpRequest)
          //     .then((value) => print("OTP Response $value"));
          _otpBloc.add(OTPVerifyEvent(otpRequest: otpRequest));
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _resendOTP(BuildContext context) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var loginRequest = LoginRequest(
            username: userLoginUsername, isEmail: isEmail, accessToken: "");
        _resendOTPBloc.add(LoginClickEvent(loginRequest: loginRequest, isSocialLogin: IsSocialLogin.No));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _storeLoginType(int loginType) async {
    await _sharedPrefs.addLoginType(loginType);
  }

  _blocOTPListener(BuildContext context, OTPState state) {
    if (state is OTPEmpty) {}
    if (state is OTPLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is OTPError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is OTPSuccess) {
      AppWidgets.hideProgressBar();
      _storeLoginType(LoginType.LOGIN_TYPE_PHONE_NUMBER_OR_EMAIL);
      _navigateRespectiveScreens(state.otpResponse.isCar.toString());
    }
  }

  _blocResendOTPListener(BuildContext context, LoginState state) {
    if (state is LoginEmpty) {}
    if (state is LoginLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is LoginError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is LoginSuccess) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(
          context, MessageConstants.MESSAGE_OTP_SENT_SUCCESSFULLY);
    }
  }

  _navigateRespectiveScreens(String isCar) {
    if (isCar == "1") {
      // isCar is 1 then this user already registered and currently login again
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    } else {
      // isCar is 0 then this is new user registering now only
      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.ROUTE_ADD_CAR, (route) => false , arguments: AddCarNavFrom.OTP);
    }
  }
}
