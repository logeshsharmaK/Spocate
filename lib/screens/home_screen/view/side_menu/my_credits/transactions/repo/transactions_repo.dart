import 'package:meta/meta.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_response.dart';

class TransactionsRepository {
  final Webservice webservice;
  final SharedPrefs sharedPrefs;
  TransactionsResponse transactionsResponse;

  TransactionsRepository({@required this.webservice, @required this.sharedPrefs})
      : assert(webservice != null);

  Future<TransactionsResponse> getTransactionsList(dynamic transactionsRequest) async {
    final response =
    await webservice.postAPICall(WebConstants.ACTION_TRANSACTION, transactionsRequest);
    transactionsResponse = TransactionsResponse.fromJson(response);
    return transactionsResponse;
  }
}
