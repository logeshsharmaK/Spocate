import 'package:meta/meta.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'logout_response.dart';


class LogoutRepository {
  final Webservice webservice;

  LogoutRepository(
      {@required this.webservice})
      : assert(webservice != null);

  Future<LogoutResponse> submitLogout(dynamic logoutRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_LOGOUT,logoutRequest);
    return LogoutResponse.fromJson(response);
  }
}
