import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/login/repo/login_response.dart';

import '../../../core/constants/enum_constants.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginEmpty extends LoginState {}

class LoginLoading extends LoginState {}

class LoginError extends LoginState {
  final String message;
  const LoginError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;
  final IsSocialLogin isSocialLogin;

  const LoginSuccess({@required this.loginResponse,@required this.isSocialLogin}) : assert(loginResponse != null);

  @override
  List<Object> get props => [loginResponse];
}
