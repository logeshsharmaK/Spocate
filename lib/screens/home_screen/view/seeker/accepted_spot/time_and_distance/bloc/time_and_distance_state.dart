import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_failed_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_response.dart';


abstract class TimeAndDistanceState extends Equatable {
  const TimeAndDistanceState();

  @override
  List<Object> get props => [];
}

class TimeAndDistanceEmpty extends TimeAndDistanceState {}

class TimeAndDistanceLoading extends TimeAndDistanceState {}


class TimeAndDistanceError extends TimeAndDistanceState {
  final String message;
  const TimeAndDistanceError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

// class TimeAndDistanceError extends TimeAndDistanceState {
//   final TimeAndDistanceFailedResponse timeAndDistanceFailedResponse;
//   const TimeAndDistanceError({@required this.timeAndDistanceFailedResponse}) : assert(timeAndDistanceFailedResponse != null);
//   List<Object> get props => [timeAndDistanceFailedResponse];
// }

class TimeAndDistanceSuccess extends TimeAndDistanceState {
  final TimeAndDistanceResponse timeAndDistanceResponse;
  const TimeAndDistanceSuccess({@required this.timeAndDistanceResponse}) : assert(timeAndDistanceResponse != null);

  @override
  List<Object> get props => [timeAndDistanceResponse];
}
