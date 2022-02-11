import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/repo/unpark/unpark_response.dart';

abstract class UnParkState extends Equatable {
  const UnParkState();

  @override
  List<Object> get props => [];
}

class UnParkEmpty extends UnParkState {}

class UnParkLoading extends UnParkState {}

class UnParkError extends UnParkState {
  final String message;

  const UnParkError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class UnParkSuccess extends UnParkState {
  final UnParkResponse unParkResponse;

  const UnParkSuccess({@required this.unParkResponse})
      : assert(unParkResponse != null);

  @override
  List<Object> get props => [unParkResponse];
}
