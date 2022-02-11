
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/logout/repo/logout_request.dart';

abstract class LogoutEvent {
  const LogoutEvent();
}

class LogoutClickEvent extends LogoutEvent {
  final LogoutRequest logoutRequest;

  const LogoutClickEvent({@required this.logoutRequest});

  @override
  List<Object> get props => [logoutRequest];
}
