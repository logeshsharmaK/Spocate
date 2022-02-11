import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_response.dart';

abstract class SeekerExtraTimeState extends Equatable {
  const SeekerExtraTimeState();

  @override
  List<Object> get props => [];
}

class SeekerExtraTimeEmpty extends SeekerExtraTimeState {}

class SeekerExtraTimeLoading extends SeekerExtraTimeState {}

class SeekerExtraTimeError extends SeekerExtraTimeState {
  final String message;

  const SeekerExtraTimeError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class SeekerExtraTimeSuccess extends SeekerExtraTimeState {
  final SeekerExtraTimeResponse seekerExtraTimeResponse;

  const SeekerExtraTimeSuccess({@required this.seekerExtraTimeResponse})
      : assert(SeekerExtraTimeResponse != null);

  @override
  List<Object> get props => [seekerExtraTimeResponse];
}
