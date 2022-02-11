import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'payment_status_response.dart';

class PaymentStatusRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  PaymentStatusResponse paymentStatusResponse;

  PaymentStatusRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<PaymentStatusResponse> getPaymentStatus(dynamic paymentStatusRequest) async {
    final response =
    await webservice.postAPICall(WebConstants.ACTION_LOGIN, paymentStatusRequest);
    paymentStatusResponse = PaymentStatusResponse.fromJson(response);
    return paymentStatusResponse;
  }
}
