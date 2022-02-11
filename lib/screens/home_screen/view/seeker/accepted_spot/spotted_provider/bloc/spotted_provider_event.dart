import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_request.dart';


abstract class SpottedProviderEvent extends Equatable {
  const SpottedProviderEvent();
}

class SpottedProviderClickEvent extends SpottedProviderEvent {
  final SpottedProviderRequest spottedProviderRequest;

  const SpottedProviderClickEvent({@required this.spottedProviderRequest});

  @override
  List<Object> get props => [spottedProviderRequest];
}
