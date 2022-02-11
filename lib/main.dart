import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:spocate/core/widgets/app_theme.dart';
import 'package:spocate/payload_passer.dart';
import 'package:spocate/routes/generated_routes.dart';
import 'package:spocate/screens/home_screen/view/seeker/spotted_provider_thanks/seeker_waiting.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/credit_purchase/view/credit_purchase.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/payment_status/view/payment_status.dart';
import 'package:spocate/screens/home_screen/view/side_menu/my_credits/transactions/view/transactions.dart';
import 'package:spocate/screens/splash/splash_screen.dart';

import 'getxtest/MyScreen.dart';
import 'notification/fcm_notification.dart';
import 'screens/splash/splash_screen.dart';

// Global key for navigation context in fcm_notification.dart
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() {
  _initializeFirebase();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: PayloadPasser())],
      child: SpocateApp(),
    ),
  );
  // runApp(SpocateApp());
}

Future<void> _initializeFirebase() async {
  FirebaseNotification firebase = FirebaseNotification();
  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
            channelKey: 'high_intensity',
            channelName: 'High intensity notifications',
            channelDescription:
                'Notification channel for notifications with high intensity',
            playSound: true,
            soundSource: 'resource://raw/sweet',
            defaultColor: Colors.red,
            ledColor: Colors.red,
            vibrationPattern: lowVibrationPattern)
      ],
      debug: true);

  await firebase.initialize();
  firebase.subscribeToTopic("all");
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
}

class SpocateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    setPortraitOrientation();
/*  1.this below gesture detector is for user allowed to tap on the screen and listen the gesture  for keyboard hiding
*   2.this gesture detector is only for iOs.
* */
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
            title: 'Spocate',
            theme: AppTheme.applyAppTheme(context),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: GeneratedRoutes.generateRoute,
            navigatorKey: navigatorKey,
            home: SafeArea(
              child: Scaffold(
                body: SplashScreen(),
              ),
            ),
            builder: EasyLoading.init(builder: (context, child) {
              // App Font size control
              final mediaQueryData = MediaQuery.of(context);
              // Font size change(either reduce or increase) from phone setting should not impact app font size
              final scale = mediaQueryData.textScaleFactor.clamp(1.0, 1.0);
              return MediaQuery(
                child: child,
                data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
              );
            })));
  }

  void configLoading() {
    EasyLoading.instance
      // ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.black87
      ..backgroundColor = Colors.white54
      ..indicatorColor = Colors.black87
      ..textColor = Colors.black87
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  Future<void> setPortraitOrientation() async {
    // Force App to stick with Portrait orientation and disable Landscape orientation
    // This should work in both android and ios
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      // statusBarBrightness: Brightness.dark,
      // statusBarIconBrightness: Brightness.dark
    ));
  }

/*  _awesomeNotificationsActionStream(BuildContext context)  {
    AwesomeNotifications().actionStream.listen((receivedNotification) async {

      print("receivedNotification.body = ${receivedNotification.body}");
      switch(receivedNotification.body){
        case MessageConstants.MESSAGE_SPOT_LOCATED_MESSAGE : {
          print("Spot Located ROUTE_ROUTE_TO_DESTINATION");
          context.read<PayloadPasser>().clearPayload();
          context.read<PayloadPasser>().setPayload(receivedNotification.payload);
          await SharedPrefs().getSourceLocationDetails().then((sourceDetails) async {
            await  SharedPrefs().getDestLocationDetails().then((destDetails) {
              print("sourceDetails = ${sourceDetails.sourceLongitude}");
              print("destDetails   = ${destDetails.destAddress}");
              // print( "payload from provider = ${context.watch<PayloadPasser>().payload}");



              Navigator.pushReplacementNamed(context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION);
            });
          });
        }
        break;
    }

*/ /*      print("Notification click = $receivedNotification");
      print("Notification click  payload = ${receivedNotification.payload}");

      if(receivedNotification.buttonKeyPressed == "Accept"){
        print("buttonKeyPressed Accept = $receivedNotification");
        print("buttonKeyPressed payload = ${receivedNotification.payload}");

        // print("buttonKeyPressed actionLifeCycle = ${receivedNotification.actionLifeCycle}");
        // print("buttonKeyPressed displayedLifeCycle = ${receivedNotification.displayedLifeCycle}");
        // print("buttonKeyPressed createdLifeCycle = ${receivedNotification.createdLifeCycle}");
      }else if(receivedNotification.buttonKeyPressed == "Reject"){
        print("buttonKeyPressed Reject = $receivedNotification");
        print("buttonKeyPressed payload = ${receivedNotification.payload}");
      }

 */ /*
    });
  }*/
}
