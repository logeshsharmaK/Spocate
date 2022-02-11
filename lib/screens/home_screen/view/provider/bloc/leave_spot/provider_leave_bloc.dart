import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';

import 'provider_leave_event.dart';
import 'provider_leave_state.dart';

class ProviderLeaveBloc extends Bloc<ProviderLeaveEvent, ProviderLeaveState> {
  final ProviderRepository repository;

  ProviderLeaveBloc({@required this.repository}) : super(ProviderLeaveEmpty());

  @override
  ProviderLeaveState get initialState => ProviderLeaveEmpty();

  @override
  Stream<ProviderLeaveState> mapEventToState(ProviderLeaveEvent event) async* {

    if (event is ProviderLeaveClickEvent) {
      yield ProviderLeaveLoading();
      try {
        var response =
            await repository.submitProviderLeaveSpot(event.providerLeavingRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield ProviderLeaveSuccess(providerLeaveResponse: response);
        } else {
          yield ProviderLeaveError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield ProviderLeaveError(
            message: "Unable to process your request right now");
      }
    }
  }
}
