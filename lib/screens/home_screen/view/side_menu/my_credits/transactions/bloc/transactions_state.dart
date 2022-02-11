import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_response.dart';


abstract class TransactionsState extends Equatable {
  const TransactionsState();

  @override
  List<Object> get props => [];
}

class TransactionsEmpty extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsError extends TransactionsState {
  final String message;
  const TransactionsError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class TransactionsSuccess extends TransactionsState {
  final TransactionsResponse transactionsResponse;

  const TransactionsSuccess({@required this.transactionsResponse}) : assert(transactionsResponse != null);

  @override
  List<Object> get props => [transactionsResponse];
}
