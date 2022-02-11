import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class PaymentStatusEvent extends Equatable {
  const PaymentStatusEvent();
}
class PaymentStatusClickEvent extends PaymentStatusEvent {
  final dynamic paymentStatusRequest;

  const PaymentStatusClickEvent({@required this.paymentStatusRequest});

  @override
  List<Object> get props => [paymentStatusRequest];
}
