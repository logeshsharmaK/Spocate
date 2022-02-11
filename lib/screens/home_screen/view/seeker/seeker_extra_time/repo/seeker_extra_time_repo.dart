import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_response.dart';


class SeekerExtraTimeRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  SeekerExtraTimeRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<SeekerExtraTimeResponse> submitSeekerExtraTime(
      dynamic seekerExtraTimeRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_SEEKER_EXTRA_TIME, seekerExtraTimeRequest);
    return SeekerExtraTimeResponse.fromJson(response);
  }
}
