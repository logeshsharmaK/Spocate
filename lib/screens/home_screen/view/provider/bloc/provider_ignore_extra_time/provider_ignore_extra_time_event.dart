import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_ignore_extra_time/provider_ignore_extra_time_request.dart';

abstract class ProviderIgnoreExtraTimeEvent extends Equatable {
  const ProviderIgnoreExtraTimeEvent();
}

class ProviderIgnoreExtraTimeClickEvent extends ProviderIgnoreExtraTimeEvent {
  final ProviderIgnoreExtraTimeRequest providerIgnoreExtraTimeRequest;

  const ProviderIgnoreExtraTimeClickEvent({@required this.providerIgnoreExtraTimeRequest});

  @override
  List<Object> get props => [providerIgnoreExtraTimeRequest];
}
