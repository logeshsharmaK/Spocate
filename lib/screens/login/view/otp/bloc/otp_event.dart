import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/login/repo/login_request.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_request.dart';

abstract class OTPEvent extends Equatable {
  const OTPEvent();
}
class OTPVerifyEvent extends OTPEvent {
  final OTPRequest otpRequest;

  const OTPVerifyEvent({@required this.otpRequest});

  @override
  List<Object> get props => [otpRequest];
}
