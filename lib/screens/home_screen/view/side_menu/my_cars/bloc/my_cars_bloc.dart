import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/my_cars_repo.dart';

import 'my_cars_event.dart';
import 'my_cars_state.dart';

class MyCarsBloc extends Bloc<MyCarsEvent, MyCarsState> {
  final MyCarsRepository repository;

  MyCarsBloc({@required this.repository}) : super(MyCarsEmpty());

  @override
  MyCarsState get initialState => MyCarsEmpty();

  @override
  Stream<MyCarsState> mapEventToState(MyCarsEvent event) async* {
    if (event is MyCarsClickEvent) {
      yield MyCarsLoading();
      try {
        var response = await repository.getMyCars(event.myCarsRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield MyCarsSuccess(myCarsResponse: response);
        } else {
          yield MyCarsError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield MyCarsError(message: "Unable to process your request right now");
      }
    }
  }
}
