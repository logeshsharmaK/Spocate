import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/update/my_cars_update_request.dart';


abstract class MyCarsUpdateEvent extends Equatable {
  const MyCarsUpdateEvent();
}
class MyCarsUpdateClickEvent extends MyCarsUpdateEvent {
  final MyCarsUpdateRequest myCarsUpdateRequest;
  final int myCarDefaultIndex;

  const MyCarsUpdateClickEvent({@required this.myCarsUpdateRequest,@required this.myCarDefaultIndex});

  @override
  List<Object> get props => [myCarsUpdateRequest];
}
