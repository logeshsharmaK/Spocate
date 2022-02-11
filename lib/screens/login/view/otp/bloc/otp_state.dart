import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_response.dart';

abstract class OTPState extends Equatable {
  const OTPState();

  @override
  List<Object> get props => [];
}

class OTPEmpty extends OTPState {}

class OTPLoading extends OTPState {}

class OTPError extends OTPState {
  final String message;

  const OTPError({@required this.message}) : assert(message != null);

  List<String> get props => [message];
}

class OTPSuccess extends OTPState {
  final OTPResponse otpResponse;

  const OTPSuccess({@required this.otpResponse}) : assert(otpResponse != null);

  @override
  List<Object> get props => [otpResponse];
}
