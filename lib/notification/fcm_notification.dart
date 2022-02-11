import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/location/bg_service_handler.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/notification/provider_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/utils/notification_utils.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Firebase Background data ${message.data.toString()}");
  print("Firebase Background data sentTime ${message.sentTime}");
  print(message.data);

  SharedPrefs().setSpState("1");

  try{
    print("Background message = $message");
    print("Background data  = ${message.data['data']}");
    print("Background Notification code = ${message.data['Notificationcode']}");
    print("Background UserType = ${message.data['UserType']}");
    // SharedPrefs().setNotificationTime("${message.sentTime} ${message.data['message']}");

    switch(message.data['UserType']){
      case MessageConstants.SEEKER_NOTIFICATION_USER_TYPE :{
        switch(message.data['Notificationcode']){
          case MessageConstants.SEEKER_NOTIFICATION_1_SPOT_LOCATED : {
            NotificationUtils().showNotificationWithAction(message , "Accept" , "Ignore", payload : {});
            ProviderData _spotProviderData = SpotLocatedNotification.fromJson(message).data;
            SharedPrefs().setSpotAcceptedProviderData(_spotProviderData);
            break ;
          }
          case MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP : {
            BGServiceHandler().stopBackgroundService();
            NotificationUtils().showNotificationWithOkAction(message , "Ok");
            ProviderData _spotProviderData = SpotLocatedNotification.fromJson(message).data;
            SharedPrefs().setSpotAcceptedProviderData(_spotProviderData);
            break ;
          }
          case MessageConstants.SEEKER_NOTIFICATION_2_SPOT_CONFIRMED : {
            NotificationUtils().showNotificationWithOutAction(message);
            ProviderData _spotProviderData = SpotLocatedNotification.fromJson(message).data;
            SharedPrefs().setSpotAcceptedProviderData(_spotProviderData);
            break;
          }
          case MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME : {
            NotificationUtils().showNotificationWithOkAction(message , "Ok");
            SharedPrefs().setNotificationCode(message.data['Notificationcode']);
            SharedPrefs().setNotificationMessage(message.data['message']);
            SharedPrefs().setNotificationUserType(message.data['UserType']);
            break;
          }
          case MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME : {
            BGServiceHandler().stopBackgroundService();
            NotificationUtils().showNotificationWithOkAction(message , "Ok");
            ProviderData _spotProviderData = SpotLocatedNotification.fromJson(message).data;
            SharedPrefs().setSpotAcceptedProviderData(_spotProviderData);
            break ;
          }
          // this case to be removed as we do not receiving notification for this
          // case MessageConstants.MESSAGE_SEEKER_NOTIFICATION_PROVIDER_REACHED : {
          //   NotificationUtils().showNotificationWithAction(message , "Yes" , "No");
          //   break ;
          // }
          default : break;
        }
        break;
      }
      case MessageConstants.PROVIDER_NOTIFICATION_USER_TYPE : {
        switch(message.data['Notificationcode']){
          case MessageConstants.PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY : {
            NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No", payload :{});
            SeekerData _seekerData = ProviderNotification.fromJson(message).data;
            SharedPrefs().setProviderWaitingSeekerData(_seekerData);
            break ;
          }
          case MessageConstants.PROVIDER_NOTIFICATION_2_SEEKER_REACHED : {
            NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No");
            SeekerData _seekerData = ProviderNotification.fromJson(message).data;
            SharedPrefs().setProviderWaitingSeekerData(_seekerData);
            break ;
          }
          case MessageConstants.PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER : {
            NotificationUtils().showNotificationWithOkAction(message , "Ok");
            SeekerData _seekerData = ProviderNotification.fromJson(message).data;
            SharedPrefs().setProviderWaitingSeekerData(_seekerData);
            break ;
          }
          case MessageConstants.PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER : {
            NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No");
            SeekerData _seekerData = ProviderNotification.fromJson(message).data;
            SharedPrefs().setProviderWaitingSeekerData(_seekerData);
            break ;
          }
          case MessageConstants.PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME : {
            NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No");
            SharedPrefs().setNotificationCode(message.data['Notificationcode']);
            SharedPrefs().setNotificationMessage(message.data['message']);
            SharedPrefs().setNotificationUserType(message.data['UserType']);
            break ;
          }
          default : break;
        }
        break;
      }
    }
  }
  catch(e){
    print("Background message Exception = $e");
  }
}


Future<void> _firebaseMessagingForegroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    print("Firebase Foreground data ${message.data.toString()}");
  }
}
class FirebaseNotification {

  int prevId ;
  initialize() async {

    await Firebase.initializeApp();
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      print("New token onTokenRefresh:  $token");
      SharedPrefs().setNotificationOnTokenRefresh(token);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_firebaseMessagingForegroundHandler);

       await  FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Update the iOS foreground notification presentation options to allow
    // heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try{
        print("onMessage listen = data ${message.data.toString()}");
        print("onMessage listen = $message");
        // SharedPrefs().setNotificationTime("${message.sentTime} ${message.data['message']}");

        switch(message.data['UserType']){
          case MessageConstants.SEEKER_NOTIFICATION_USER_TYPE : {
            switch(message.data['Notificationcode']){
              case MessageConstants.SEEKER_NOTIFICATION_1_SPOT_LOCATED : {
                // ProviderData _spotProviderData = SpotLocatedNotification.fromJson(message).data;
                NotificationUtils().showNotificationWithAction(message , "Accept" , "Ignore", payload :{});
                break ;
              }
              // case MessageConstants.MESSAGE_SEEKER_NOTIFICATION_PROVIDER_REACHED : {
              //   showNotificationActionButtons(message , "Yes" , "No");
              //   break ;
              // }
              case MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP : {
                BGServiceHandler().stopBackgroundService();
                NotificationUtils().showNotificationWithOkAction(message , "Ok");
                break ;
              }
              case MessageConstants.SEEKER_NOTIFICATION_2_SPOT_CONFIRMED : {
                NotificationUtils().showNotificationWithOutAction(message);
                break;
              }
              case MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME : {
                NotificationUtils().showNotificationWithOkAction(message , "Ok");
                break ;
              }
              case MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME : {
                BGServiceHandler().stopBackgroundService();
                NotificationUtils().showNotificationWithOkAction(message , "Ok");
                break ;
              }
            }
            break;
          }
          case MessageConstants.PROVIDER_NOTIFICATION_USER_TYPE : {
            switch(message.data['Notificationcode']){
              case MessageConstants.PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY : {
                // SeekerData _seekerData = ProviderNotification.fromJson(message).data;
                NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No", payload :{});
                break ;
              }
              case MessageConstants.PROVIDER_NOTIFICATION_2_SEEKER_REACHED : {
                NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No",);
                break ;
              }
              case MessageConstants.PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER : {
                NotificationUtils().showNotificationWithOkAction(message , "Ok");
                break ;
              }
              case MessageConstants.PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER : {
                NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No");
                break ;
              }
              case MessageConstants.PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME : {
                NotificationUtils().showNotificationWithAction(message , "Yes" ,  "No");
                break ;
              }
              default : break;
            }
            break;
          }
        }
      }
      catch(e){
        print("onMessage Exception = $e");
      }
    });

  }
  Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print("Firebase Push Token $token");
    return token;
  }
  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}

































/*
// when app is minimized and in background state the onMessageOpenedApp will listen
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print("onMessageOpenedApp Background data ${message.data.toString()}");
    });

// when app gets or is Terminated state the getInitialMessage() will give you respective notification data
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage remoteMessage) {
      if (remoteMessage != null) {
        print('A new getInitialMessage event was published!');
        print("getInitialMessage Background data ${remoteMessage.data.toString()}");

        NotificationNavigation.setCommonNotificationMessage(CommonNotification.fromJson(remoteMessage).data.message);
        print("getInitialMessage commonNotificationMessage ${NotificationNavigation.commonNotificationMessage}");
      }
    });
    */