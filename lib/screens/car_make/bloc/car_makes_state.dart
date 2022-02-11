import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/car_make/repo/car_makes_response.dart';

abstract class CarMakeListState extends Equatable {
  const CarMakeListState();

  @override
  List<Object> get props => [];
}

class CarMakeListEmpty extends CarMakeListState {}

class CarMakeListLoading extends CarMakeListState {}

class CarMakeListError extends CarMakeListState {
  final String message;
  const CarMakeListError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class CarMakeListSuccess extends CarMakeListState {
  final CarMakeListResponse carListResponse;

  const CarMakeListSuccess({@required this.carListResponse}) : assert(carListResponse != null);

  @override
  List<Object> get props => [carListResponse];
}
