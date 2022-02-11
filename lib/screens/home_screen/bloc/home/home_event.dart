import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}
class HomeInitEvent extends HomeEvent {
  final HomeRequest homeRequest;

  const HomeInitEvent({@required this.homeRequest});

  @override
  List<Object> get props => [homeRequest];
}
