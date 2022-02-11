import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/accept_spot/accept_spot_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/remove_seeker/remove_seeker_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';

class RouteToDestRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  UpdateLocationResponse updateLocationResponse;
  AcceptSpotResponse acceptSpotResponse;
  IgnoreSpotResponse ignoreSpotResponse;
  TimeAndDistanceResponse timeAndDistanceResponse;

  RouteToDestRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<UpdateLocationResponse> submitUpdateLocation(
      dynamic updateLocationRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_UPDATE_CURRENT_LOCATION, updateLocationRequest);
    updateLocationResponse = UpdateLocationResponse.fromJson(response);
    return updateLocationResponse;
  }

  Future<AcceptSpotResponse> submitAcceptSpot(
      dynamic acceptSpotRequest, ProviderData providerData) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_ACCEPT_SPOT, acceptSpotRequest);
    acceptSpotResponse = AcceptSpotResponse.fromJson(response);
    await sharedPrefs.setSpotAcceptedProviderData(providerData);
    return acceptSpotResponse;
  }

  Future<IgnoreSpotResponse> submitIgnoreSpot(dynamic ignoreSpotRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_IGNORE_SPOT, ignoreSpotRequest);
    ignoreSpotResponse = IgnoreSpotResponse.fromJson(response);
    return ignoreSpotResponse;
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
    timeAndDistanceResponse = TimeAndDistanceResponse.fromJson(response);
    return timeAndDistanceResponse;
  }

  Future<RemoveSeekerResponse> removeSeekerFromQueue(dynamic removeSeekerRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_REMOVE_SEEKER, removeSeekerRequest);
    return RemoveSeekerResponse.fromJson(response);
  }
}
