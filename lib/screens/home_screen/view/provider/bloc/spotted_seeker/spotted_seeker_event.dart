import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/spotted_seeker/spotted_seeker_request.dart';

abstract class SpottedSeekerEvent extends Equatable {
  const SpottedSeekerEvent();
}

class SpottedSeekerClickEvent extends SpottedSeekerEvent {
  final SpottedSeekerRequest spottedSeekerRequest;

  const SpottedSeekerClickEvent({@required this.spottedSeekerRequest});

  @override
  List<Object> get props => [spottedSeekerRequest];
}
