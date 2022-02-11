import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/widgets/app_styles.dart';
import 'package:spocate/routes/route_constants.dart';

class SeekerWaiting extends StatefulWidget {
  @override
  _SeekerWaitingState createState() => _SeekerWaitingState();
}

class _SeekerWaitingState extends State<SeekerWaiting> {
  FirebaseMessaging _firebaseMessaging;
  bool isConfirmed = false;

  @override
  void initState() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _processNotification();
    super.initState();
  }

  _processNotification() {
    _firebaseMessaging.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      // print("onMessage title ${remoteMessage.notification.title}");
      // print("onMessage body ${remoteMessage.notification.body}");
      print("onMessage data SeekerWaiting ${remoteMessage.data.toString()}");

      if (remoteMessage != null) {
        if(mounted){
          setState(() {
            isConfirmed = true;
            _navigateToHome();
          });
        }
      }
    });
  }

  _navigateToHome() {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: _buildSeekerWaitingView()),
    );
  }

  Widget _buildSeekerWaitingView() {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
                child: Text(
              isConfirmed
                  ? MessageConstants.MESSAGE_SEEKER_WAITING_TITLE_SUCCESS
                  : MessageConstants.MESSAGE_SEEKER_WAITING_TITLE_WAITING,
              style: AppStyles.seekerWaitingUserMessageTextStyle(),
              textAlign: TextAlign.center,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
                child: Text(
              MessageConstants.MESSAGE_SEEKER_WAITING_SPOTTED_SUCCESS,
              style: AppStyles.seekerWaitingUserMessageTextStyle(),
              textAlign: TextAlign.center,
            )),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Icon(
              isConfirmed ? Icons.check : Icons.location_on_outlined,
              size: 92,
              color: isConfirmed ? Colors.green : Colors.black87,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
                child: Text(
              isConfirmed
                  ? MessageConstants.MESSAGE_SEEKER_WAITING_PROVIDER_CONFIRMED
                  : MessageConstants.MESSAGE_SEEKER_WAITING_PROVIDER_TO_CONFIRM,
              style: AppStyles.seekerWaitingUserMessageTextStyle(),
              textAlign: TextAlign.center,
            )),
          ),
        ],
      ),
    );
  }
}
