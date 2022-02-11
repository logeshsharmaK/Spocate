import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/repo/logout_repo.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final LogoutRepository repository;

  LogoutBloc({@required this.repository}) : super(LogoutEmpty());

  @override
  LogoutState get initialState => LogoutEmpty();

  @override
  Stream<LogoutState> mapEventToState(LogoutEvent event) async* {
    if (event is LogoutClickEvent) {
      yield LogoutLoading();
      try {
        var response = await repository.submitLogout(event.logoutRequest);
        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield LogoutSuccess(logoutResponse : response);
        } else {
          yield LogoutError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield LogoutError(
            message: "Unable to process your request right now");
      }
    }
  }
}
