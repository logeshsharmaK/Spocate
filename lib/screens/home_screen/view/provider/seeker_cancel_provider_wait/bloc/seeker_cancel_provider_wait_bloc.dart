import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/bloc/seeker_cancel_provider_wait_event.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/bloc/seeker_cancel_provider_wait_state.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_repo.dart';


class SeekerCancelProviderWaitBloc extends Bloc<SeekerCancelProviderWaitEvent, SeekerCancelProviderWaitState> {
  final SeekerCancelProviderWaitRepository repository;

  SeekerCancelProviderWaitBloc({@required this.repository}) : super(SeekerCancelProviderWaitEmpty());

  @override
  SeekerCancelProviderWaitState get initialState => SeekerCancelProviderWaitEmpty();

  @override
  Stream<SeekerCancelProviderWaitState> mapEventToState(SeekerCancelProviderWaitEvent event) async* {
    if (event is SeekerCancelProviderWaitClickEvent) {
      yield SeekerCancelProviderWaitLoading();
      try {
        var response = await repository.submitSeekerCancelProviderWait(event.seekerCancelProviderWaitRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield SeekerCancelProviderWaitSuccess(seekerCancelProviderWaitResponse: response, isWait: event.isWait);
        } else {
          yield SeekerCancelProviderWaitError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield SeekerCancelProviderWaitError(
            message: "Unable to process your request right now");
      }
    }
  }
}
