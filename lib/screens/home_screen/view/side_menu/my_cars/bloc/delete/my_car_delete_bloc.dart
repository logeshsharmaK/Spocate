import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/delete/my_car_delete_repo.dart';

import 'my_car_delete_event.dart';
import 'my_car_delete_state.dart';


class MyCarDeleteBloc extends Bloc<MyCarDeleteEvent, MyCarDeleteState> {
  final MyCarDeleteRepository repository;

  MyCarDeleteBloc({@required this.repository}) : super(MyCarDeleteEmpty());

  @override
  MyCarDeleteState get initialState => MyCarDeleteEmpty();

  @override
  Stream<MyCarDeleteState> mapEventToState(MyCarDeleteEvent event) async* {
    print("Call flow CarListBloc $event");
    if (event is MyCarDeleteClickEvent) {
      yield MyCarDeleteLoading();
      try {
        var response = await repository.submitCarList(event.myCarsDeleteRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield MyCarDeleteSuccess(myCarDeleteResponse:  response);
        } else {
          yield MyCarDeleteError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield MyCarDeleteError(message: "Unable to process your request right now");
      }
    }
  }
}
