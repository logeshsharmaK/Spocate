import 'package:flutter/material.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/local/shared_prefs/shared_prefs.dart';
import '../side_menu_drawer.dart';

class Support extends StatefulWidget {
  const Support({Key key}) : super(key: key);

  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String supportPhone;
  String supportEmail;

  @override
  void initState() {
    print("initState Support");
    _getSupportContactDetails();
    super.initState();
  }

  Future<void> _getSupportContactDetails() async {
    await SharedPrefs().getSupportMobile().then((phone) {
      setState(() {
        supportPhone = phone;
      });
    });
    await SharedPrefs().getSupportEmail().then((email) {
      setState(() {
        supportEmail = email;
      });
    });
    // supportPhone ="7200707613";
    // supportEmail = "dhamuopenwave@gmail.com";
  }

  _callEmailAction(String email) async {
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '$email',
      query:
      'subject=Spocate App support required',
    );
    // final Uri _emailLaunchUri = Uri(
    //     scheme: 'mailto',
    //     path: '$email',
    //     query: {'subject': 'Spocate App support required'});
    if (await canLaunch(_emailLaunchUri.toString())) {
      await launch(_emailLaunchUri.toString());
    } else {
      AppWidgets.showSnackBar(context, "Unable to send an email");
    }
  }

  _callPhoneAction(String phone) async {
    final schemePhone = 'tel:$phone';
    if (await canLaunch(schemePhone)) {
      await launch(schemePhone);
    } else {
      AppWidgets.showSnackBar(context, "Unable to dial the number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_SUPPORT),
      drawer: SideMenuDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Image.asset(
              'assets/images/support.png',
              width: 200,
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _callPhoneAction(supportPhone);
                    },
                    child: Image.asset(
                      'assets/images/support_phone.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                // Divider(height: double.infinity,color: Colors.black87, thickness: 1.0,),
                Expanded(
                  child: InkWell(
                    onTap: () {_callEmailAction(supportEmail);},
                    child: Image.asset(
                      'assets/images/support_email.png',
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "${MessageConstants.MESSAGE_SUPPORT_CONTACT_PHONE} $supportPhone ${MessageConstants.MESSAGE_SUPPORT_CONTACT_EMAIL} $supportEmail ",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          )
          // Padding(
          //     padding: const EdgeInsets.all(32.0),
          //     child: Expanded(
          //       child: Text.rich(TextSpan(
          //           text:
          //               MessageConstants.MESSAGE_SUPPORT_CONTACT_PHONE,
          //           style: TextStyle(
          //               fontSize: SizeConstants.SIZE_18, color: Colors.blueGrey),
          //           children: [
          //             TextSpan(
          //                 text: supportPhone,
          //                 style: TextStyle(
          //                     fontSize: SizeConstants.SIZE_18,
          //                     color: Colors.black87)),
          //             TextSpan(
          //                 text: MessageConstants.MESSAGE_SUPPORT_CONTACT_EMAIL,
          //                 style: TextStyle(
          //                     fontSize: SizeConstants.SIZE_18,
          //                     color: Colors.blueGrey)),
          //             TextSpan(
          //                 text: supportEmail,
          //                 style: TextStyle(
          //                     fontSize: SizeConstants.SIZE_18,
          //                     color: Colors.black87)),
          //           ])
          //       ),
          //     )),
        ],
      ),
    );
  }
}
