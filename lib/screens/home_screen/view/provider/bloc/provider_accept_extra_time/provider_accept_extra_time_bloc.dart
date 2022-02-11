import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_accept_extra_time/provider_accept_extra_time_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_accept_extra_time/provider_accept_extra_time_state.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';



class ProviderAcceptExtraTimeBloc extends Bloc<ProviderAcceptExtraTimeEvent, ProviderAcceptExtraTimeState> {
  final ProviderRepository repository;

  ProviderAcceptExtraTimeBloc({@required this.repository}) : super(ProviderAcceptExtraTimeEmpty());

  @override
  ProviderAcceptExtraTimeState get initialState => ProviderAcceptExtraTimeEmpty();

  @override
  Stream<ProviderAcceptExtraTimeState> mapEventToState(ProviderAcceptExtraTimeEvent event) async* {
    if (event is ProviderAcceptExtraTimeClickEvent) {
      yield ProviderAcceptExtraTimeLoading();
      try {
        var response =
            await repository.submitProviderAcceptExtraTime(event.providerAcceptExtraTimeRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProviderAcceptExtraTimeSuccess(providerAcceptExtraTimeResponse: response);
        } else {
          yield ProviderAcceptExtraTimeError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProviderAcceptExtraTimeError(
            message: "Unable to process your request right now");
      }
    }
  }
}
