import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_ignore_extra_time/provider_ignore_extra_time_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_ignore_extra_time/provider_ignore_extra_time_state.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';



class ProviderIgnoreExtraTimeBloc extends Bloc<ProviderIgnoreExtraTimeEvent, ProviderIgnoreExtraTimeState> {
  final ProviderRepository repository;

  ProviderIgnoreExtraTimeBloc({@required this.repository}) : super(ProviderIgnoreExtraTimeEmpty());

  @override
  ProviderIgnoreExtraTimeState get initialState => ProviderIgnoreExtraTimeEmpty();

  @override
  Stream<ProviderIgnoreExtraTimeState> mapEventToState(ProviderIgnoreExtraTimeEvent event) async* {
    if (event is ProviderIgnoreExtraTimeClickEvent) {
      yield ProviderIgnoreExtraTimeLoading();
      try {
        var response =
            await repository.submitProviderIgnoreExtraTime(event.providerIgnoreExtraTimeRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProviderIgnoreExtraTimeSuccess(providerIgnoreExtraTimeResponse: response);
        } else {
          yield ProviderIgnoreExtraTimeError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProviderIgnoreExtraTimeError(
            message: "Unable to process your request right now");
      }
    }
  }
}
