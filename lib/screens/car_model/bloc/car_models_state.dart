import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/car_model/repo/car_models_response.dart';

abstract class CarModelListState extends Equatable {
  const CarModelListState();

  @override
  List<Object> get props => [];
}

class CarModelListEmpty extends CarModelListState {}

class CarModelListLoading extends CarModelListState {}

class CarModelListError extends CarModelListState {
  final String message;
  const CarModelListError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class CarModelListSuccess extends CarModelListState {
  final CarModelListResponse carModelListResponse;

  const CarModelListSuccess({@required this.carModelListResponse}) : assert(carModelListResponse != null);

  @override
  List<Object> get props => [carModelListResponse];
}
