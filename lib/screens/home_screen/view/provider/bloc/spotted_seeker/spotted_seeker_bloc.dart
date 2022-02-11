import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';

import 'spotted_seeker_event.dart';
import 'spotted_seeker_state.dart';

class SpottedSeekerBloc extends Bloc<SpottedSeekerEvent, SpottedSeekerState> {
  final ProviderRepository repository;

  SpottedSeekerBloc({@required this.repository}) : super(SpottedSeekerEmpty());

  @override
  SpottedSeekerState get initialState => SpottedSeekerEmpty();

  @override
  Stream<SpottedSeekerState> mapEventToState(SpottedSeekerEvent event) async* {
    if (event is SpottedSeekerClickEvent) {
      yield SpottedSeekerLoading();
      try {
        var response = await repository.submitSpottedSeeker(event.spottedSeekerRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          // We are sending the isSpotted value from the event to state to know whether the provider spotted or not
          // With this if condition handled to make decisions
          yield SpottedSeekerSuccess(spottedSeekerResponse: response, isSpotted: event.spottedSeekerRequest.isSpotted);
        } else {
          yield SpottedSeekerError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield SpottedSeekerError(
            message: "Unable to process your request right now");
      }
    }
  }
}
