import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/leave_spot/provider_leaving_response.dart';

abstract class ProviderLeaveState extends Equatable {
  const ProviderLeaveState();

  @override
  List<Object> get props => [];
}

class ProviderLeaveEmpty extends ProviderLeaveState {}

class ProviderLeaveLoading extends ProviderLeaveState {}

class ProviderLeaveError extends ProviderLeaveState {
  final String message;
  const ProviderLeaveError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class ProviderLeaveSuccess extends ProviderLeaveState {
  final ProviderLeavingResponse providerLeaveResponse;

  const ProviderLeaveSuccess({@required this.providerLeaveResponse}) : assert(providerLeaveResponse != null);

  @override
  List<Object> get props => [providerLeaveResponse];
}
