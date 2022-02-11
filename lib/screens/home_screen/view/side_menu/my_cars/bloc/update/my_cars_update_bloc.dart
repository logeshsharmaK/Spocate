import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_cars/repo/update/my_cars_update_repo.dart';
import 'my_cars_update_event.dart';
import 'my_cars_update_state.dart';

class MyCarsUpdateBloc extends Bloc<MyCarsUpdateEvent, MyCarsUpdateState> {
  final MyCarsUpdateRepository repository;

  MyCarsUpdateBloc({@required this.repository}) : super(MyCarsUpdateEmpty());

  @override
  MyCarsUpdateState get initialState => MyCarsUpdateEmpty();

  @override
  Stream<MyCarsUpdateState> mapEventToState(MyCarsUpdateEvent event) async* {
    if (event is MyCarsUpdateClickEvent) {
      yield MyCarsUpdateLoading();
      try {
        var response = await repository.updateMyCarDetails(event.myCarsUpdateRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield MyCarsUpdateSuccess(myCarsUpdateResponse: response, myCarDefaultIndex: event.myCarDefaultIndex);
        } else {
          yield MyCarsUpdateError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield MyCarsUpdateError(message: "Unable to process your request right now");
      }
    }
  }
}
