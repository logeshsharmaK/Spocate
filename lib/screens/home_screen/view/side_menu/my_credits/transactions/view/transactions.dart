import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/bloc/transactions_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/bloc/transactions_event.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/bloc/transactions_state.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_request.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/repo/transactions_response.dart';
import 'package:spocate/utils/network_utils.dart';
import '../../../side_menu_drawer.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({Key key}) : super(key: key);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {

  TransactionsBloc  _transactionsBloc;
  // List<TransactionItem> _transactionsList = [];
  TransactionsResponse _transactions = TransactionsResponse();
  bool isListEmpty = false;
  bool isResponseSuccess = false;
  SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  void initState() {
    print("initState MyCredits");
    final TransactionsRepository repository =
    TransactionsRepository(webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _transactionsBloc = TransactionsBloc(repository: repository);
    _getTransactionsList();
    super.initState();
  }

  _getTransactionsList() async {
    var transactionsRequest =
    TransactionsRequest(
        customerId: await _getUserDetail() ,
    transactionDate: "2021-08-19" ,
    transactionType: WebConstants.ACTION_TRANSACTION_TYPE_ALL,
    );
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _transactionsBloc.add(TransactionsClickEvent(
            transactionsRequest: transactionsRequest));
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
        appBar: showAppBar(AppBarConstants.APP_BAR_TRANSACTIONS),
        drawer: SideMenuDrawer(),
        body: MultiBlocListener(
          child: _buildTransactionsView(),
          listeners: [
            BlocListener<TransactionsBloc, TransactionsState>(
                cubit: _transactionsBloc,
                listener: (context, state) {
                  _blocTransactionsListListener(context, state);
                }),
          ],
        ));
  }

  Widget showAppBar(String title) {
    return AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: PopupMenuButton(
              tooltip: 'Menu',
              child: Icon(
                Icons.filter_list_outlined,
                size: 28.0,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.select_all,
                        color: Colors.black54,
                        size: 22.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          "All",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.black54,
                        size: 22.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          "Earned",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.black54,
                        size: 22.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          "Spent",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.smart_button,
                        color: Colors.black54,
                        size: 22.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 10.0,
                        ),
                        child: Text(
                          "Recharged",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: ColorConstants.primaryColor,
        brightness: Brightness.dark);
  }

  Widget _buildTransactionsView() {
    return isResponseSuccess ? Column(
      children: [
        _buildCurrentBalanceView(),
        _buildEarnedSpentView(),
        Expanded(child: _buildTransactionsListView()),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, RouteConstants.ROUTE_CREDIT_PURCHASE);
        }, child: Text("Purchase Credits"),style: ElevatedButton.styleFrom(primary: ColorConstants.primaryColor),)
      ],
    ) : Column(
      children: [],
    );
  }

  Widget _buildCurrentBalanceView() {
    return Container(
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_8, SizeConstants.SIZE_16,
          SizeConstants.SIZE_8, SizeConstants.SIZE_8),
      child: Text("Current Balance : ${_transactions.balancepoints} points",
          style: TextStyle(
              fontSize: SizeConstants.SIZE_18, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildEarnedSpentView() {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_12, SizeConstants.SIZE_8,
          SizeConstants.SIZE_12, SizeConstants.SIZE_8),
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
          SizeConstants.SIZE_16, SizeConstants.SIZE_16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: const Offset(
              2.0,
              2.0,
            ),
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.black87,
                        size: 15.0,
                      ),
                      Text(
                        " Earned",
                      ),
                    ],
                  ),
                  Text("${_transactions.earnedpoints} points",
                      style: TextStyle(
                          fontSize: SizeConstants.SIZE_14,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.black38,
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        color: Colors.black87,
                        size: 15.0,
                      ),
                      Text(
                        " Spent",
                      ),
                    ],
                  ),
                  Text("${_transactions.spentpoints} points",
                      style: TextStyle(
                          fontSize: SizeConstants.SIZE_14,
                          fontWeight: FontWeight.w500))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget _buildListView() {
  //   return Container(
  //     child: ListView.builder(
  //       padding: EdgeInsets.all(6.0),
  //       itemCount: 10,
  //       itemBuilder: (context, index) {
  //         return _buildTransactionsListView();
  //       },
  //     ),
  //   );
  // }

  Widget _buildTransactionsListView() {
    return Container(
        child: Column(children: <Widget>[
          Expanded(
            child: isListEmpty
                ? Container(
              child: Center(
                child: Text(MessageConstants.MESSAGE_NO_TRANSACTION_FOUND),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(6.0),
              itemCount: _transactions.transactionList.length,
              itemBuilder: (context, index) {
                return _buildTransactionsItemView(_transactions.transactionList[index]);
              },
            ),
          ),
        ]));
  }

  Color getTransactionColor(TransactionItem transactionItem){
    if(transactionItem.transactiontype==WebConstants.ACTION_TRANSACTION_TYPE_SPENT){
      return Colors.redAccent;
    }else if(transactionItem.transactiontype==WebConstants.ACTION_TRANSACTION_TYPE_EARNED){
      return Colors.greenAccent;
    }else if(transactionItem.transactiontype==WebConstants.ACTION_TRANSACTION_TYPE_CREDIT_PURCHASE){
      return Colors.blue;
    }
  }

  Widget _buildTransactionsItemView(TransactionItem transactionItem) {
    return Container(
      margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
          SizeConstants.SIZE_16, SizeConstants.SIZE_16),
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_8, SizeConstants.SIZE_8,
          SizeConstants.SIZE_8, SizeConstants.SIZE_8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 1.0,
          )
        ],
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.directions_car,
            color: getTransactionColor(transactionItem),
            size: 45.0,
          ),
          Expanded(
            child: Column(
              children: [
                Text("${transactionItem.name}",
                    style: TextStyle(
                        fontSize: SizeConstants.SIZE_16,
                        fontWeight: FontWeight.w500)),
                Text("${transactionItem.transactiontype}"),
                Text("${transactionItem.ridedate}")
              ],
            ),
          ),
          Text("${transactionItem.points}",
              style: TextStyle(
                  fontSize: SizeConstants.SIZE_32,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }


  _blocTransactionsListListener(
      BuildContext context, TransactionsState state) {
    if (state is TransactionsEmpty) {}
    if (state is TransactionsLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is TransactionsError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is TransactionsSuccess) {
      AppWidgets.hideProgressBar();

      print("TransactionsSuccess transactionList length = ${state.transactionsResponse.transactionList.length}");
      print("TransactionsSuccess balance points = ${state.transactionsResponse.balancepoints}");
      print("TransactionsSuccess earned points = ${state.transactionsResponse.earnedpoints}");
      print("TransactionsSuccess spent points = ${state.transactionsResponse.spentpoints}");
      setState(() {
        _transactions = state.transactionsResponse;
        isResponseSuccess = true;
        if (_transactions.transactionList.isEmpty || _transactions.transactionList == null) {
          isListEmpty = true;
        } else {
          isListEmpty = false;
        }
      });
    }
  }
}
