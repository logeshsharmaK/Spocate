import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/remove_seeker/remove_seeker_request.dart';

abstract class RemoveSeekerEvent extends Equatable {
  const RemoveSeekerEvent();
}

class RemoveSeekerClickEvent extends RemoveSeekerEvent {
  final RemoveSeekerRequest removeSeekerRequest;

  const RemoveSeekerClickEvent({@required this.removeSeekerRequest});

  @override
  List<Object> get props => [removeSeekerRequest];
}
