import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/delete/my_car_delete_request.dart';

abstract class MyCarDeleteEvent extends Equatable {
  const MyCarDeleteEvent();
}

class MyCarDeleteClickEvent extends MyCarDeleteEvent {
  final MyCarsDeleteRequest myCarsDeleteRequest;

  const MyCarDeleteClickEvent({@required this.myCarsDeleteRequest});

  @override
  List<Object> get props => [myCarsDeleteRequest];
}
