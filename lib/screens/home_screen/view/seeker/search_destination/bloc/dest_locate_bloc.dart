import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/bloc/dest_locate_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/dest_locate_repo.dart';

import 'dest_locate_event.dart';

class DestLocateBloc extends Bloc<DestLocateEvent, DestLocateState> {
  final DestLocateRepository repository;

  DestLocateBloc({@required this.repository}) : super(DestLocateEmpty());

  @override
  DestLocateState get initialState => DestLocateEmpty();

  @override
  Stream<DestLocateState> mapEventToState(DestLocateEvent event) async* {
    if (event is DestLocateClickEvent) {
      yield DestLocateLoading();
      try {
        var response =
            await repository.submitLocateDestination(event.destLocateRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield DestLocateSuccess(destLocateResponse: response);
        } else {
          yield DestLocateError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield DestLocateError(
            message: "Unable to process your request right now");
      }
    }
  }
}
