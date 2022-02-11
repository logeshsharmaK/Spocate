import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';

import 'accept_spot_event.dart';
import 'accept_spot_state.dart';


class AcceptSpotBloc extends Bloc<AcceptSpotEvent, AcceptSpotState> {
  final RouteToDestRepository repository;

  AcceptSpotBloc({@required this.repository}) : super(AcceptSpotEmpty());

  @override
  AcceptSpotState get initialState => AcceptSpotEmpty();

  @override
  Stream<AcceptSpotState> mapEventToState(AcceptSpotEvent event) async* {
    if (event is AcceptSpotClickEvent) {
      yield AcceptSpotLoading();
      try {
        print("Bloc acceptSpotRequest ${event.acceptSpotRequest}");
        print("Bloc providerData ${event.providerData}");
        var response =
            await repository.submitAcceptSpot(event.acceptSpotRequest, event.providerData);
        print("Bloc response ${response.toJson()}");
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {

          yield AcceptSpotSuccess(acceptSpotResponse: response);
        } else {
          yield AcceptSpotError(message: "${response.message}");
        }
      } catch (_) {
        print("Bloc exception $_");
        yield AcceptSpotError(
            message: "Unable to process your request right now");
      }
    }
  }
}
