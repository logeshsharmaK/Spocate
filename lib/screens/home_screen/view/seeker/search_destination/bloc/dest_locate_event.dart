import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_response.dart';

abstract class DestLocateEvent extends Equatable {
  const DestLocateEvent();
}

class DestLocateClickEvent extends DestLocateEvent {
  final DestLocateRequest destLocateRequest;

  const DestLocateClickEvent({@required this.destLocateRequest});

  @override
  List<Object> get props => [destLocateRequest];
}
