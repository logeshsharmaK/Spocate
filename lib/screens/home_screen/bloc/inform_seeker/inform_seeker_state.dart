import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/repo/home/home_response.dart';
import 'package:spocate/screens/home_screen/repo/inform_seeker/inform_seeker_response.dart';

abstract class InformSeekerState extends Equatable {
  const InformSeekerState();

  @override
  List<Object> get props => [];
}

class InformSeekerEmpty extends InformSeekerState {}

class InformSeekerLoading extends InformSeekerState {}

class InformSeekerError extends InformSeekerState {
  final String message;

  const InformSeekerError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class InformSeekerSuccess extends InformSeekerState {
  final InformSeekerResponse informSeekerResponse;
  final String isProviderWait;

  const InformSeekerSuccess({@required this.informSeekerResponse,this.isProviderWait})
      : assert(informSeekerResponse != null);

  @override
  List<Object> get props => [informSeekerResponse,isProviderWait];
}
