import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_response.dart';

abstract class DestLocateState extends Equatable {
  const DestLocateState();

  @override
  List<Object> get props => [];
}

class DestLocateEmpty extends DestLocateState {}

class DestLocateLoading extends DestLocateState {}

class DestLocateError extends DestLocateState {
  final String message;

  const DestLocateError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class DestLocateSuccess extends DestLocateState {
  final DestLocateResponse destLocateResponse;

  const DestLocateSuccess({@required this.destLocateResponse})
      : assert(destLocateResponse != null);

  @override
  List<Object> get props => [destLocateResponse];
}
