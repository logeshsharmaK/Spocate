import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';
import 'package:spocate/screens/home_screen/repo/home/home_request.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/repo/inform_seeker/inform_seeker_request.dart';
import 'package:spocate/screens/login/repo/login_request.dart';

abstract class InformSeekerEvent extends Equatable {
  const InformSeekerEvent();
}
class InformSeekerClickEvent extends InformSeekerEvent {
  final InformSeekerRequest informSeekerRequest;

  const InformSeekerClickEvent({@required this.informSeekerRequest});

  @override
  List<Object> get props => [informSeekerRequest];
}
