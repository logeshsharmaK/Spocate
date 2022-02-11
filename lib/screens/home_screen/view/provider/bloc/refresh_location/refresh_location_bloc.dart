import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/refresh_location/refresh_location_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/refresh_location/refresh_location_state.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';


class RefreshLocationBloc extends Bloc<RefreshLocationEvent, RefreshLocationState> {
  final ProviderRepository repository;

  RefreshLocationBloc({@required this.repository}) : super(RefreshLocationEmpty());

  @override
  RefreshLocationState get initialState => RefreshLocationEmpty();

  @override
  Stream<RefreshLocationState> mapEventToState(RefreshLocationEvent event) async* {

    if (event is RefreshLocationTriggerEvent) {
      yield RefreshLocationLoading();
      try {
        var response =
            await repository.refreshSeekerLocation(event.refreshLocationRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield RefreshLocationSuccess(refreshLocationResponse: response);
        } else {
          yield RefreshLocationError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield RefreshLocationError(
            message: "Unable to process your request right now");
      }
    }
  }
}
