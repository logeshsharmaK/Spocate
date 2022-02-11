import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_request.dart';

abstract class SeekerCancelEvent extends Equatable {
  const SeekerCancelEvent();
}

class SeekerCancelClickEvent extends SeekerCancelEvent {
  final SeekerCancelRequest seekerCancelRequest;
  final int isSeekerForceCancelled;

  const SeekerCancelClickEvent({@required this.seekerCancelRequest, @required this.isSeekerForceCancelled});

  @override
  List<Object> get props => [seekerCancelRequest];
}
