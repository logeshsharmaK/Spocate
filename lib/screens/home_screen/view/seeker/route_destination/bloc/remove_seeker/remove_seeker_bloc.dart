import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';


import 'remove_seeker_event.dart';
import 'remove_seeker_state.dart';


class RemoveSeekerBloc extends Bloc<RemoveSeekerEvent, RemoveSeekerState> {
  final RouteToDestRepository repository;

  RemoveSeekerBloc({@required this.repository}) : super(RemoveSeekerEmpty());

  @override
  RemoveSeekerState get initialState => RemoveSeekerEmpty();

  @override
  Stream<RemoveSeekerState> mapEventToState(RemoveSeekerEvent event) async* {
    if (event is RemoveSeekerClickEvent) {
      yield RemoveSeekerLoading();
      try {
        print("Bloc RemoveSeekerRequest ${event.removeSeekerRequest}");
        var response =
            await repository.removeSeekerFromQueue(event.removeSeekerRequest);
        print("Bloc response ${response.toJson()}");
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield RemoveSeekerSuccess(removeSeekerResponse: response);
        } else {
          yield RemoveSeekerError(message: "${response.message}");
        }
      } catch (_) {
        print("Bloc exception $_");
        yield RemoveSeekerError(
            message: "Unable to process your request right now");
      }
    }
  }
}
