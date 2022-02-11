import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:spocate/core/constants/message_constants.dart';

class NotificationUtils {
  // Singleton approach
  static final NotificationUtils _instance = NotificationUtils._internal();

  factory NotificationUtils() => _instance;

  NotificationUtils._internal();

  Future<void> showNotificationWithAction(RemoteMessage remoteMessage,
      String positiveActionText, String negativeActionText,
      {Map<String, String> payload}) async {
    String importanceKey =
        NotificationImportance.High.toString().toLowerCase().split('.').last;

    String channelKey = 'importance_' + importanceKey + '_channel';

    await AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: channelKey,
        channelName: remoteMessage.data['title'],
        channelDescription: remoteMessage.data['message'],
        importance: NotificationImportance.High,
        defaultColor: Colors.red,
        soundSource: 'resource://raw/sweet',
        playSound: true));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: remoteMessage.data.hashCode,
            channelKey: channelKey,
            title: remoteMessage.data['title'],
            body: remoteMessage.data['message'],
            color: Colors.indigoAccent,
            payload: payload ?? {}),
        actionButtons: [
          NotificationActionButton(
              key: positiveActionText,
              label: positiveActionText,
              autoCancel: false),
          NotificationActionButton(
              key: negativeActionText,
              label: negativeActionText,
              autoCancel: false)
        ]);

    if (remoteMessage.data['UserType'] == MessageConstants.SEEKER_NOTIFICATION_USER_TYPE &&
        remoteMessage.data['Notificationcode'] ==
        MessageConstants.SEEKER_NOTIFICATION_1_SPOT_LOCATED) {
      Future.delayed(Duration(seconds: 30), () async {
        await AwesomeNotifications().cancel(remoteMessage.data.hashCode);
      });
    }
  }

  Future<void> showNotificationWithOutAction(
      RemoteMessage remoteMessage) async {
    String importanceKey =
        NotificationImportance.High.toString().toLowerCase().split('.').last;

    String channelKey = 'importance_' + importanceKey + '_channel';

    await AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: channelKey,
        channelName: remoteMessage.data['title'],
        channelDescription: remoteMessage.data['message'],
        importance: NotificationImportance.High,
        defaultColor: Colors.red,
        soundSource: 'resource://raw/sweet',
        playSound: true));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: remoteMessage.data.hashCode,
          channelKey: channelKey,
          title: remoteMessage.data['title'],
          body: remoteMessage.data['message'],
          color: Colors.indigoAccent),
    );
  }

  Future<void> showNotificationWithTitleBody(
      int notificationId, String title, String body, bool isActionRequired) async {
    String importanceKey =
        NotificationImportance.High.toString().toLowerCase().split('.').last;

    String channelKey = 'importance_' + importanceKey + '_channel';

    await AwesomeNotifications().setChannel(NotificationChannel(
      channelKey: channelKey,
      channelName: title,
      channelDescription: body,
      importance: NotificationImportance.High,
      soundSource: 'resource://raw/sweet',
      playSound: true,
    ));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: channelKey,
          title: title,
          body: body,
        ),
        actionButtons: isActionRequired
            ? [
                NotificationActionButton(
                    key: 'Yes', label: 'Yes', autoCancel: true),
                NotificationActionButton(
                    key: 'No', label: 'No', autoCancel: false)
              ]
            : null);
  }

  Future<void> showNotificationWithOkAction(RemoteMessage remoteMessage,
      String positiveActionText,
      {Map<String, String> payload}) async {
    String importanceKey =
        NotificationImportance.High.toString().toLowerCase().split('.').last;

    String channelKey = 'importance_' + importanceKey + '_channel';

    await AwesomeNotifications().setChannel(NotificationChannel(
        channelKey: channelKey,
        channelName: remoteMessage.data['title'],
        channelDescription: remoteMessage.data['message'],
        importance: NotificationImportance.High,
        defaultColor: Colors.red,
        soundSource: 'resource://raw/sweet',
        playSound: true));

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: remoteMessage.data.hashCode,
            channelKey: channelKey,
            title: remoteMessage.data['title'],
            body: remoteMessage.data['message'],
            color: Colors.indigoAccent,
            payload: payload ?? {}),
        actionButtons: [
          NotificationActionButton(
              key: positiveActionText,
              label: positiveActionText,
              autoCancel: false),
        ]);
  }

  Future<void> cancelAllNotification() async {
     await AwesomeNotifications().cancelAll();
  }

  Future<void> cancelNotificationById(int notificationId) async {
    await AwesomeNotifications().cancel(notificationId);
  }

}
