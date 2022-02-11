import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_state.dart';



class TimeAndDistanceBloc extends Bloc<TimeAndDistanceEvent, TimeAndDistanceState> {
  final SpottedProviderRepository repository;

  TimeAndDistanceBloc({@required this.repository}) : super(TimeAndDistanceEmpty());

  @override
  TimeAndDistanceState get initialState => TimeAndDistanceEmpty();

  @override
  Stream<TimeAndDistanceState> mapEventToState(TimeAndDistanceEvent event) async* {

    if (event is TimeAndDistanceTriggerEvent) {
      yield TimeAndDistanceLoading();
      try {
        var response =
            await repository.getTravelTimeAndDistance(event.sourceLatLong,event.destLatLong,event.travelMode);

        if (response.status == WebConstants.STATUS_VALUE_DISTANCE_OK) {
          yield TimeAndDistanceSuccess(timeAndDistanceResponse: response);
        } else {
          yield TimeAndDistanceError(message: "Unable to process your request right now");
        }
      } catch (_) {
        print("exception $_");
        yield TimeAndDistanceError(
            message: "Unable to process your request right now");
      }
    }
  }
}
