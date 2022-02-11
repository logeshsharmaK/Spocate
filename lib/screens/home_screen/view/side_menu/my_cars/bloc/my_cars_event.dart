import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_request.dart';

abstract class MyCarsEvent extends Equatable {
  const MyCarsEvent();
}

class MyCarsClickEvent extends MyCarsEvent {
  final MyCarsRequest myCarsRequest;

  const MyCarsClickEvent({@required this.myCarsRequest});

  @override
  List<Object> get props => [myCarsRequest];
}

