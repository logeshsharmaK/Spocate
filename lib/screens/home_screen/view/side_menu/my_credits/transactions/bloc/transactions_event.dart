import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TransactionsEvent extends Equatable {
  const TransactionsEvent();
}
class TransactionsClickEvent extends TransactionsEvent {
  final dynamic transactionsRequest;

  const TransactionsClickEvent({@required this.transactionsRequest});

  @override
  List<Object> get props => [transactionsRequest];
}
