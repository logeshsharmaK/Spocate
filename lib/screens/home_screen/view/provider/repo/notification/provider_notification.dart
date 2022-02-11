import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';

class ProviderNotification {
  ProviderNotification({
    this.data,
  });

  SeekerData data;


  factory ProviderNotification.fromJson(RemoteMessage remoteMessage) {
    return ProviderNotification(
      data: new SeekerData.fromJson(jsonDecode(remoteMessage.data['data'])),
    );
  }
}

class SeekerData {
  String carNumber;
  String destinationLat="";
  String drivingMinutes;
  int seekerId=0;
  String address;
  String destinationLong="";
  String sourceLong;
  String name;
  String carMake;
  String carModel;
  String sourceLat;
  int userId;
  String carColor;
  int spotId;
  String distance;
  String message;
  String notificationCode;
  String userType;

  SeekerData(
      {
    this.carNumber,
    this.destinationLat,
    this.drivingMinutes,
    this.seekerId,
    this.address,
    this.destinationLong,
    this.sourceLong,
    this.name,
    this.carMake,
    this.carModel,
    this.sourceLat,
    this.userId,
    this.carColor,
    this.spotId,
    this.distance,
    this.message,
    this.notificationCode,
    this.userType,
  }
  );

  SeekerData.fromJson(dynamic json) {
    carNumber = json["CarNumber"];
    destinationLat = json["Destinationlat"];
    drivingMinutes = json["DrivingMinutes"];
    seekerId = json["SeekerId"];
    address = json["Address"];
    destinationLong = json["Destinationlong"];
    sourceLong = json["Sourcelong"];
    name = json["Name"];
    carMake = json["CarMake"];
    carModel = json["CarModel"];
    sourceLat = json["Sourcelat"];
    userId = json["UserId"];
    carColor = json["CarColor"];
    spotId = json["SpotId"];
    distance = json["Distance"];
    message = json["Message"];
    notificationCode = json["Notificationcode"];
    userType = json["UserType"];
  }


  Map<String, String> toJson() {
    var map = <String, String>{};
    map['CarNumber'] = carNumber;
    map["Destinationlat"] = destinationLat;
    map["DrivingMinutes"] = drivingMinutes;
    map["SeekerId"] = seekerId.toString();
    map["Address"] = address;
    map["Destinationlong"] = destinationLong;
    map["Sourcelong"] = sourceLong;
    map["Name"] = name;
    map["CarMake"] = carMake;
    map["CarModel"] = carModel;
    map["Sourcelat"] = sourceLat;
    map["UserId"] = userId.toString();
    map["CarColor"] = carColor;
    map["SpotId"] = spotId.toString();
    map["Distance"] = distance;
    map["Message"] = message;
    map["Notificationcode"] = notificationCode;
    map["UserType"] = userType;
    return map;
  }
}

