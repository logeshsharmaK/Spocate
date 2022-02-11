import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_ignore_extra_time/provider_ignore_extra_time_response.dart';


abstract class ProviderIgnoreExtraTimeState extends Equatable {
  const ProviderIgnoreExtraTimeState();

  @override
  List<Object> get props => [];
}

class ProviderIgnoreExtraTimeEmpty extends ProviderIgnoreExtraTimeState {}

class ProviderIgnoreExtraTimeLoading extends ProviderIgnoreExtraTimeState {}

class ProviderIgnoreExtraTimeError extends ProviderIgnoreExtraTimeState {
  final String message;

  const ProviderIgnoreExtraTimeError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class ProviderIgnoreExtraTimeSuccess extends ProviderIgnoreExtraTimeState {
  final ProviderIgnoreExtraTimeResponse providerIgnoreExtraTimeResponse;

  const ProviderIgnoreExtraTimeSuccess({@required this.providerIgnoreExtraTimeResponse})
      : assert(providerIgnoreExtraTimeResponse != null);

  @override
  List<Object> get props => [providerIgnoreExtraTimeResponse];
}
