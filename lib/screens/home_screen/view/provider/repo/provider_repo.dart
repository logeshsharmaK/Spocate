import 'package:flutter/widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/leave_spot/provider_leaving_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_accept_extra_time/provider_accept_extra_time_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_ignore_extra_time/provider_ignore_extra_time_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/refresh_location/refresh_location_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/wait_for_seeker/provider_waiting_response.dart';
import 'spotted_seeker/spotted_seeker_response.dart';


class ProviderRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;

  SpottedSeekerResponse spottedSeekerResponse;
  ProviderWaitingResponse providerWaitingResponse;
  ProviderLeavingResponse providerLeavingResponse;
  RefreshLocationResponse refreshLocationResponse;
  ProviderAcceptExtraTimeResponse providerAcceptExtraTimeResponse;
  ProviderIgnoreExtraTimeResponse providerIgnoreExtraTimeResponse;

  ProviderRepository(
      {@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<SpottedSeekerResponse> submitSpottedSeeker(dynamic spottedSeekerRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_SPOTTED_SEEKER, spottedSeekerRequest);
    spottedSeekerResponse = SpottedSeekerResponse.fromJson(response);
    return spottedSeekerResponse;
  }

  Future<ProviderWaitingResponse> submitWaitForSeeker(dynamic providerWaitingRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_WAIT_FOR_SEEKER, providerWaitingRequest);
    providerWaitingResponse = ProviderWaitingResponse.fromJson(response);
    return providerWaitingResponse;
  }

  Future<ProviderLeavingResponse> submitProviderLeaveSpot(dynamic providerLeavingRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_LEAVING_SPOT, providerLeavingRequest);
    providerLeavingResponse = ProviderLeavingResponse.fromJson(response);
    return providerLeavingResponse;
  }

  Future<RefreshLocationResponse> refreshSeekerLocation(dynamic refreshLocationRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_REFRESH_SEEKER_LOCATION_FOR_PROVIDER, refreshLocationRequest);
    refreshLocationResponse = RefreshLocationResponse.fromJson(response);
    return refreshLocationResponse;
  }

  Future<ProviderAcceptExtraTimeResponse> submitProviderAcceptExtraTime(dynamic providerAcceptExtraTimeRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_ACCEPT_EXTRA_TIME, providerAcceptExtraTimeRequest);
    providerAcceptExtraTimeResponse = ProviderAcceptExtraTimeResponse.fromJson(response);
    return providerAcceptExtraTimeResponse;
  }


  Future<ProviderIgnoreExtraTimeResponse> submitProviderIgnoreExtraTime(dynamic providerIgnoreExtraTimeRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROVIDER_IGNORE_EXTRA_TIME, providerIgnoreExtraTimeRequest);
    providerIgnoreExtraTimeResponse = ProviderIgnoreExtraTimeResponse.fromJson(response);
    return providerIgnoreExtraTimeResponse;
  }
}
