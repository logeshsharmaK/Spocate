import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/wait_for_seeker/provider_waiting_request.dart';

abstract class ProviderWaitEvent extends Equatable {
  const ProviderWaitEvent();
}

class ProviderWaitClickEvent extends ProviderWaitEvent {
  final ProviderWaitingRequest providerWaitingRequest;

  const ProviderWaitClickEvent({@required this.providerWaitingRequest});

  @override
  List<Object> get props => [providerWaitingRequest];
}
