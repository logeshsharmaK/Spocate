import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_response.dart';


class SeekerCancelProviderWaitRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  SeekerCancelProviderWaitRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<SeekerCancelProviderWaitResponse> submitSeekerCancelProviderWait(
      dynamic seekerCancelProviderWaitRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_SEEKER_CANCELLED_PROVIDER_WAIT, seekerCancelProviderWaitRequest);
    return SeekerCancelProviderWaitResponse.fromJson(response);
  }
}
