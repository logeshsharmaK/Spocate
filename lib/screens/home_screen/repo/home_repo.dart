import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/repo/inform_seeker/inform_seeker_response.dart';
import 'package:spocate/screens/home_screen/repo/unpark/unpark_response.dart';

class HomeRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  HomeResponse homeResponse;
  UnParkResponse unParkResponse;
  InformSeekerResponse informSeekerResponse;

  HomeRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<HomeResponse> getHomeDetails(dynamic homeRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_HOME_DETAILS, homeRequest);
    homeResponse = HomeResponse.fromJson(response);
    // Storing user info and car info from home screen details
    // Storing support contacts for support screen
    await sharedPrefs.addUserInfo(homeResponse.userInfo);
    await sharedPrefs.addCarInfo(homeResponse.carInfo);
    await sharedPrefs.setSupportContacts(
        homeResponse.supportMobile, homeResponse.supportEmail);
    return homeResponse;
  }

  Future<UnParkResponse> submitUnPark(dynamic unParkRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_HOME_UN_PARK, unParkRequest);
    unParkResponse = UnParkResponse.fromJson(response);
    return unParkResponse;
  }
  Future<InformSeekerResponse> submitProviderDecidesToWait(dynamic providerWaitRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_HOME_PROVIDER_DECISION_CONFIRM, providerWaitRequest);
    informSeekerResponse = InformSeekerResponse.fromJson(response);
    return informSeekerResponse;
  }
}
