import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_cancel/provider_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_cancel/provider_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_repo.dart';


class ProviderCancelBloc extends Bloc<ProviderCancelEvent, ProviderCancelState> {
  final ProviderCancelRepository repository;

  ProviderCancelBloc({@required this.repository}) : super(ProviderCancelEmpty());

  @override
  ProviderCancelState get initialState => ProviderCancelEmpty();

  @override
  Stream<ProviderCancelState> mapEventToState(ProviderCancelEvent event) async* {
    if (event is ProviderCancelClickEvent) {
      yield ProviderCancelLoading();
      try {
        var response =
            await repository.submitProviderCancel(event.providerCancelRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProviderCancelSuccess(providerCancelResponse: response);
        } else {
          yield ProviderCancelError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProviderCancelError(
            message: "Unable to process your request right now");
      }
    }
  }
}
