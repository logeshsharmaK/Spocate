import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/car_color/repo/car_colors_repo.dart';
import 'car_colors_event.dart';
import 'car_colors_state.dart';


class CarColorListBloc extends Bloc<CarColorListEvent, CarColorListState> {
  final CarColorListRepository repository;

  CarColorListBloc({@required this.repository}) : super(CarColorListEmpty());

  @override
  CarColorListState get initialState => CarColorListEmpty();

  @override
  Stream<CarColorListState> mapEventToState(CarColorListEvent event) async* {
    if (event is CarColorListInitEvent) {
      yield CarColorListLoading();
      try {
        var response = await repository.getCarColorList();
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield CarColorListSuccess(carColorListResponse: response);
        } else {
          yield CarColorListError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield CarColorListError(
            message: "Unable to process your request right now");
      }
    }
  }
}
