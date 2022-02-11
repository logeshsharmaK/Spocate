import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/add_car/repo/add_car_repo.dart';

import 'add_car_event.dart';
import 'add_car_state.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> {
  final AddCarRepository repository;

  AddCarBloc({@required this.repository}) : super(AddCarEmpty());

  @override
  AddCarState get initialState => AddCarEmpty();

  @override
  Stream<AddCarState> mapEventToState(AddCarEvent event) async* {
    if (event is AddCarClickEvent) {
      yield AddCarLoading();
      try {
        var response = await repository.submitAddCar(event.addCarRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield AddCarSuccess(addCarResponse: response);
        } else {
          yield AddCarError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield AddCarError(message: "Unable to process your request right now");
      }
    }
  }
}
