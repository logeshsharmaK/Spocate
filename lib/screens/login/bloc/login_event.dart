import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../../core/constants/enum_constants.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}
class LoginClickEvent extends LoginEvent {
  final dynamic loginRequest;
  final IsSocialLogin isSocialLogin;

  const LoginClickEvent({@required this.loginRequest, @required this.isSocialLogin});

  @override
  List<Object> get props => [loginRequest];
}
