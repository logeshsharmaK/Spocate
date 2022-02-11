import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';

abstract class UpdateLocationState extends Equatable {
  const UpdateLocationState();

  @override
  List<Object> get props => [];
}

class UpdateLocationEmpty extends UpdateLocationState {}

class UpdateLocationLoading extends UpdateLocationState {}

class UpdateLocationError extends UpdateLocationState {
  final String message;

  const UpdateLocationError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class UpdateLocationSuccess extends UpdateLocationState {
  final UpdateLocationResponse updateLocationResponse;

  const UpdateLocationSuccess({@required this.updateLocationResponse})
      : assert(updateLocationResponse != null);

  @override
  List<Object> get props => [updateLocationResponse];
}
