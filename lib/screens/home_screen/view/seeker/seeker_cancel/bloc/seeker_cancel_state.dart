import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_response.dart';

abstract class SeekerCancelState extends Equatable {
  const SeekerCancelState();

  @override
  List<Object> get props => [];
}

class SeekerCancelEmpty extends SeekerCancelState {}

class SeekerCancelLoading extends SeekerCancelState {}

class SeekerCancelError extends SeekerCancelState {
  final String message;

  const SeekerCancelError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class SeekerCancelSuccess extends SeekerCancelState {
  final SeekerCancelResponse seekerCancelResponse;

  const SeekerCancelSuccess({@required this.seekerCancelResponse})
      : assert(seekerCancelResponse != null);

  @override
  List<Object> get props => [seekerCancelResponse];
}
