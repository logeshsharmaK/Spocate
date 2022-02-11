import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/wait_for_seeker/provider_waiting_response.dart';


abstract class ProviderWaitState extends Equatable {
  const ProviderWaitState();

  @override
  List<Object> get props => [];
}

class ProviderWaitEmpty extends ProviderWaitState {}

class ProviderWaitLoading extends ProviderWaitState {}

class ProviderWaitError extends ProviderWaitState {
  final String message;
  const ProviderWaitError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class ProviderWaitSuccess extends ProviderWaitState {
  final ProviderWaitingResponse providerWaitResponse;

  const ProviderWaitSuccess({@required this.providerWaitResponse}) : assert(providerWaitResponse != null);

  @override
  List<Object> get props => [providerWaitResponse];
}
