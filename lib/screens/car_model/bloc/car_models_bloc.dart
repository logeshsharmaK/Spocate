import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/car_model/repo/car_models_repo.dart';

import 'car_models_event.dart';
import 'car_models_state.dart';

class CarModelListBloc extends Bloc<CarModelListEvent, CarModelListState> {
  final CarModelListRepository repository;

  CarModelListBloc({@required this.repository}) : super(CarModelListEmpty());

  @override
  CarModelListState get initialState => CarModelListEmpty();

  @override
  Stream<CarModelListState> mapEventToState(CarModelListEvent event) async* {
    if (event is CarModelListInitEvent) {
      yield CarModelListLoading();
      try {
        var response = await repository.getCarModelList(event.makeName);
        if (response.message == WebConstants.STATUS_CAR_VALUE_SUCCESS) {
          yield CarModelListSuccess(carModelListResponse: response);
        } else {
          yield CarModelListError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield CarModelListError(
            message: "Unable to process your request right now");
      }
    }
  }
}
