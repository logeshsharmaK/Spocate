import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/update/my_cars_update_response.dart';

abstract class MyCarsUpdateState extends Equatable {
  const MyCarsUpdateState();

  @override
  List<Object> get props => [];
}

class MyCarsUpdateEmpty extends MyCarsUpdateState {}

class MyCarsUpdateLoading extends MyCarsUpdateState {}

class MyCarsUpdateError extends MyCarsUpdateState {
  final String message;

  const MyCarsUpdateError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class MyCarsUpdateSuccess extends MyCarsUpdateState {
  final MyCarsUpdateResponse myCarsUpdateResponse;
  final int myCarDefaultIndex ;

  const MyCarsUpdateSuccess({@required this.myCarsUpdateResponse, @required this.myCarDefaultIndex})
      : assert(myCarsUpdateResponse != null);

  @override
  List<Object> get props => [myCarsUpdateResponse];
}
