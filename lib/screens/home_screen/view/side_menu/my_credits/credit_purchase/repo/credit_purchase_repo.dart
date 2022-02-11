import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';

import 'credit_purchase_response.dart';

class CreditPurchaseRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  CreditPurchaseResponse creditPurchaseResponse;

  CreditPurchaseRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<CreditPurchaseResponse> getCreditPurchaseList(dynamic creditPurchaseRequest) async {
    final response =
    await webservice.postAPICall(WebConstants.ACTION_CREDIT_PURCHASE, creditPurchaseRequest);
    creditPurchaseResponse = CreditPurchaseResponse.fromJson(response);
    return creditPurchaseResponse;
  }
}
