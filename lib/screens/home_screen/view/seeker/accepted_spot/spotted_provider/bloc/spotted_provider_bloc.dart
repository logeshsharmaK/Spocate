import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_repo.dart';



class SpottedProviderBloc extends Bloc<SpottedProviderEvent, SpottedProviderState> {
  final SpottedProviderRepository repository;

  SpottedProviderBloc({@required this.repository}) : super(SpottedProviderEmpty());

  @override
  SpottedProviderState get initialState => SpottedProviderEmpty();

  @override
  Stream<SpottedProviderState> mapEventToState(SpottedProviderEvent event) async* {

    if (event is SpottedProviderClickEvent) {
      yield SpottedProviderLoading();
      try {
        var response =
            await repository.submitSpottedProvider(event.spottedProviderRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield SpottedProviderSuccess(spottedProviderResponse: response,isSpotted:event.spottedProviderRequest.isSpotted);
        } else {
          yield SpottedProviderError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield SpottedProviderError(
            message: "Unable to process your request right now");
      }
    }
  }
}
