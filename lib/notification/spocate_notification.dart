import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class SpocateNotification {
  SpocateNotification({
        this.data,
      });

  dynamic data;

  factory SpocateNotification.fromJson(RemoteMessage remoteMessage) {
    return SpocateNotification(
      data: jsonDecode(remoteMessage.data['data']),
    );
  }
}

