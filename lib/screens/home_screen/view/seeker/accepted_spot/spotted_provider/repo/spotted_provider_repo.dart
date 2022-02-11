import 'package:flutter/widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_request_denied.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_response.dart';

class SpottedProviderRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  SpottedProviderResponse spottedProviderResponse;
  TimeAndDistanceResponse timeAndDistanceResponse;

  SpottedProviderRepository(
      {@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<SpottedProviderResponse> submitSpottedProvider(
      dynamic spottedSeekerRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_SEEKER_SPOTTED_PROVIDER, spottedSeekerRequest);
    spottedProviderResponse = SpottedProviderResponse.fromJson(response);
    return spottedProviderResponse;
  }

  Future<TimeAndDistanceResponse> getTravelTimeAndDistance(
      String sourceLatLong, String destLatLong, String travelMode) async {
    final response = await webservice.postAPICallOnlyAction(
        WebConstants.ACTION_TRAVEL_TIME_AND_DISTANCE +
            WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_1_ORIGIN +
            sourceLatLong +
            WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_2_DEST +
            destLatLong+
            WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_3_MODE +
            travelMode
    );
    // if(response is TimeAndDistanceResponse){
    //   print("GOOGLE Distance TimeAndDistanceResponse success");
    // }else if(response is TimeAndDistanceRequestDenied){
    //   print("GOOGLE Distance TimeAndDistanceRequestDenied failed");
    // }
    // var value =response.toString();
    // value.contains( "status" : "OK",0)

    timeAndDistanceResponse = TimeAndDistanceResponse.fromJson(response);
    return timeAndDistanceResponse;
  }
}
