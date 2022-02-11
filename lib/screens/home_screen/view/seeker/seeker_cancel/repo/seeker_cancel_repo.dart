import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_response.dart';

class SeekerCancelRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  SeekerCancelRequest seekerCancelRequest;

  SeekerCancelRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<SeekerCancelResponse> submitSeekerCancel(
      dynamic seekerCancelRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_SEEKER_CANCEL, seekerCancelRequest);
    return SeekerCancelResponse.fromJson(response);
  }
}
