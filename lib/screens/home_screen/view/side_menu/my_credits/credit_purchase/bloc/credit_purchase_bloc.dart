import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/repo/credit_purchase_repo.dart';
import 'credit_purchase_event.dart';
import 'credit_purchase_state.dart';

class CreditPurchaseBloc extends Bloc<CreditPurchaseEvent, CreditPurchaseState> {
  final CreditPurchaseRepository repository;

  CreditPurchaseBloc({@required this.repository}) : super(CreditPurchaseEmpty());

  @override
  CreditPurchaseState get initialState => CreditPurchaseEmpty();

  @override
  Stream<CreditPurchaseState> mapEventToState(CreditPurchaseEvent event) async* {
    if (event is CreditPurchaseClickEvent) {
      yield CreditPurchaseLoading();
      try {
        var response = await repository.getCreditPurchaseList(event.creditPurchaseRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {

          yield CreditPurchaseSuccess(creditPurchaseResponse : response);
        } else {
          yield CreditPurchaseError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield CreditPurchaseError(message: "Unable to process your request right now");
      }
    }
  }
}
