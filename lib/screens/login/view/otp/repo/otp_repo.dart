import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_response.dart';


class OTPRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  OTPResponse otpResponse;

  OTPRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<OTPResponse> submitOTPVerify(dynamic loginRequest) async {
    final response =
        await webservice.postAPICall(WebConstants.ACTION_OTP_VERIFY, loginRequest);
    otpResponse = OTPResponse.fromJson(response);
    // Storing User ID for future usage and isCar for Navigation redirect
    await sharedPrefs.addUserIdAndIsCar(otpResponse.userId, otpResponse.isCar.toString());
    return otpResponse;
  }
}
