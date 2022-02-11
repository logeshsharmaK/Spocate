import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_response.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileEmpty extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class ProfileSuccess extends ProfileState {
  final ProfileResponse profileResponse;

  const ProfileSuccess({@required this.profileResponse}) : assert(profileResponse != null);

  @override
  List<Object> get props => [profileResponse];
}
