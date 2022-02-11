import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/ignore_spot/ignore_spot_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';

import 'ignore_spot_state.dart';

class IgnoreSpotBloc extends Bloc<IgnoreSpotEvent, IgnoreSpotState> {
  final RouteToDestRepository repository;

  IgnoreSpotBloc({@required this.repository}) : super(IgnoreSpotEmpty());

  @override
  IgnoreSpotState get initialState => IgnoreSpotEmpty();

  @override
  Stream<IgnoreSpotState> mapEventToState(IgnoreSpotEvent event) async* {
    if (event is IgnoreSpotClickEvent) {
      yield IgnoreSpotLoading();
      try {
        var response =
            await repository.submitIgnoreSpot(event.ignoreSpotRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield IgnoreSpotSuccess(ignoreSpotResponse: response);
        } else {
          yield IgnoreSpotError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield IgnoreSpotError(
            message: "Unable to process your request right now");
      }
    }
  }
}
