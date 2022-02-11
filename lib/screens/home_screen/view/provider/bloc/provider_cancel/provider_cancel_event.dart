import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_request.dart';

abstract class ProviderCancelEvent extends Equatable {
  const ProviderCancelEvent();
}

class ProviderCancelClickEvent extends ProviderCancelEvent {
  final ProviderCancelRequest providerCancelRequest;

  const ProviderCancelClickEvent({@required this.providerCancelRequest});

  @override
  List<Object> get props => [providerCancelRequest];
}
