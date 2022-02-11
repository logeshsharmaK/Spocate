import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/spotted_seeker/spotted_seeker_response.dart';

abstract class SpottedSeekerState extends Equatable {
  const SpottedSeekerState();

  @override
  List<Object> get props => [];
}

class SpottedSeekerEmpty extends SpottedSeekerState {}

class SpottedSeekerLoading extends SpottedSeekerState {}

class SpottedSeekerError extends SpottedSeekerState {
  final String message;
  const SpottedSeekerError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class SpottedSeekerSuccess extends SpottedSeekerState {
  final SpottedSeekerResponse spottedSeekerResponse;
  final String isSpotted;

  const SpottedSeekerSuccess({@required this.spottedSeekerResponse, this.isSpotted}) : assert(spottedSeekerResponse != null);

  @override
  List<Object> get props => [spottedSeekerResponse];
}
