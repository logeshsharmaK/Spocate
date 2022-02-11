import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/login/repo/login_repo.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({@required this.repository}) : super(LoginEmpty());

  @override
  LoginState get initialState => LoginEmpty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginClickEvent) {
      yield LoginLoading();
      try {
        var response = await repository.submitLogin(event.loginRequest,event.isSocialLogin);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {

          yield LoginSuccess(loginResponse: response , isSocialLogin: event.isSocialLogin);
        } else {
          yield LoginError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield LoginError(message: "Unable to process your request right now");
      }
    }
  }
}
