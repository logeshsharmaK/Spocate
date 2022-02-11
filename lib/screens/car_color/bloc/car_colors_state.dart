import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/car_color/repo/car_colors_response.dart';


abstract class CarColorListState extends Equatable {
  const CarColorListState();

  @override
  List<Object> get props => [];
}

class CarColorListEmpty extends CarColorListState {}

class CarColorListLoading extends CarColorListState {}

class CarColorListError extends CarColorListState {
  final String message;
  const CarColorListError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class CarColorListSuccess extends CarColorListState {
  final CarColorListResponse carColorListResponse;

  const CarColorListSuccess({@required this.carColorListResponse}) : assert(CarColorListResponse != null);

  @override
  List<Object> get props => [CarColorListResponse];
}
