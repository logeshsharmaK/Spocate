import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/profile/repo/profile_request.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
}

class ProfileClickEvent extends ProfileEvent {
  final ProfileRequest profileRequest;

  const ProfileClickEvent({@required this.profileRequest});

  @override
  List<Object> get props => [profileRequest];
}
