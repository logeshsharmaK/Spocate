import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_response.dart';
import 'payment_status_event.dart';
import 'payment_status_state.dart';

class PaymentStatusBloc extends Bloc<PaymentStatusEvent, PaymentStatusState> {
  final PaymentStatusRepository repository;

  PaymentStatusBloc({@required this.repository}) : super(PaymentStatusEmpty());

  @override
  PaymentStatusState get initialState => PaymentStatusEmpty();

  @override
  Stream<PaymentStatusState> mapEventToState(PaymentStatusEvent event) async* {
    if (event is PaymentStatusClickEvent) {
      yield PaymentStatusLoading();
      try {
        Timer(Duration(seconds: 2), () async* {
          yield PaymentStatusSuccess(
              paymentStatusResponse: PaymentStatusResponse(
                  paymentStatus: "Success",
                  status: "Success",
                  message: "Payment made successful"));
        });
        var response =
            await repository.getPaymentStatus(event.paymentStatusRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {
          yield PaymentStatusSuccess(paymentStatusResponse: response);
        } else {
          yield PaymentStatusError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield PaymentStatusError(
            message: "Unable to process your request right now");
      }
    }
  }
}
