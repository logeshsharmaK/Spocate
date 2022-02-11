import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';

abstract class IgnoreSpotState extends Equatable {
  const IgnoreSpotState();

  @override
  List<Object> get props => [];
}

class IgnoreSpotEmpty extends IgnoreSpotState {}

class IgnoreSpotLoading extends IgnoreSpotState {}

class IgnoreSpotError extends IgnoreSpotState {
  final String message;

  const IgnoreSpotError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class IgnoreSpotSuccess extends IgnoreSpotState {
  final IgnoreSpotResponse ignoreSpotResponse;

  const IgnoreSpotSuccess({@required this.ignoreSpotResponse})
      : assert(ignoreSpotResponse != null);

  @override
  List<Object> get props => [ignoreSpotResponse];
}
