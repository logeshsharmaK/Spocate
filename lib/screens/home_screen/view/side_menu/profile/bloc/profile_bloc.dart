import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/bloc/profile_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/bloc/profile_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_repo.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileBloc({@required this.repository}) : super(ProfileEmpty());

  @override
  ProfileState get initialState => ProfileEmpty();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileClickEvent) {
      yield ProfileLoading();
      try {
        var response = await repository.submitProfile(event.profileRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProfileSuccess(profileResponse: response);
        } else {
          yield ProfileError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProfileError(message: "Unable to process your request right now");
      }
    }
  }
}
