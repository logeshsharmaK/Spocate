import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/bloc/unpark/unpark_event.dart';
import 'package:spocate/screens/home_screen/bloc/unpark/unpark_state.dart';
import 'package:spocate/screens/home_screen/repo/home_repo.dart';

class UnParkBloc extends Bloc<UnParkEvent, UnParkState> {
  final HomeRepository repository;

  UnParkBloc({@required this.repository}) : super(UnParkEmpty());

  @override
  UnParkState get initialState => UnParkEmpty();

  @override
  Stream<UnParkState> mapEventToState(UnParkEvent event) async* {
    if (event is UnParkClickEvent) {
      yield UnParkLoading();
      try {
        var response = await repository.submitUnPark(event.unParkRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield UnParkSuccess(unParkResponse: response);
        } else {
          yield UnParkError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield UnParkError(message: "Unable to process your request right now");
      }
    }
  }
}
