import 'package:meta/meta.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import '../../../core/constants/enum_constants.dart';
import 'login_response.dart';

class LoginRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  LoginResponse loginResponse;

  LoginRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<LoginResponse> submitLogin(dynamic loginRequest,
      IsSocialLogin isSocialLogin) async {
    final response =
    await webservice.postAPICall(WebConstants.ACTION_LOGIN, loginRequest);
    loginResponse = LoginResponse.fromJson(response);

    if (isSocialLogin == IsSocialLogin.Yes) {
      await sharedPrefs.addSocialUserDetails(
          loginResponse.userId,
          loginResponse.isCar.toString(),
          loginResponse.username,
          loginResponse.isEmail.toString());
    } else {
      await sharedPrefs.addNonSocialProfileData(
          0, loginResponse.username, loginResponse.isEmail.toString() , loginResponse.isEmail == 1 ? loginResponse.username : "");
      // Storing OTP and Username for OTP screen
      await sharedPrefs.addOTPAndUserNameAndIsEmail(
          loginResponse.verificationCode,
          loginResponse.username,
          loginResponse.isEmail.toString());
    }
    return loginResponse;
  }
}
