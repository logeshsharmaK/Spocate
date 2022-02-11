import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_accept_extra_time/provider_accept_extra_time_request.dart';

abstract class ProviderAcceptExtraTimeEvent extends Equatable {
  const ProviderAcceptExtraTimeEvent();
}

class ProviderAcceptExtraTimeClickEvent extends ProviderAcceptExtraTimeEvent {
  final ProviderAcceptExtraTimeRequest providerAcceptExtraTimeRequest;

  const ProviderAcceptExtraTimeClickEvent({@required this.providerAcceptExtraTimeRequest});

  @override
  List<Object> get props => [providerAcceptExtraTimeRequest];
}
