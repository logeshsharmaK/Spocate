import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/car_make/bloc/car_makes_event.dart';
import 'package:spocate/screens/car_make/bloc/car_makes_state.dart';
import 'package:spocate/screens/car_make/repo/car_makes_repo.dart';

class CarMakeListBloc extends Bloc<CarMakeListEvent, CarMakeListState> {
  final CarMakeListRepository repository;

  CarMakeListBloc({@required this.repository}) : super(CarMakeListEmpty());

  @override
  CarMakeListState get initialState => CarMakeListEmpty();

  @override
  Stream<CarMakeListState> mapEventToState(CarMakeListEvent event) async* {
    if (event is CarMakeListInitEvent) {
      yield CarMakeListLoading();
      try {
        var response = await repository.getCarList();
        if (response.message == WebConstants.STATUS_CAR_VALUE_SUCCESS) {
          yield CarMakeListSuccess(carListResponse: response);
        } else {
          yield CarMakeListError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield CarMakeListError(
            message: "Unable to process your request right now");
      }
    }
  }
}
