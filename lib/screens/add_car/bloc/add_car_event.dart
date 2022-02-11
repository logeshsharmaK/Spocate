import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_request.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class AddCarEvent extends Equatable {
  const AddCarEvent();
}
class AddCarClickEvent extends AddCarEvent {
  final AddCarRequest addCarRequest;

  const AddCarClickEvent({@required this.addCarRequest});

  @override
  List<Object> get props => [addCarRequest];
}
