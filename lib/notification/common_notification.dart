import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class CommonNotification {
  CommonNotification({
    this.title,
    this.body,
    this.data,

  });

  String title;
  String body;
  NotificationData data;



  factory CommonNotification.fromJson(RemoteMessage remoteMessage) {
    return CommonNotification(
      title: remoteMessage.notification.title,
      body: remoteMessage.notification.body,
      data: new NotificationData.fromJson(jsonDecode(remoteMessage.data['data'])),
    );
  }
}


class NotificationData {
  String message;

  NotificationData(
      {
        this.message,
        });

  NotificationData.fromJson(dynamic json) {
    message = json['Message'];
  }

}