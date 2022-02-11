import 'package:flutter/material.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/bloc/payment_status_bloc.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/repo/payment_status_repo.dart';
import 'package:spocate/screens/home_screen/view/side_menu/side_menu_drawer.dart';


class PaymentDesignScreen extends StatefulWidget {
  const PaymentDesignScreen({Key key}) : super(key: key);

  @override
  _PaymentDesignScreenState createState() => _PaymentDesignScreenState();
}

class _PaymentDesignScreenState extends State<PaymentDesignScreen> {

  PaymentStatusBloc  _paymentStatusBloc;

  SharedPrefs _sharedPrefs = SharedPrefs();

  @override
  void initState() {
    print("initState MyCredits");

    final PaymentStatusRepository repository =
    PaymentStatusRepository(webservice: Webservice(), sharedPrefs: _sharedPrefs);
    _paymentStatusBloc = PaymentStatusBloc(repository: repository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar(AppBarConstants.APP_BAR_PAYMENT_STATUS),
        drawer: SideMenuDrawer(),
        body: _buildMyCreditView());
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

  Widget _buildMyCreditView() {
    return Column(
      children: [
        _buildCurrentBalanceView(),
        _buildEarnedSpentView(),
        Expanded(child: _buildListView())
      ],
    );
  }

  Widget _buildCurrentBalanceView() {
    return Container(
      padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_8, SizeConstants.SIZE_16,
          SizeConstants.SIZE_8, SizeConstants.SIZE_8),
      child: Text("Current Balance : 50000 points",
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
                  Text("250 points",
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
                  Text("250 points",
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

  Widget _buildListView() {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(6.0),
        itemCount: 10,
        itemBuilder: (context, index) {
          return _buildItemView();
        },
      ),
    );
  }

  Widget _buildItemView() {
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
            Icons.car_rental,
            color: Colors.black87,
            size: 45.0,
          ),
          Expanded(
            child: Column(
              children: [
                Text("Openwave",
                    style: TextStyle(
                        fontSize: SizeConstants.SIZE_16,
                        fontWeight: FontWeight.w500)),
                Text("Seeker"),
                Text("250 points")
              ],
            ),
          ),
          Expanded(child: Text("")),
          Text("1",
              style: TextStyle(
                  fontSize: SizeConstants.SIZE_32,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
