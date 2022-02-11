import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';

import 'update_location_event.dart';
import 'update_location_state.dart';

class UpdateLocationBloc extends Bloc<UpdateLocationEvent, UpdateLocationState> {
  final RouteToDestRepository repository;

  UpdateLocationBloc({@required this.repository}) : super(UpdateLocationEmpty());

  @override
  UpdateLocationState get initialState => UpdateLocationEmpty();

  @override
  Stream<UpdateLocationState> mapEventToState(UpdateLocationEvent event) async* {
    if (event is UpdateLocationInitEvent) {
      yield UpdateLocationLoading();
      try {
        var response = await repository.submitUpdateLocation(event.updateLocationRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield UpdateLocationSuccess(updateLocationResponse: response);
        } else {
          yield UpdateLocationError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield UpdateLocationError(message: "Unable to process your request right now");
      }
    }
  }
}
