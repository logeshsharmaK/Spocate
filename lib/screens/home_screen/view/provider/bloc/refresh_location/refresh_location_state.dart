import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/refresh_location/refresh_location_response.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/spotted_seeker/spotted_seeker_response.dart';

abstract class RefreshLocationState extends Equatable {
  const RefreshLocationState();

  @override
  List<Object> get props => [];
}

class RefreshLocationEmpty extends RefreshLocationState {}

class RefreshLocationLoading extends RefreshLocationState {}

class RefreshLocationError extends RefreshLocationState {
  final String message;
  const RefreshLocationError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class RefreshLocationSuccess extends RefreshLocationState {
  final RefreshLocationResponse refreshLocationResponse;

  const RefreshLocationSuccess({@required this.refreshLocationResponse}) : assert(refreshLocationResponse != null);

  @override
  List<Object> get props => [refreshLocationResponse];
}
