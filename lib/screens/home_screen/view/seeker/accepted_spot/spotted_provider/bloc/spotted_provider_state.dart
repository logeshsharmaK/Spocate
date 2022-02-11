import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_response.dart';


abstract class SpottedProviderState extends Equatable {
  const SpottedProviderState();

  @override
  List<Object> get props => [];
}

class SpottedProviderEmpty extends SpottedProviderState {}

class SpottedProviderLoading extends SpottedProviderState {}

class SpottedProviderError extends SpottedProviderState {
  final String message;
  const SpottedProviderError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class SpottedProviderSuccess extends SpottedProviderState {
  final SpottedProviderResponse spottedProviderResponse;
  final String isSpotted;

  const SpottedProviderSuccess({@required this.spottedProviderResponse,this.isSpotted}) : assert(spottedProviderResponse != null);

  @override
  List<Object> get props => [spottedProviderResponse,isSpotted];
}
