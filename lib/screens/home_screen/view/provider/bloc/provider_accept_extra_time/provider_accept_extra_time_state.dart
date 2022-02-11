import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_accept_extra_time/provider_accept_extra_time_response.dart';


abstract class ProviderAcceptExtraTimeState extends Equatable {
  const ProviderAcceptExtraTimeState();

  @override
  List<Object> get props => [];
}

class ProviderAcceptExtraTimeEmpty extends ProviderAcceptExtraTimeState {}

class ProviderAcceptExtraTimeLoading extends ProviderAcceptExtraTimeState {}

class ProviderAcceptExtraTimeError extends ProviderAcceptExtraTimeState {
  final String message;

  const ProviderAcceptExtraTimeError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class ProviderAcceptExtraTimeSuccess extends ProviderAcceptExtraTimeState {
  final ProviderAcceptExtraTimeResponse providerAcceptExtraTimeResponse;

  const ProviderAcceptExtraTimeSuccess({@required this.providerAcceptExtraTimeResponse})
      : assert(providerAcceptExtraTimeResponse != null);

  @override
  List<Object> get props => [providerAcceptExtraTimeResponse];
}
