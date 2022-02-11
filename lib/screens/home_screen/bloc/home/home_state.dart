import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeEmpty extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class HomeSuccess extends HomeState {
  final HomeResponse homeResponse;

  const HomeSuccess({@required this.homeResponse})
      : assert(homeResponse != null);

  @override
  List<Object> get props => [homeResponse];
}
