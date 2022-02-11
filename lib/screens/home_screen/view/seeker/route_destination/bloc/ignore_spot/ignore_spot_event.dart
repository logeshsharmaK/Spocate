import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_request.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class IgnoreSpotEvent extends Equatable {
  const IgnoreSpotEvent();
}
class IgnoreSpotClickEvent extends IgnoreSpotEvent {
  final IgnoreSpotRequest ignoreSpotRequest;

  const IgnoreSpotClickEvent({@required this.ignoreSpotRequest});

  @override
  List<Object> get props => [ignoreSpotRequest];
}
