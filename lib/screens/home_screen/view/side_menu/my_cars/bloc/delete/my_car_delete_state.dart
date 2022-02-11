import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/delete/my_car_delete_response.dart';

abstract class MyCarDeleteState extends Equatable {
  const MyCarDeleteState();

  @override
  List<Object> get props => [];
}

class MyCarDeleteEmpty extends MyCarDeleteState {}

class MyCarDeleteLoading extends MyCarDeleteState {}

class MyCarDeleteError extends MyCarDeleteState {
  final String message;

  const MyCarDeleteError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class MyCarDeleteSuccess extends MyCarDeleteState {
  final MyCarDeleteResponse myCarDeleteResponse;

  const MyCarDeleteSuccess({@required this.myCarDeleteResponse})
      : assert(myCarDeleteResponse != null);

  @override
  List<Object> get props => [myCarDeleteResponse];
}
