import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/bloc/payment_status_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/bloc/payment_status_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/bloc/payment_status_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/purchase_details.dart';
import 'package:spocate/utils/network_utils.dart';

class PaymentStatus extends StatefulWidget {
  final PurchaseDetail purchaseDetail;

  const PaymentStatus({Key key, this.purchaseDetail}) : super(key: key);

  @override
  _PaymentStatusState createState() => _PaymentStatusState(purchaseDetail);
}

class _PaymentStatusState extends State<PaymentStatus> {
  final PurchaseDetail purchaseDetail;

  _PaymentStatusState(this.purchaseDetail);

  PaymentStatusBloc _paymentStatusBloc;
  String userId;
  String paymentStatus = "Payment Processing...";

  @override
  void initState() {
    final PaymentStatusRepository paymentStatusRepository =
        PaymentStatusRepository(webservice: Webservice());
    _paymentStatusBloc = PaymentStatusBloc(repository: paymentStatusRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: MultiBlocListener(
        child: _buildPaymentStatusView(),
        listeners: [
          BlocListener<PaymentStatusBloc, PaymentStatusState>(
              cubit: _paymentStatusBloc,
              listener: (context, state) {
                _blocPaymentStatusListener(context, state);
              }),
        ],
      ),
    ));
  }

  Widget _buildPaymentStatusView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(SizeConstants.SIZE_16),
          child: Center(
              child: Text(
            "$paymentStatus",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
          )),
        ),
        Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(SizeConstants.SIZE_16),
                child: Center(
                    child: Text(
                  "${purchaseDetail.purchaseAmount.toString()}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 34.0),
                )),
              ),
              Padding(
                padding: const EdgeInsets.all(SizeConstants.SIZE_16),
                child: Center(
                    child: Text(
                  "${purchaseDetail.purchaseCredits.toString()} Points",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24.0),
                )),
              ),
            ],
          ),
        ),
        _updatePaymentStatusView("Success"),
        Text(
          "Please wait while we processing your payment",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }

  Widget _updatePaymentStatusView(String status) {
    if (status == "Loading") {
      setState(() {
        paymentStatus = "Payment Processing...";
      });
      return Container(
          height: 72.0, width: 72.0, child: CircularProgressIndicator());
    } else if (status == "Success") {
      setState(() {
        paymentStatus = "Payment Success";
      });
      return Icon(
        Icons.check,
        color: Colors.green,
        size: 92.0,
      );
    } else if (status == "Failed") {
      setState(() {
        paymentStatus = "Payment Failed";
      });
      return Icon(Icons.close, color: Colors.red, size: 92.0);
    }
    return CircularProgressIndicator();
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  Future<void> _submitPaymentNonce(String paymentNonce) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var paymentStatusRequest =
            PaymentStatusRequest(userId: userId, paymentNonce: paymentNonce);
        _paymentStatusBloc.add(PaymentStatusClickEvent(
            paymentStatusRequest: paymentStatusRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocPaymentStatusListener(BuildContext context, PaymentStatusState state) {
    if (state is PaymentStatusEmpty) {}
    if (state is PaymentStatusLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is PaymentStatusError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is PaymentStatusSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "PaymentStatusSuccess ${state.paymentStatusResponse.paymentStatus}");
    }
  }

}
