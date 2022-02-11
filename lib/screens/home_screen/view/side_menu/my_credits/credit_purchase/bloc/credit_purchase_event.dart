import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class CreditPurchaseEvent extends Equatable {
  const CreditPurchaseEvent();
}
class CreditPurchaseClickEvent extends CreditPurchaseEvent {
  final dynamic creditPurchaseRequest;

  const CreditPurchaseClickEvent({@required this.creditPurchaseRequest});

  @override
  List<Object> get props => [creditPurchaseRequest];
}
