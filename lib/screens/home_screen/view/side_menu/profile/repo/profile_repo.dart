import 'package:flutter/widgets.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_response.dart';

class ProfileRepository {
  final Webservice webservice;

  ProfileResponse profileResponse;

  ProfileRepository({@required this.webservice})
      : assert(webservice != null);

  Future<ProfileResponse> submitProfile(dynamic profileRequest) async {
    final response = await webservice.postAPICall(
        WebConstants.ACTION_PROFILE, profileRequest);
    return ProfileResponse.fromJson(response);
  }

}
