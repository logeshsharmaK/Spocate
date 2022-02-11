import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/repo/unpark/unpark_request.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class UnParkEvent extends Equatable {
  const UnParkEvent();
}
class UnParkClickEvent extends UnParkEvent {
  final UnParkRequest unParkRequest;

  const UnParkClickEvent({@required this.unParkRequest});

  @override
  List<Object> get props => [unParkRequest];
}
