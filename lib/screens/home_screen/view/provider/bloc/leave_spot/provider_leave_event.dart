import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/leave_spot/provider_leaving_request.dart';

abstract class ProviderLeaveEvent extends Equatable {
  const ProviderLeaveEvent();
}

class ProviderLeaveClickEvent extends ProviderLeaveEvent {
  final ProviderLeavingRequest providerLeavingRequest;

  const ProviderLeaveClickEvent({@required this.providerLeavingRequest});

  @override
  List<Object> get props => [providerLeavingRequest];
}
