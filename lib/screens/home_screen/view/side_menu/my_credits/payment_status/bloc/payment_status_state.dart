import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_response.dart';


abstract class PaymentStatusState extends Equatable {
  const PaymentStatusState();

  @override
  List<Object> get props => [];
}

class PaymentStatusEmpty extends PaymentStatusState {}

class PaymentStatusLoading extends PaymentStatusState {}

class PaymentStatusError extends PaymentStatusState {
  final String message;
  const PaymentStatusError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class PaymentStatusSuccess extends PaymentStatusState {
  final PaymentStatusResponse paymentStatusResponse;

  const PaymentStatusSuccess({@required this.paymentStatusResponse}) : assert(paymentStatusResponse != null);

  @override
  List<Object> get props => [paymentStatusResponse];
}
