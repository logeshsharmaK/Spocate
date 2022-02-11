import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_request.dart';

class ProviderCancelRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  // ProviderCancelRequest seekerCancelRequest;

  ProviderCancelRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<ProviderCancelResponse> submitProviderCancel(
      dynamic seekerCancelRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_CANCEL, seekerCancelRequest);
    return ProviderCancelResponse.fromJson(response);
  }
}
