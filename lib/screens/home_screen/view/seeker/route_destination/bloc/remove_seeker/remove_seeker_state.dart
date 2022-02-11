import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/remove_seeker/remove_seeker_response.dart';

abstract class RemoveSeekerState extends Equatable {
  const RemoveSeekerState();

  @override
  List<Object> get props => [];
}

class RemoveSeekerEmpty extends RemoveSeekerState {}

class RemoveSeekerLoading extends RemoveSeekerState {}

class RemoveSeekerError extends RemoveSeekerState {
  final String message;

  const RemoveSeekerError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class RemoveSeekerSuccess extends RemoveSeekerState {
  final RemoveSeekerResponse removeSeekerResponse;

  const RemoveSeekerSuccess({@required this.removeSeekerResponse})
      : assert(removeSeekerResponse != null);

  @override
  List<Object> get props => [removeSeekerResponse];
}
