import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/login/view/otp/bloc/otp_event.dart';
import 'package:spocate/screens/login/view/otp/bloc/otp_state.dart';
import 'package:spocate/screens/login/view/otp/repo/otp_repo.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  final OTPRepository repository;

  OTPBloc({@required this.repository}) : super(OTPEmpty());

  @override
  OTPState get initialState => OTPEmpty();

  @override
  Stream<OTPState> mapEventToState(OTPEvent event) async* {
    if (event is OTPVerifyEvent) {
      yield OTPLoading();
      try {
        var response = await repository.submitOTPVerify(event.otpRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield OTPSuccess(otpResponse: response);
        } else {
          yield OTPError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield OTPError(message: "Unable to process your request right now");
      }
    }
  }
}
