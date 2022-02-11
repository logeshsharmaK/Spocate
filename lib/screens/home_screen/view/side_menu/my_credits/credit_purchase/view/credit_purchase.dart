import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/bloc/credit_purchase_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/bloc/credit_purchase_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/bloc/credit_purchase_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/repo/credit_purchase_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/repo/credit_purchase_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/repo/credit_purchase_response.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/purchase_details.dart';
import 'package:spocate/utils/network_utils.dart';
import '../../../side_menu_drawer.dart';

class CreditPurchase extends StatefulWidget {
  @override
  _CreditPurchaseState createState() => _CreditPurchaseState();
}

class _CreditPurchaseState extends State<CreditPurchase> {

  List<CreditPurchaseItem> _creditPurchaseList = [];
  bool isListEmpty = false;
  CreditPurchaseBloc _creditPurchaseBloc;
  SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  void initState() {
    print("initState CreditPurchase");

    final CreditPurchaseRepository repository = CreditPurchaseRepository(
        webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _creditPurchaseBloc = CreditPurchaseBloc(repository: repository);
    _getCreditPurchaseList();
    super.initState();
  }

  _getCreditPurchaseList() async {
    var creditPurchaseRequest =
        CreditPurchaseRequest(customerId: await _getUserDetail());
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _creditPurchaseBloc.add(CreditPurchaseClickEvent(
            creditPurchaseRequest: creditPurchaseRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<String> _getUserDetail() {
    return SharedPrefs().getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_CREDIT_PURCHASE),
      drawer: SideMenuDrawer(),
      body: MultiBlocListener(
        child: _buildCreditPurchaseListView(),
        listeners: [
          BlocListener<CreditPurchaseBloc, CreditPurchaseState>(
              cubit: _creditPurchaseBloc,
              listener: (context, state) {
                _blocCreditPurchaseListListener(context, state);
              }),
        ],
      ),
    );
  }


  Widget _buildCreditPurchaseListView() {
    return Container(
        child: Column(children: <Widget>[
          Expanded(
            child: isListEmpty
                ? Container(
              child: Center(
                child: Text(MessageConstants.MESSAGE_NO_DATA_FOUND),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(6.0),
              itemCount: _creditPurchaseList.length,
              itemBuilder: (context, index) {
                return _buildArrowWithCredit(_creditPurchaseList[index]);
              },
            ),
          ),
        ]));
  }

  Widget _buildCreditPurchaseItem(CreditPurchaseItem creditPurchaseList) {
    return Container(
        height: 90.0,
        margin: EdgeInsets.fromLTRB(
            SizeConstants.SIZE_16,
            SizeConstants.SIZE_16,
            SizeConstants.SIZE_16,
            SizeConstants.SIZE_16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(
                5.0,
                5.0,
              ),
            )
          ],
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Row(
          children: [
            Expanded(
                child: Center(
                    child: Text( "${creditPurchaseList.points} points",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
            ))),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 8.0,
                          spreadRadius: 2.0,
                          offset: const Offset(
                            5.0,
                            5.0,
                          ),
                        )
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    ),
                        child: Center(
                            child: Text( "${creditPurchaseList.amount} ${creditPurchaseList.currency}",
                              // child: Text("5\$",
                          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
                        )),
                  )),
          ],
        ));
  }

  Widget _buildArrowWithCredit(CreditPurchaseItem creditPurchaseList) {
    return InkWell(
      onTap: (){
        makeGeneralPayment(creditPurchaseList.amount,creditPurchaseList.points);

      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildCreditPurchaseItem(creditPurchaseList),
          Positioned(
            child: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.25), // border color
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: EdgeInsets.all(2), // border width
                child: Container(
                  // or ClipRRect if you need to clip the content
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white, // inner circle color
                  ),
                  child: Icon(
                    Icons.arrow_right,
                    size: 33,
                    color: Colors.amber,
                  ), // inner content
                ),
              ),
            ),
            right: 2,
            top: 45,
          )
        ],
      ),
    );
  }

  _blocCreditPurchaseListListener(
      BuildContext context, CreditPurchaseState state) {
    if (state is CreditPurchaseEmpty) {}
    if (state is CreditPurchaseLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is CreditPurchaseError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is CreditPurchaseSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "CreditPurchaseSuccess ${state.creditPurchaseResponse.creditPurchaseList}");
      setState(() {
        _creditPurchaseList = state.creditPurchaseResponse.creditPurchaseList;
        if (_creditPurchaseList.isEmpty || _creditPurchaseList == null) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }
  Future<void> makeGeneralPayment(double amount, int points) async {
    final request = BraintreeDropInRequest(
        clientToken: 'sandbox_v25mdq6v_j8bywq7mdn8gcf6w',
        collectDeviceData: true,
        googlePaymentRequest: BraintreeGooglePaymentRequest(
          totalPrice: '1.00',
          currencyCode: 'USD',
          billingAddressRequired: false,
        ),
        paypalRequest: BraintreePayPalRequest(
          amount: '2.00',
          displayName: 'Spocate Paypal',
        ),
        applePayRequest: BraintreeApplePayRequest(
            amount: 3.00,
            displayName: "Spocate Apple",
            currencyCode: 'USD',
            countryCode: 'USD',
            appleMerchantID: "merchant.parking.com"));
    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      print('Result isDefault: ${result.paymentMethodNonce.isDefault}'); // false
      print('Result typeLabel: ${result.paymentMethodNonce.typeLabel}'); // PayPal
      print('Result description: ${result.paymentMethodNonce.description}'); // test1@spocate.com
      print(
          'Result Nonce: ${result.paymentMethodNonce.nonce}'); //12e75f09-3605-0f9d-7fef-351048c3b561
      Navigator.pushNamed(context, RouteConstants.ROUTE_PAYMENT_STATUS, arguments: PurchaseDetail(purchaseAmount: amount ,purchaseCredits: points));
    } else {
      print('Selection was canceled.');
    }
  }
}
