import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_request.dart';

abstract class SeekerExtraTimeEvent extends Equatable {
  const SeekerExtraTimeEvent();
}

class SeekerExtraTimeClickEvent extends SeekerExtraTimeEvent {
  final SeekerExtraTimeRequest seekerExtraTimeRequest;

  const SeekerExtraTimeClickEvent({@required this.seekerExtraTimeRequest});

  @override
  List<Object> get props => [seekerExtraTimeRequest];
}
