import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationParser {
  NotificationParser({
    this.data,
  });

  NotificationParsedData data;

  factory NotificationParser.fromJson(RemoteMessage remoteMessage) {
    return NotificationParser(
      data: new NotificationParsedData.fromJson(
          jsonDecode(remoteMessage.data['data'])),
    );
  }
}

class NotificationParsedData {
  String notificationFor;
  String carNumber;
  String carColor;
  String carMake;
  String carModel;
  String sourcelat;
  String destinationlat;
  String drivingMinutes;
  String destinationlong;
  int userId;
  String sourcelong;
  int spotId;
  String name;
  String address;
  String distance;
  String message;
  String spotToDestination;
  String seekerId;

  NotificationParsedData({
    this.carNumber,
    this.carColor,
    this.carMake,
    this.carModel,
    this.sourcelat,
    this.destinationlat,
    this.drivingMinutes,
    this.destinationlong,
    this.userId,
    this.sourcelong,
    this.spotId,
    this.name,
    this.address,
    this.distance,
    this.message,
    this.spotToDestination,
  });

  NotificationParsedData.fromJson(dynamic json) {
    carNumber = json['CarNumber'] ?? "";
    carColor = json['CarColor'] ?? "";
    carMake = json['CarMake'] ?? "";
    carModel = json['CarModel'] ?? "";
    sourcelat = json['Sourcelat'] ?? "";
    destinationlat = json['Destinationlat'] ?? "0.0";
    drivingMinutes = json['DrivingMinutes'] ?? "0.0";
    destinationlong = json['Destinationlong'] ?? "0.0";
    userId = json['UserId'] ?? "";
    sourcelong = json['Sourcelong'] ?? "";
    spotId = json['SpotId'] ?? "";
    name = json['Name'] ?? "";
    address = json['Address'] ?? "";
    distance = json['Distance'] ?? "0.0";
    message = json['Message'] ?? "";
    spotToDestination = json['SpottoDestination'] ?? "";
    seekerId = json['SeekerId'] ?? "";
  }

  Map<String, String> toJson() {
    var map = <String, String>{};
    map['CarNumber'] = carNumber;
    map["CarColor"] = carColor;
    map["CarMake"] = carMake;
    map["CarModel"] = carModel;
    map["Sourcelat"] = sourcelat;
    map["Destinationlat"] = destinationlat;
    map["DrivingMinutes"] = drivingMinutes;
    map["Destinationlong"] = destinationlong;
    map["UserId"] = userId.toString();
    map["Sourcelong"] = sourcelong;
    map["SpotId"] = spotId.toString();
    map["Name"] = name;
    map["Address"] = address;
    map["Distance"] = distance;
    map["Message"] = message;
    map["SpottoDestination"] = spotToDestination;
    map['SeekerId']  = seekerId;
    return map;
  }
}
