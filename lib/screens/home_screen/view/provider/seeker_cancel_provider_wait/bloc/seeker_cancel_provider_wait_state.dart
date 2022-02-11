import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_response.dart';


abstract class SeekerCancelProviderWaitState extends Equatable {
  const SeekerCancelProviderWaitState();

  @override
  List<Object> get props => [];
}

class SeekerCancelProviderWaitEmpty extends SeekerCancelProviderWaitState {}

class SeekerCancelProviderWaitLoading extends SeekerCancelProviderWaitState {}

class SeekerCancelProviderWaitError extends SeekerCancelProviderWaitState {
  final String message;

  const SeekerCancelProviderWaitError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class SeekerCancelProviderWaitSuccess extends SeekerCancelProviderWaitState {
  final SeekerCancelProviderWaitResponse seekerCancelProviderWaitResponse;
  final String isWait;

  const SeekerCancelProviderWaitSuccess({@required this.seekerCancelProviderWaitResponse, @required this.isWait})
      : assert(seekerCancelProviderWaitResponse != null);

  @override
  List<Object> get props => [seekerCancelProviderWaitResponse];
}
