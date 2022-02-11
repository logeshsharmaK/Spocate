import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_request.dart';


abstract class TimeAndDistanceEvent extends Equatable {
  const TimeAndDistanceEvent();
}

class TimeAndDistanceTriggerEvent extends TimeAndDistanceEvent {
  final String sourceLatLong;
  final String destLatLong;
  final String travelMode;

  const TimeAndDistanceTriggerEvent({@required this.sourceLatLong, this.destLatLong,this.travelMode});

  @override
  List<Object> get props => [sourceLatLong,destLatLong];
}
