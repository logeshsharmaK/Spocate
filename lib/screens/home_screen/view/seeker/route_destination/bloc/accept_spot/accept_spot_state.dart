import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/accept_spot/accept_spot_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';

abstract class AcceptSpotState extends Equatable {
  const AcceptSpotState();

  @override
  List<Object> get props => [];
}

class AcceptSpotEmpty extends AcceptSpotState {}

class AcceptSpotLoading extends AcceptSpotState {}

class AcceptSpotError extends AcceptSpotState {
  final String message;

  const AcceptSpotError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class AcceptSpotSuccess extends AcceptSpotState {
  final AcceptSpotResponse acceptSpotResponse;

  const AcceptSpotSuccess({@required this.acceptSpotResponse})
      : assert(acceptSpotResponse != null);

  @override
  List<Object> get props => [acceptSpotResponse];
}
