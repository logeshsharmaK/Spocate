import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_repo.dart';
import 'transactions_event.dart';
import 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  final TransactionsRepository repository;

  TransactionsBloc({@required this.repository}) : super(TransactionsEmpty());

  @override
  TransactionsState get initialState => TransactionsEmpty();

  @override
  Stream<TransactionsState> mapEventToState(TransactionsEvent event) async* {
    if (event is TransactionsClickEvent) {
      yield TransactionsLoading();
      try {
        var response = await repository.getTransactionsList(event.transactionsRequest);

        if (response.status == WebConstants.STATUS_VALUE_SUCCESS) {

          yield TransactionsSuccess(transactionsResponse : response);
        } else {
          yield TransactionsError(message: "${response.message}");
        }
      } catch (_) {
        print("exception $_");
        yield TransactionsError(message: "Unable to process your request right now");
      }
    }
  }
}
