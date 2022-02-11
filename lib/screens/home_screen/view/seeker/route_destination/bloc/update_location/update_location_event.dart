import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_request.dart';


abstract class UpdateLocationEvent extends Equatable {
  const UpdateLocationEvent();
}
class UpdateLocationInitEvent extends UpdateLocationEvent {
  final UpdateLocationRequest updateLocationRequest;

  const UpdateLocationInitEvent({@required this.updateLocationRequest});

  @override
  List<Object> get props => [updateLocationRequest];
}
