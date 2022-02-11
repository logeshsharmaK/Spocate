import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/add_car/repo/add_car_response.dart';

abstract class AddCarState extends Equatable {
  const AddCarState();

  @override
  List<Object> get props => [];
}

class AddCarEmpty extends AddCarState {}

class AddCarLoading extends AddCarState {}

class AddCarError extends AddCarState {
  final String message;

  const AddCarError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class AddCarSuccess extends AddCarState {
  final AddCarResponse addCarResponse;

  const AddCarSuccess({@required this.addCarResponse})
      : assert(addCarResponse != null);

  @override
  List<Object> get props => [addCarResponse];
}
