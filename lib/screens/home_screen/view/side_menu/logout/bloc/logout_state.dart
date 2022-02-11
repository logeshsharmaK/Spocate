import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/repo/logout_response.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object> get props => [];
}

class LogoutEmpty extends LogoutState {}

class LogoutLoading extends LogoutState {}

class LogoutError extends LogoutState {
  final String message;
  const LogoutError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class LogoutSuccess extends LogoutState {
  final LogoutResponse logoutResponse;

  const LogoutSuccess({@required this.logoutResponse}) : assert(logoutResponse != null);

  @override
  List<Object> get props => [logoutResponse];
}
