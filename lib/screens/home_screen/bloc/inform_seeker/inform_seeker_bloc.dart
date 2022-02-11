import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_event.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_state.dart';
import 'package:spocate/screens/home_screen/bloc/inform_seeker/inform_seeker_event.dart';
import 'package:spocate/screens/home_screen/bloc/inform_seeker/inform_seeker_state.dart';
import 'package:spocate/screens/home_screen/repo/home_repo.dart';

class InformSeekerBloc extends Bloc<InformSeekerEvent, InformSeekerState> {
  final HomeRepository repository;

  InformSeekerBloc({@required this.repository}) : super(InformSeekerEmpty());

  @override
  InformSeekerState get initialState => InformSeekerEmpty();

  @override
  Stream<InformSeekerState> mapEventToState(InformSeekerEvent event) async* {
    if (event is InformSeekerClickEvent) {
      yield InformSeekerLoading();
      try {
        var response = await repository.submitProviderDecidesToWait(event.informSeekerRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield InformSeekerSuccess(informSeekerResponse: response, isProviderWait: event.informSeekerRequest.isWait);
        } else {
          yield InformSeekerError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield InformSeekerError(message: "Unable to process your request right now");
      }
    }
  }
}
