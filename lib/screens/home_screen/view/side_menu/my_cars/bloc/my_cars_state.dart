import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_response.dart';

abstract class MyCarsState extends Equatable {
  const MyCarsState();

  @override
  List<Object> get props => [];
}

class MyCarsEmpty extends MyCarsState {}

class MyCarsLoading extends MyCarsState {}

class MyCarsError extends MyCarsState {
  final String message;

  const MyCarsError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class MyCarsSuccess extends MyCarsState {
  final MyCarsResponse myCarsResponse;

  const MyCarsSuccess({@required this.myCarsResponse})
      : assert(myCarsResponse != null);

  @override
  List<Object> get props => [myCarsResponse];
}
