import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_event.dart';
import 'package:spocate/screens/home_screen/bloc/home/home_state.dart';
import 'package:spocate/screens/home_screen/repo/home_repo.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc({@required this.repository}) : super(HomeEmpty());

  @override
  HomeState get initialState => HomeEmpty();

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeInitEvent) {
      yield HomeLoading();
      try {
        var response = await repository.getHomeDetails(event.homeRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield HomeSuccess(homeResponse: response);
        } else {
          yield HomeError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield HomeError(message: "Unable to process your request right now");
      }
    }
  }
}
