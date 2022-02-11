import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/repo/credit_purchase_response.dart';


abstract class CreditPurchaseState extends Equatable {
  const CreditPurchaseState();

  @override
  List<Object> get props => [];
}

class CreditPurchaseEmpty extends CreditPurchaseState {}

class CreditPurchaseLoading extends CreditPurchaseState {}

class CreditPurchaseError extends CreditPurchaseState {
  final String message;
  const CreditPurchaseError({@required this.message}) : assert(message != null);
  List<String> get props => [message];
}

class CreditPurchaseSuccess extends CreditPurchaseState {
  final CreditPurchaseResponse creditPurchaseResponse;

  const CreditPurchaseSuccess({@required this.creditPurchaseResponse}) : assert(creditPurchaseResponse != null);

  @override
  List<Object> get props => [creditPurchaseResponse];
}
