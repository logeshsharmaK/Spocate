import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_request.dart';


abstract class SeekerCancelProviderWaitEvent extends Equatable {
  const SeekerCancelProviderWaitEvent();
}

class SeekerCancelProviderWaitClickEvent extends SeekerCancelProviderWaitEvent {
  final SeekerCancelProviderWaitRequest seekerCancelProviderWaitRequest;
  final String isWait;

  const SeekerCancelProviderWaitClickEvent({@required this.seekerCancelProviderWaitRequest,@required this.isWait});

  @override
  List<Object> get props => [seekerCancelProviderWaitRequest];
}
