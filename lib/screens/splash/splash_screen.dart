import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/source_and_dest.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String routeValue;
  BuildContext providerContext;
  bool isActionSteam = false;

  @override
  void initState() {
    initializeNavigation();
    super.initState();
  }

  initializeNavigation() {
    var value = "234523473456";
    // print("App Util isValidString ${AppUtils.isValidString(value)}");
    // print("App Util isValidEmail ${AppUtils.isValidEmail(value)}");
    // print("App Util isValidPhone ${AppUtils.isValidPhone(value)}");
    // print("App Util isValidNumber ${AppUtils.isValidNumber(value)}");
    // print("App Util isNumeric ${AppUtils.isNumeric(value)}");

    // if(AppUtils.isNumeric(value)){
    //   // All Numbers
    //   print("App Util isNumeric ${AppUtils.isNumeric(value)}");
    //   if(AppUtils.isValidPhone(value)){
    //     print("App Util isValidPhone ${AppUtils.isValidPhone(value)}");
    //   }else{
    //     print("App Util enter valid number");
    //   }
    // }else{
    //   // All Strings
    //   print("App Util isString}");
    //   if(AppUtils.isValidEmail(value)){
    //     print("App Util isValidEmail ${AppUtils.isValidEmail(value)}");
    //   }else{
    //     print("App Util enter valid email");
    //   }
    // }

    Future.delayed(Duration(seconds: 2), () {
      SharedPrefs().getSpState().then((spState) {
        print("Splash spState $spState");
        if (spState == "1") {
          _initializeNotificationClickListener();
        } else {
          SharedPrefs().getUserId().then((userIdValue) {
            print("Splash userIdValue $userIdValue");
            _launchAppNavigation(userIdValue);
          });
        }
      });
    });
  }

  _initializeNotificationClickListener() {
    print("SPLASH _initializeNotification");
    AwesomeNotifications().actionStream.listen((receivedNotification) {
      isActionSteam = true;
      print("SPLASH actionStream.listen isActionSteam 1 $isActionSteam");
      _notificationClickToNavigation();
    });
    Future.delayed(Duration(seconds: 1), () {
      print("SPLASH app icon click isActionSteam  $isActionSteam");
      if (!isActionSteam) {
        _notificationClickToNavigation();
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            WordConstants.SPLASH_APP_NAME,
            style: TextStyle(
                fontSize: SizeConstants.SIZE_46,
                fontWeight: FontWeight.w500,
                color: ColorConstants.primaryColor),
          ),
          SizedBox(
            height: SizeConstants.SIZE_16,
          ),
          Text(
            WordConstants.SPLASH_APP_LOGO_SUBTITLE,
            style: TextStyle(
                fontSize: SizeConstants.SIZE_26,
                fontWeight: FontWeight.w400,
                color: ColorConstants.primaryColor),
          )
        ],
      ),
    ));
  }

  _notificationClickToNavigation() async {
    SharedPrefs().getNotificationUserType().then((userType) {
      print("SPLASH  NotificationUserType  $userType");
      switch(userType){
        case MessageConstants.SEEKER_NOTIFICATION_USER_TYPE : {
          SharedPrefs().getNotificationCode().then((notificationCode) async {
            print("SPLASH NotificationCode  $notificationCode");
            switch (notificationCode) {
              case MessageConstants.SEEKER_NOTIFICATION_1_SPOT_LOCATED:
                {
                  // Route to Dest
                  await SharedPrefs()
                      .getSourceLocationDetails()
                      .then((sourceDetails) async {
                    await SharedPrefs().getDestLocationDetails().then((destDetails) {
                      print("sourceDetails = ${sourceDetails.sourceLongitude}");
                      print("destDetails   = ${destDetails.destAddress}");
                      print("destDetails   = ${destDetails.destLatitude}");
                      print("destDetails   = ${destDetails.destLongitude}");
                      if (mounted) {
                        Navigator.pushNamed(
                            context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION,
                            arguments: SourceAndDest(
                                sourceLocation: sourceDetails,
                                destLocation: destDetails));
                      }
                    });
                  });
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP:
                {
                  // Spot Accepted
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_SPOT);
                  }
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED:
                {
                  // Spot Accepted
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_SPOT);
                  }
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME:
                {
                  // Spot Accepted
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_SPOT);
                  }
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME:
                {
                  // Spot Accepted
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_SPOT);
                  }
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_6_EXTENDED_TIME:
                {
                  // Spot Accepted
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_SPOT);
                  }
                  break;
                }
              case MessageConstants.SEEKER_NOTIFICATION_2_SPOT_CONFIRMED:
                {
                  // Provider Confirmed
                  if (mounted) {
                    Navigator.pushNamed(
                        context,
                        RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION);
                  }
                  break;
                }
            }
          });
          break;
        }
        case MessageConstants.PROVIDER_NOTIFICATION_USER_TYPE : {
          SharedPrefs().getNotificationCode().then((notificationCode) {
            print("SPLASH NotificationCode  $notificationCode");
            switch (notificationCode) {
              case MessageConstants.PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY:
                {
                  // Provider Waiting - Another Car...
                  SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                    print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                    print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                    sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                        arguments: sourceDetails);
                  });
                  break;
                }
              case MessageConstants.PROVIDER_NOTIFICATION_2_SEEKER_REACHED:
                {
                  // Provider Waiting - Have you spotted seeker
                  SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                    print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                    print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                    sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                        arguments: sourceDetails);
                  });
                  break;
                }
              case MessageConstants.PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER:
                {
                  // Provider Waiting - Have you spotted seeker
                  SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                    print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                    print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                    sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                        arguments: sourceDetails);
                  });
                  break;
                }
              case MessageConstants.PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER:
                {
                  // Provider Waiting - Have you spotted seeker
                  SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                    print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                    print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                    sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                        arguments: sourceDetails);
                  });
                  break;
                }
              case MessageConstants.PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME:
                {
                  // Provider Waiting - Have you spotted seeker
                  SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                    print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                    print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                    sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                        arguments: sourceDetails);
                  });
                  break;
                }
            }
          });
          break;
        }
      }
    });
  }

  _launchAppNavigation(String userIdValue) async {
    if (userIdValue != "null" && userIdValue.isNotEmpty) {
      SharedPrefs().getLastVisitedScreen().then((lastVisitedScreen) async {
        switch (lastVisitedScreen) {
          case AppBarConstants.APP_BAR_HOME:
            {
              Navigator.pushReplacementNamed(
                  context, RouteConstants.ROUTE_HOME_SCREEN);
              break;
            }
          case AppBarConstants.APP_BAR_ROUTE_TO_DESTINATION:
            {
              await SharedPrefs()
                  .getSourceLocationDetails()
                  .then((sourceDetails) async {
                await SharedPrefs()
                    .getDestLocationDetails()
                    .then((destDetails) {
                  print("sourceDetails = ${sourceDetails.sourceLongitude}");
                  print("destDetails   = ${destDetails.destAddress}");
                  print("destDetails   = ${destDetails.destLatitude}");
                  print("destDetails   = ${destDetails.destLongitude}");
                  if (mounted) {
                    Navigator.pushNamed(
                        context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION,
                        arguments: SourceAndDest(
                            sourceLocation: sourceDetails,
                            destLocation: destDetails));
                  }
                });
              });
              break;
            }
          case AppBarConstants.APP_BAR_ROUTE_TO_SPOT:
            {
              Navigator.pushNamed(context,
                  RouteConstants.ROUTE_ROUTE_TO_SPOT);
              break;
            }
          case AppBarConstants.APP_BAR_WAIT_FOR_SEEKER:
            {
              SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                Navigator.pushNamed(
                    context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                    arguments: sourceDetails);
              });
              break;
            }
          case AppBarConstants.APP_BAR_WAIT_FOR_SEEKER:
            {
              SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                Navigator.pushNamed(
                    context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                    arguments: sourceDetails);
              });
              break;
            }
          case AppBarConstants.APP_BAR_WAIT_FOR_SEEKER:
            {
              SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
                sourceDetails.navigatedFrom = RouteConstants.ROUTE_SPLASH;
                print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
                print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
                Navigator.pushNamed(
                    context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                    arguments: sourceDetails);
              });
              break;
            }
        }
      });
    } else {
      Navigator.pushReplacementNamed(context, RouteConstants.ROUTE_LOGIN);
    }
  }
}
