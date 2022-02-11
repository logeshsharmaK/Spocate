import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/utils/location_utils/location_utils.dart';
import 'package:spocate/utils/notification_utils.dart';
import '../file_manager.dart';
import '../stream_utils.dart';

class BGLocationUpdates {
  // Singleton approach
  static final BGLocationUpdates _instance = BGLocationUpdates._internal();

  factory BGLocationUpdates() => _instance;

  BGLocationUpdates._internal();

  static const String isolateName = 'LocatorIsolate';

  static bool showNotificationOneTime = false;

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    await setLogLabel("start");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    // await setLogPosition(_count, locationDto);
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    print("Sending stream as location ${locationDto.latitude}");
    StreamUtils().addStreamData();
    processBackgroundLocation(locationDto);
  }

  Future<void> processBackgroundLocation(LocationDto locationDto) async {
    await SharedPrefs().getBackgroundLocationScreen().then((screen) {
      print("callback getBackgroundLocationScreen $screen");

      switch (screen) {
        case "1":
          processRouteToDestLocationUpdate(locationDto);
          break;
        case "2":
          processSpotAcceptedLocationUpdate(locationDto);
          break;
        default:
          break;
      }
    });
  }

  Future<void> processRouteToDestLocationUpdate(LocationDto locationDto) {
// 1. Get Location
// 2. Distance based Location update
// 3. Address parsing with postal code
// 4. Submit Location Update
    showNotificationOneTime = false;
    LocationUtils().getSharedPrefUserId().then((userIdValue) {
      print("BG Dest userIdValue $userIdValue");
      LocationUtils().getSharedPrefDestLocation().then((destLocation) async {
        print("BG Dest destLocation ${destLocation.toString()}");
        await LocationUtils()
            .distanceBasedLocationUpdateAPI(
                locationDto.latitude,
                locationDto.longitude,
                destLocation.destLatitude,
                destLocation.destLongitude)
            .then((isParsingRequired) {
              // StreamUtils().addEmit()
          print("BG Dest isParsingRequired $isParsingRequired");
          LocationUtils()
              .getAddressFromLocation(
                  locationDto.latitude, locationDto.longitude)
              .then((locationAddress) {
            print("BG Dest locationAddress ${locationAddress.toString()}");
            LocationUtils()
                .submitUpdateLocation(
                    locationDto.latitude,
                    locationDto.longitude,
                    locationAddress.address,
                    locationAddress.postalCode,
                    useProviderData: false)
                .then((emptyValue) {
              print("BG Dest Location submitted successfully");
            });
          });
        });
      });
    });
  }

  // Stream<bool> checkIsDestinationReached() async* {
  //   isDestReached.add(true);
  //   yield true;
  // }

  Future<void> processSpotAcceptedLocationUpdate(LocationDto locationDto) {
// 1. Get Location
// 2. Distance based Location update
// 3. Address parsing with postal code
// 4. Get Time and Distance
// 5. Submit Location Update
    LocationUtils().getSharedPrefUserId().then((userIdValue) {
      print("BG Dest userIdValue $userIdValue");
      LocationUtils().getSharedPrefProviderData().then((providerData) async {
        print("BG Dest destLocation ${providerData.toString()}");
        await LocationUtils()
            .checkDestinationReached(
                locationDto.latitude, locationDto.longitude, providerData)
            .then((isParsingRequired) {

          print("BG Dest isParsingRequired $isParsingRequired  ");
          if (isParsingRequired == "2") {
            if(!showNotificationOneTime){
              showNotificationOneTime = true;
              NotificationUtils().showNotificationWithTitleBody(1001, MessageConstants.APP_NAME, MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED, false);
              SharedPrefs().setSpState("1");
              SharedPrefs().setNotificationUserType(MessageConstants.SEEKER_NOTIFICATION_USER_TYPE);
              SharedPrefs().setNotificationCode(MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED);
              SharedPrefs().setNotificationMessage(MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED);
              // Future.delayed(
              //     Duration(
              //         minutes: 6
              //     ),
              //         () async {
              //           NotificationUtils().showNotificationWithTitleBody(1001, MessageConstants.APP_NAME, MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED, false);
              //           SharedPrefs().setSpState("1");
              //           SharedPrefs().setNotificationUserType(MessageConstants.SEEKER_NOTIFICATION_USER_TYPE);
              //           SharedPrefs().setNotificationCode(MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED);
              //           SharedPrefs().setNotificationMessage(MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED);
              //     });

            }
          } else {
            LocationUtils()
                .getAddressFromLocation(
                    locationDto.latitude, locationDto.longitude)
                .then((locationAddress) {
              print("BG Dest locationAddress ${locationAddress.toString()}");
              LocationUtils()
                  .processTravelTimeAndDistance(
                      locationDto.latitude,
                      locationDto.longitude,
                      double.parse(providerData.sourcelat),
                      double.parse(providerData.sourcelong))
                  .then((destTimeAndDistance) {
                print(
                    "BG Dest duration ${destTimeAndDistance.duration} distance ${destTimeAndDistance.distance} ");
                LocationUtils()
                    .submitUpdateLocation(
                        locationDto.latitude,
                        locationDto.longitude,
                        locationAddress.address,
                        locationAddress.postalCode,
                        distanceValue: destTimeAndDistance.distance,
                        durationValue: destTimeAndDistance.duration,
                        providerData : providerData ,
                        useProviderData: true)
                    .then((emptyValue) {
                  print("BG Dest Location submitted successfully");
                });
              });
            });
          }
        });
      });
    });
  }

  Future<void> notificationCallback() async {
    print("***********notificationCallback");
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    await setLogLabel("end");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '------------\n$label: ${formatDateLog(date)}\n------------\n');
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
  }

  static double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }

// static Future<void> setLogWebResponse(UpdateLocationResponse response) async {
//   final date = DateTime.now();
//   await FileManager.writeToLogFile(
//       ': ${formatDateLog(date)} --> $response \n');
// }
}
