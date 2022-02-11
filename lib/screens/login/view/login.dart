import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/color_constants.dart';
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
import 'package:spocate/screens/login/repo/social/social_login_request.dart';
import 'package:spocate/screens/login/view/google/google_sign_in.dart';
import 'package:spocate/utils/app_utils.dart';
import 'package:spocate/utils/network_utils.dart';

import '../../../core/constants/enum_constants.dart';
import '../../../data/local/shared_prefs/shared_prefs.dart';
import '../../../utils/device_utils.dart';
import 'apple/apple_sign_in.dart';
import 'facebook/facebook_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailOrMobileTextController = TextEditingController();
  LoginBloc _loginBloc;

  SharedPrefs _sharedPrefs = SharedPrefs();

  FirebaseMessaging _firebaseMessaging;
  String pushToken="";

  String deviceId;
  String appVersionCode;

  // String deviceToken;

  @override
  void initState() {
    print("initState LoginPage");
    final LoginRepository repository =
        LoginRepository(webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _loginBloc = LoginBloc(repository: repository);
    _getDeviceAndAppDetails();
    // Firebase Push Notification setup
    _firebaseMessaging = FirebaseMessaging.instance;
    _requestNotificationPermission();
    _requestNotificationToken();
    super.initState();
  }

  Future<AuthorizationStatus> _requestNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("Firebase authorizationStatus ${settings.authorizationStatus}");
    return settings.authorizationStatus;
  }

  Future<void> _requestNotificationToken() async {
    await _firebaseMessaging.getToken().then((tokenValue) {
      pushToken = tokenValue;
      print("login Firebase tokenValue $tokenValue");
      _sharedPrefs.setNotificationToken(tokenValue);
    });
  }

  // testing listener to onTokenRefresh
  Future<void> _requestNotificationOnTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      print("login Firebase onTokenRefresh $token");
      _sharedPrefs.setNotificationOnTokenRefresh(token);
    });
  }

  @override
  void dispose() {
    _emailOrMobileTextController.dispose();
    super.dispose();
  }

  Future<void> _getDeviceAndAppDetails() async {
    await DeviceUtils.getDeviceID().then((value) {
      deviceId = value;
    });
    await AppUtils.getAppVersionCode().then((value) {
      appVersionCode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<LoginBloc, LoginState>(
            cubit: _loginBloc,
            builder: (context, state) {
              return _buildLoginView(context);
            },
            listener: (context, state) {
              _blocLoginListener(context, state);
            },
          )),
    );
  }

  Widget _buildLoginView(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(SizeConstants.SIZE_32),
            child: Center(
              child: Text(
                WordConstants.SPLASH_APP_NAME,
                style: TextStyle(
                    fontSize: SizeConstants.SIZE_32,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_16,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_16,
                SizeConstants.SIZE_16),
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9.@]'))],
              controller: _emailOrMobileTextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: WordConstants.LOGIN_LABEL_PHONE_OR_EMAIL),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: SizeConstants.SIZE_16, right: SizeConstants.SIZE_16),
            child: Text(
              WordConstants.LOGIN_LABEL_OTP_PHONE_OR_EMAIL,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: SizeConstants.SIZE_16, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32,
                SizeConstants.SIZE_32),
            child: ElevatedButton(
              child: Text(
                WordConstants.LOGIN_BUTTON_CONTINUE,
                style: AppStyles.buttonFillTextStyle(),
              ),
              style: AppStyles.buttonFillStyle(),
              onPressed: () {
                AppUtils.hideKeyboard(context);
                _submitLogin(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_46,
                SizeConstants.SIZE_16,
                SizeConstants.SIZE_46,
                SizeConstants.SIZE_16),
            child: new ElevatedButton.icon(
              style: AppStyles.buttonLoginSocialStyle(),
              icon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/google.png',
                    height: 32.0, width: 32.0),
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  WordConstants.LOGIN_BUTTON_GOOGLE,
                  style: TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ),
              onPressed: () {
                _submitGoogleLogin(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
                SizeConstants.SIZE_46,
                SizeConstants.SIZE_16,
                SizeConstants.SIZE_46,
                SizeConstants.SIZE_16),
            child: new ElevatedButton.icon(
              style: AppStyles.buttonLoginSocialStyle(),
              icon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/facebook.png',
                    height: 32.0, width: 32.0),
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  WordConstants.LOGIN_BUTTON_FACEBOOK,
                  style: TextStyle(color: Colors.black87, fontSize: 16.0),
                ),
              ),
              onPressed: () {
                _submitFaceBookLogin(context);
              },
            ),
          ),
          Visibility(
            visible: Platform.isIOS,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  SizeConstants.SIZE_46,
                  SizeConstants.SIZE_16,
                  SizeConstants.SIZE_46,
                  SizeConstants.SIZE_16),
              child: new ElevatedButton.icon(
                style: AppStyles.buttonLoginSocialStyle(),
                icon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.asset('assets/images/apple.png',
                      height: 32.0, width: 32.0),
                ),
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    WordConstants.LOGIN_BUTTON_APPLE,
                    style: TextStyle(color: Colors.black87, fontSize: 16.0),
                  ),
                ),
                onPressed: () {
                  _submitAppleLogin(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitLogin(BuildContext context) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        if (pushToken.isNotEmpty) {
          if (_emailOrMobileTextController.text.trim().isNotEmpty) {
            if (AppUtils.isNumeric(_emailOrMobileTextController.text.trim())) {
              if (AppUtils.isValidPhone(
                  _emailOrMobileTextController.text.trim())) {
                var loginRequest = LoginRequest(
                    username: _emailOrMobileTextController.text.trim(),
                    isEmail: AppUtils.isValidEmail(
                            _emailOrMobileTextController.text.trim())
                        ? WebConstants.LOGIN_WITH_EMAIL
                        : WebConstants.LOGIN_WITH_PHONE,
                    accessToken: "");
                // Webservice().postAPICall(WebConstants.LOGIN_ACTION, loginRequest).then((value) => print("Login Response $value"));
                print("Damu loginRequest ${loginRequest.toJson()}");
                _loginBloc.add(LoginClickEvent(
                    loginRequest: loginRequest,
                    isSocialLogin: IsSocialLogin.No));
              } else {
                AppWidgets.showSnackBar(context,
                    MessageConstants.MESSAGE_LOGIN_EMPTY_MOBILE_NUMBER);
              }
            } else {
              if (AppUtils.isValidEmail(
                  _emailOrMobileTextController.text.trim())) {
                var loginRequest = LoginRequest(
                    username: _emailOrMobileTextController.text.trim(),
                    isEmail: AppUtils.isValidEmail(
                            _emailOrMobileTextController.text.trim())
                        ? WebConstants.LOGIN_WITH_EMAIL
                        : WebConstants.LOGIN_WITH_PHONE,
                    accessToken: "");
                // Webservice().postAPICall(WebConstants.LOGIN_ACTION, loginRequest).then((value) => print("Login Response $value"));
                print("Damu loginRequest ${loginRequest.toJson()}");
                _loginBloc.add(LoginClickEvent(
                    loginRequest: loginRequest,
                    isSocialLogin: IsSocialLogin.No));
              } else {
                AppWidgets.showSnackBar(
                    context, MessageConstants.MESSAGE_LOGIN_EMPTY_EMAIL);
              }
            }
          } else {
            AppWidgets.showSnackBar(
                context, MessageConstants.MESSAGE_LOGIN_EMPTY_EMAIL_OR_MOBILE);
          }
        } else {
          AppWidgets.showSnackBar(
              context, MessageConstants.MESSAGE_LOGIN_PUSH_TOKEN_EMPTY);
        }
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitGoogleLogin(BuildContext context) async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        await GoogleSignInApi.login().then((googleSignInAccount) {
          if (googleSignInAccount != null) {
            _storeLoginType(LoginType.LOGIN_TYPE_GOOGLE);
            _storeSocialProfileData(googleSignInAccount.displayName,
                googleSignInAccount.email, googleSignInAccount.photoUrl);
            print("googleSignInAccount = $googleSignInAccount");
            var googleLoginRequest = SocialLoginRequest(
                username: googleSignInAccount.displayName,
                deviceId: deviceId,
                accessToken: googleSignInAccount.id,
                appVersion: appVersionCode,
                isEmail: "0",
                platForm: DeviceUtils.getPlatform(),
                deviceToken: pushToken);

            _loginBloc.add(LoginClickEvent(
                loginRequest: googleLoginRequest,
                isSocialLogin: IsSocialLogin.Yes));
          }
        });
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitFaceBookLogin(BuildContext context) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        signInWithFacebook().then((faceBookUserCredential) {
          print("facebook result $faceBookUserCredential");
          if (faceBookUserCredential != null) {
            _storeLoginType(LoginType.LOGIN_TYPE_FACEBOOK);
            _storeSocialProfileData(
                faceBookUserCredential.user.displayName,
                faceBookUserCredential.user.email,
                faceBookUserCredential.user.photoURL);
            var faceBookLoginRequest = SocialLoginRequest(
                username: faceBookUserCredential.user.displayName,
                deviceId: deviceId,
                accessToken: fbAccessToken,
                appVersion: appVersionCode,
                isEmail: "0",
                platForm: DeviceUtils.getPlatform(),
                deviceToken: pushToken);

            _loginBloc.add(LoginClickEvent(
                loginRequest: faceBookLoginRequest,
                isSocialLogin: IsSocialLogin.Yes));
          }
        });
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitAppleLogin(BuildContext context) async {
    await NetworkUtils()
        .checkInternetConnection()
        .then((isInternetAvailable) async {
      if (isInternetAvailable) {
        await signInWithApple().then((appleSignInAccount) {
          if (appleSignInAccount != null) {
            _storeLoginType(LoginType.LOGIN_TYPE_APPLE);
            /* From the success response of apple sign-in we have to take users details from provider array object
            *  The provider object has list of user objects
            * */
            _storeSocialProfileData(
                appleSignInAccount.user.providerData[0].displayName,
                appleSignInAccount.user.providerData[0].email,
                appleSignInAccount.user.providerData[0].photoURL);
            print("appleSignInAccount = $appleSignInAccount");
            var appleLoginRequest = SocialLoginRequest(
                username:
                    appleSignInAccount.user.providerData[0].displayName ?? "",
                deviceId: deviceId,
                accessToken: appleAccessToken,
                appVersion: appVersionCode,
                isEmail: "0",
                platForm: DeviceUtils.getPlatform(),
                deviceToken: pushToken);

            _loginBloc.add(LoginClickEvent(
                loginRequest: appleLoginRequest,
                isSocialLogin: IsSocialLogin.Yes));
          }
        });
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _storeSocialProfileData(
      String profileName, String email, String photoUrl) async {
    await _sharedPrefs.addSocialProfileData(1, profileName, email, photoUrl);
  }

  _storeLoginType(int loginType) async {
    await _sharedPrefs.addLoginType(loginType);
  }

  _blocLoginListener(BuildContext context, LoginState state) {
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
      _navigateRespectiveScreens(
          state.isSocialLogin, state.loginResponse.isCar.toString());
    }
  }

  _navigateRespectiveScreens(IsSocialLogin isSocialLogin, String isCar) {
    if (isSocialLogin == IsSocialLogin.Yes) {
      // Signed in with Google, Facebook, Apple
      if (isCar == "1") {
        // This user already registered and entered car details
        // So navigating him directly to Home screen
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteConstants.ROUTE_HOME_SCREEN,
          (route) => false,
        );
      } else {
        // This user registering as new user and no car details found
        // So navigating him to Add Car screen to fill details
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConstants.ROUTE_ADD_CAR, (route) => false,
            arguments: AddCarNavFrom.Login);
      }
    } else {
      // Signed in with Email or Phone number
      Navigator.pushNamed(context, RouteConstants.ROUTE_OTP_VERIFICATION);
    }
  }
}
