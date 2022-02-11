import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_response.dart';

abstract class ProviderCancelState extends Equatable {
  const ProviderCancelState();

  @override
  List<Object> get props => [];
}

class ProviderCancelEmpty extends ProviderCancelState {}

class ProviderCancelLoading extends ProviderCancelState {}

class ProviderCancelError extends ProviderCancelState {
  final String message;

  const ProviderCancelError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class ProviderCancelSuccess extends ProviderCancelState {
  final ProviderCancelResponse providerCancelResponse;

  const ProviderCancelSuccess({@required this.providerCancelResponse})
      : assert(providerCancelResponse != null);

  @override
  List<Object> get props => [providerCancelResponse];
}
