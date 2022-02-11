// import 'dart:async';
// import 'dart:isolate';
// import 'dart:math';
// import 'dart:ui';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:background_locator/location_dto.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
// import 'package:spocate/data/remote/web_service.dart';
// import 'package:spocate/file_manager.dart';
// import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
// import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';
// import 'package:geocoder/geocoder.dart' as geoCoder;
// import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_request.dart';
// import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';
// import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
// import '../network_utils.dart';
//
//
//
// class LocationServiceRepository {
//   static LocationServiceRepository _instance = LocationServiceRepository._();
//
//
//
//   final RouteToDestRepository repository = RouteToDestRepository(
//       webservice: Webservice(), sharedPrefs: SharedPrefs());
//
//   double updatedTempValueRouteToDestination = 10000.0;
//   double updatedTempValueSpotAccepted = 1500.0;
//   DestLocation destLocation;
//   ProviderData providerData;
//
//
//   LocationServiceRepository._();
//
//   factory LocationServiceRepository() {
//     return _instance;
//   }
//
//   static const String isolateName = 'LocatorIsolate';
//
//
//   Future<void> init(Map<dynamic, dynamic> params) async {
//     print("***********Init callback handler");
//     await setLogLabel("start");
//     final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
//     send?.send(null);
//   }
//
//   Future<void> dispose() async {
//     print("***********Dispose callback handler");
//     await setLogLabel("end");
//     final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
//     send?.send(null);
//   }
//
//   Future<void> notificationCallback() async {
//     print("***********notificationCallback");
//   }
//
//   Future<void> callback(LocationDto locationDto) async {
//     // await setLogPosition(_count, locationDto);
//     final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
//     send?.send(locationDto);
//     getBackgroundValue(locationDto);
//
//   }
//
//   Future getBackgroundValue(LocationDto locationDto) async {
//    await  SharedPrefs().getBackgroundLocationScreen().then((screen) {
//
//       print("callback getBackgroundLocationScreen $screen");
//
//       switch (screen) {
//         case "1" :  _distanceBasedLocationUpdateAPI(locationDto);
//         break;
//         case "2" : _distanceBasedLocationUpdate(locationDto);
//         break;
//         default:
//           break;
//       }
//
//     });
//   }
//
//   _distanceBasedLocationUpdateAPI(LocationDto currentPosition) async {
//
//    await SharedPrefs().getDestLocationDetails().then((destDetails) {
//         destLocation = destDetails;
//       });
//
//     var distanceInMeter = Geolocator.distanceBetween(
//         currentPosition.latitude,
//         currentPosition.longitude,
//         destLocation.destLatitude,
//         destLocation.destLongitude);
//
//     if (distanceInMeter > 5000.toDouble() &&
//         distanceInMeter < 10000.toDouble()) {
//       if (distanceInMeter < updatedTempValueRouteToDestination) {
//         updatedTempValueRouteToDestination = updatedTempValueRouteToDestination - 2000;
//         _getAddressFromLocation(
//             currentPosition.latitude, currentPosition.longitude);
//         print("################### RouteToDestination $distanceInMeter #######################");
//       }
//     } else if (distanceInMeter > 1000.toDouble() &&
//         distanceInMeter < 5000.toDouble()) {
//       if (distanceInMeter < updatedTempValueRouteToDestination) {
//         updatedTempValueRouteToDestination = updatedTempValueRouteToDestination - 1000;
//         _getAddressFromLocation(
//             currentPosition.latitude, currentPosition.longitude);
//         print("################### RouteToDestination $distanceInMeter #######################");
//       }
//     } else if (distanceInMeter > 500.toDouble() &&
//         distanceInMeter < 1000.toDouble()) {
//       if (distanceInMeter < updatedTempValueRouteToDestination) {
//         updatedTempValueRouteToDestination = updatedTempValueRouteToDestination - 300;
//         _getAddressFromLocation(
//             currentPosition.latitude, currentPosition.longitude);
//         print("################### RouteToDestination $distanceInMeter #######################");
//       }
//     } else if (distanceInMeter > 100.toDouble() &&
//         distanceInMeter < 500.toDouble()) {
//       if (distanceInMeter < updatedTempValueRouteToDestination) {
//         updatedTempValueRouteToDestination = updatedTempValueRouteToDestination - 100;
//         _getAddressFromLocation(
//             currentPosition.latitude, currentPosition.longitude);
//         print("################### RouteToDestination $distanceInMeter #######################");
//       }
//     } else if (distanceInMeter > 0.toDouble() &&
//         distanceInMeter < 100.toDouble()) {
//       if (distanceInMeter < updatedTempValueRouteToDestination) {
//         updatedTempValueRouteToDestination = updatedTempValueRouteToDestination - 10;
//         _getAddressFromLocation(
//             currentPosition.latitude, currentPosition.longitude);
//         print("################### RouteToDestination $distanceInMeter #######################");
//       }
//     }
//   }
//
//   _getAddressFromLocation(double sourceLatitude, double sourceLongitude) async {
//     final coordinates = geoCoder.Coordinates(sourceLatitude, sourceLongitude);
//     var addresses =
//     await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
//    String  sourceAddress = addresses.first.addressLine;
//    String  sourcePinCode = addresses.first.postalCode;
//     print("sourceAddress $sourceAddress");
//     print("sourcePostalCode $sourcePinCode");
//     _submitUpdateLocation(sourceLatitude,sourceLongitude,sourceAddress,sourcePinCode);
//   }
//
//   Future<void> _submitUpdateLocation(double sourceLatitude, double sourceLongitude, String  sourceAddress,String  sourcePinCode) async {
//   String userId = await SharedPrefs().getUserId().then((userIdValue) {
//       return userIdValue;
//     });
//     await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
//
//       if (isInternetAvailable) {
//         var updateLocationRequest = UpdateLocationRequest(
//           userId: userId,
//           sourceLat: sourceLatitude.toString(),
//           sourceLong: sourceLongitude.toString(),
//           sourceAddress: sourceAddress,
//           sourcePinCode: sourcePinCode,
//           destLat: destLocation.destLatitude.toString(),
//           destLong: destLocation.destLongitude.toString(),
//           destAddress: destLocation.destAddress,
//           destPinCode: destLocation.destPostalCode,
//         );
//
//          repository.submitUpdateLocation(updateLocationRequest).then((updateLocationResponse) {
//            print("updateLocationResponse = $updateLocationResponse");
//            print("updatedTempValueRouteToDestination = $updatedTempValueRouteToDestination");
//            setLogWebResponse(updateLocationResponse);
//          });
//
//       } else {
//         // hear implement show local notification using awesome notification
//         /*AppWidgets.showSnackBar(
//             context, MessageConstants.MESSAGE_INTERNET_CHECK);*/
//       }
//     });
//   }
//
//                 /*------------------  SpotAccepted  ------------------ */
//   _distanceBasedLocationUpdate(LocationDto currentPosition) async {
//
//     await SharedPrefs().getSpotAcceptedProviderData().then((providerValue) {
//        providerData = providerValue;
//
//        double   destLatitude = double.parse(providerData.sourcelat);
//        double   destLongitude = double.parse(providerData.sourcelong);
//
//        var distanceInMeter = Geolocator.distanceBetween(
//            currentPosition.latitude, currentPosition.longitude, 13.122750, 80.128806);
//
//        // var distanceInMeter = Geolocator.distanceBetween(
//        //     currentPosition.latitude, currentPosition.longitude, destLatitude, destLongitude);
//
//        print("################### SpotAccepted outside condition $distanceInMeter #######################");
//
//        if (distanceInMeter > 100.toDouble() && distanceInMeter < 1500.toDouble()) {
//          if (distanceInMeter < updatedTempValueSpotAccepted) {
//            updatedTempValueSpotAccepted = updatedTempValueSpotAccepted - 250;
//            // Assigning the updated source lat long
//            processAddressParsing(
//                currentPosition.latitude, currentPosition.longitude, destLatitude, destLongitude);
//
//            print("################### SpotAccepted $distanceInMeter #######################");
//          }
//        } else if (distanceInMeter > 30.toDouble() &&
//            distanceInMeter < 100.toDouble()) {
//          if (distanceInMeter < updatedTempValueSpotAccepted) {
//            updatedTempValueSpotAccepted = updatedTempValueSpotAccepted - 30;
//            // Assigning the updated source lat long
//            processAddressParsing(
//                currentPosition.latitude, currentPosition.longitude, destLatitude, destLongitude);
//
//            print("################### SpotAccepted $distanceInMeter #######################");
//          }
//        } else if (distanceInMeter > 1.toDouble() &&
//            distanceInMeter < 30.toDouble()) {
//          print("################### SpotAccepted $distanceInMeter #######################");
//          showNotificationActionButtons();
//        }
//     });
//
//
//   }
//
//   Future<void> showNotificationActionButtons() async {
//     String importanceKey = NotificationImportance.High.toString().toLowerCase().split('.').last;
//
//     String channelKey = 'importance_' + importanceKey + '_channel';
//
//
//     await AwesomeNotifications().setChannel(NotificationChannel(
//         channelKey: channelKey,
//         channelName:'title',
//         channelDescription:  'message',
//         importance:  NotificationImportance.High,
//         defaultColor: Colors.red,
//         soundSource: 'resource://raw/sweet',
//         playSound: true,
//         ledColor: Colors.red
//     ));
//
//     await AwesomeNotifications().createNotification(
//         content: NotificationContent(
//             id: 1001,
//             channelKey: channelKey,
//             title: 'Spocate',
//             body: 'Have you spotted the Provider?',
//             color: Colors.indigoAccent,
//             payload: {'uuid': 'uuid-test'}),
//         actionButtons: [
//           NotificationActionButton(
//               key: 'Yes', label: 'Yes', autoCancel: true),
//           NotificationActionButton(
//               key: 'No', label: 'No', autoCancel: false)
//         ]);
//
//   }
//
//   Future<void> processAddressParsing(double sourceLatitude,
//       double sourceLongitude, double destLatitude, double destLongitude) async {
// /*    _getSourceAddressFromLocation(sourceLatitude, sourceLongitude)
//         .then((value) {
//       _getDestAddressFromLocation(destLatitude, destLongitude).then((value) {
//         // _getTravelTimeAndDistance(
//         //     "$sourceLatitude,$sourceLongitude", "$destLatitude,$destLongitude");
//       });
//     });*/
//   }
//
// /*  Future<void> _getSourceAddressFromLocation(
//       double latitude, double longitude) async {
//     final coordinates = geoCoder.Coordinates(latitude, longitude);
//     var addresses =
//     await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
//     sourceAddress = addresses.first.addressLine;
//     sourcePinCode = addresses.first.postalCode;
//     print("sourceAddress $sourceAddress");
//     print("sourcePostalCode $sourcePinCode");
//   }
//
//   Future<void> _getDestAddressFromLocation(
//       double latitude, double longitude) async {
//     final coordinates = geoCoder.Coordinates(latitude, longitude);
//     var addresses =
//     await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
//     destAddress = addresses.first.addressLine;
//     destPinCode = addresses.first.postalCode;
//     print("destAddress $destAddress");
//     print("destPinCode $destPinCode");
//   }
//  */
// /*  Future<void> _getTravelTimeAndDistance(
//       String sourceLatLong, String destLatLong) async {
//     await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
//       if (isInternetAvailable) {
//         _timeAndDistanceBloc.add(TimeAndDistanceTriggerEvent(
//             sourceLatLong: sourceLatLong, destLatLong: destLatLong,travelMode: WebConstants.DISTANCE_MODE_DRIVING));
//       } else {
//         AppWidgets.showSnackBar(
//             context, MessageConstants.MESSAGE_INTERNET_CHECK);
//       }
//     });
//   }*/
//
//   static Future<void> setLogLabel(String label) async {
//     final date = DateTime.now();
//     await FileManager.writeToLogFile(
//         '------------\n$label: ${formatDateLog(date)}\n------------\n');
//   }
//
//   static Future<void> setLogPosition(int count, LocationDto data) async {
//     final date = DateTime.now();
//     await FileManager.writeToLogFile(
//         '$count : ${formatDateLog(date)} --> ${formatLog(data)} --- isMocked: ${data.isMocked}\n');
//   }
//
//   static Future<void> setLogWebResponse(UpdateLocationResponse response) async {
//     final date = DateTime.now();
//       await FileManager.writeToLogFile(
//           ': ${formatDateLog(date)} --> $response \n');
//   }
//
//   static double dp(double val, int places) {
//     double mod = pow(10.0, places);
//     return ((val * mod).round().toDouble() / mod);
//   }
//
//   static String formatDateLog(DateTime date) {
//     return date.hour.toString() +
//         ":" +
//         date.minute.toString() +
//         ":" +
//         date.second.toString();
//   }
//
//   static String formatLog(LocationDto locationDto) {
//     return dp(locationDto.latitude, 4).toString() +
//         " " +
//         dp(locationDto.longitude, 4).toString();
//   }
// }
