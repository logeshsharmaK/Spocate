import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/leave_spot/provider_leaving_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/refresh_location/refresh_location_request.dart';

abstract class RefreshLocationEvent extends Equatable {
  const RefreshLocationEvent();
}

class RefreshLocationTriggerEvent extends RefreshLocationEvent {
  final RefreshLocationRequest refreshLocationRequest;

  const RefreshLocationTriggerEvent({@required this.refreshLocationRequest});

  @override
  List<Object> get props => [refreshLocationRequest];
}
