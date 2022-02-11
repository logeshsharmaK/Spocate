import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geocoder/geocoder.dart' as geoCoder;
import 'package:geolocator/geolocator.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/repo/time_and_distance_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/update_location/update_location_response.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
import 'package:spocate/utils/location_utils/dest_time_and_distance.dart';
import 'package:spocate/utils/location_utils/location_address.dart';
import '../notification_utils.dart';

class LocationUtils {
  // Singleton approach
  static final LocationUtils _instance = LocationUtils._internal();

  factory LocationUtils() => _instance;

  LocationUtils._internal();
  var distanceList = [];

  ////////////////////// Route to Dest ////////////////////////
  // Distance Calculate operation
  double updatedTempValue = 10000.0;

  // Shared Preferences values
  String userId = "";
  DestLocation destLocation;

  // Webservice operations for location update
  UpdateLocationResponse updateLocationResponse;

  ////////////////////// Spot Accepted ////////////////////////
  ProviderData providerData;

  // Distance Calculate operation
  double updatedTempValueSpotAccepted = 1000.0;

  // Webservice operations for time and distance
  TimeAndDistanceResponse timeAndDistanceResponse;

  // INTERNET CHECK FIRST CALL
  Future<String> getSharedPrefUserId() async {
    if (userId.isNotEmpty) {
      return userId;
    } else {
      await SharedPrefs().getUserId().then((userIdValue) {
        userId = userIdValue;
      });
      return userId;
    }
  }

  Future<DestLocation> getSharedPrefDestLocation() async {
    if (destLocation != null) {
      return destLocation;
    } else {
      await SharedPrefs().getDestLocationDetails().then((destValue) {
        destLocation = destValue;
      });
      return destLocation;
    }
  }

  Future<ProviderData> getSharedPrefProviderData() async {
    if (providerData != null) {
      return providerData;
    } else {
      await SharedPrefs()
          .getSpotAcceptedProviderData()
          .then((providerDataValue) {
        providerData = providerDataValue;
      });
      return providerData;
    }
  }

  Future<bool> distanceBasedLocationUpdateAPI(
      double sourceLat, double sourceLong, double destLat, double destLong) {
    var distanceInMeter =
        Geolocator.distanceBetween(sourceLat, sourceLong, destLat, destLong);

    // List<double> distanceList = l
    distanceList.add(distanceInMeter);

    print("distanceList = $distanceList");
    print("distanceList = ${distanceList[0]}");

    Future<bool> temp = Future<bool>.value(false);
    if (distanceInMeter > 5000.toDouble() &&
        distanceInMeter <= 10000.toDouble()) {
      if (distanceInMeter < distanceList[0]) {
        distanceList[0] = distanceList[0] - 2000;
        temp = Future<bool>.value(true);
      }
    } else if (distanceInMeter > 1000.toDouble() &&
        distanceInMeter < 5000.toDouble()) {
      if (distanceInMeter < distanceList[0]) {
        distanceList[0] = distanceList[0] - 1000;
        temp = Future<bool>.value(true);
      }
    } else if (distanceInMeter < 1000.toDouble()) {
      if (distanceInMeter < distanceList[0]) {
        print("distanceList if before = ${distanceList[0]}");
        distanceList[0] = distanceList[0] - 100;
        print("distanceList if before = ${distanceList[0]}");
        temp = Future<bool>.value(true);
      }
    } else {
      temp = Future<bool>.value(false);
    }
    return temp;
  }

  Future<LocationAddress> getAddressFromLocation(
      double sourceLatitude, double sourceLongitude) async {
    final coordinates = geoCoder.Coordinates(sourceLatitude, sourceLongitude);
    var addresses =
        await geoCoder.Geocoder.local.findAddressesFromCoordinates(coordinates);
    return LocationAddress(
        address: addresses.first.addressLine,
        postalCode: addresses.first.postalCode);
  }

  Future<void> submitUpdateLocation(double sourceLatitude,
      double sourceLongitude, String sourceAddress, String sourcePinCode,
      {String distanceValue = "",
      String durationValue = "",
      ProviderData providerData,
      bool useProviderData}) async {
    var updateLocationRequest = UpdateLocationRequest(
        userId: userId,
        sourceLat: sourceLatitude.toString(),
        sourceLong: sourceLongitude.toString(),
        sourceAddress: sourceAddress,
        sourcePinCode: sourcePinCode,
        destLat: useProviderData
            ? providerData.sourcelat
            : destLocation.destLatitude.toString(),
        destLong: useProviderData
            ? providerData.sourcelong
            : destLocation.destLongitude.toString(),
        destAddress:
            useProviderData ? providerData.address : destLocation.destAddress,
        destPinCode: useProviderData ? "" : destLocation.destPostalCode,
        // need to ask raji for pincode in notification itself.
        distance: distanceValue,
        duration: durationValue);
    Webservice()
        .postAPICall(
            WebConstants.ACTION_UPDATE_CURRENT_LOCATION, updateLocationRequest)
        .then((updateLocationResponseValue) {
      updateLocationResponse =
          UpdateLocationResponse.fromJson(updateLocationResponseValue);
      if (updateLocationResponse.status == WebConstants.STATUS_VALUE_SUCCESS) {
        print("BG Location updated successfully");
      } else {
        NotificationUtils().showNotificationWithTitleBody(
            1003,
            MessageConstants.APP_NAME,
            MessageConstants.MESSAGE_WEBSERVICE_EXCEPTION,
            false);
      }
    });
  }

  Future<String> checkDestinationReached(
      double sourceLat, double sourceLong, ProviderData providerData) async {
    double destLatitude = double.parse(providerData.sourcelat);
    double destLongitude = double.parse(providerData.sourcelong);

    var distanceInMeter =
        Geolocator.distanceBetween(sourceLat, sourceLong, destLatitude, destLongitude);

    if (distanceInMeter > 100.toDouble() && distanceInMeter < 1000.toDouble()) {
      if (distanceInMeter < updatedTempValueSpotAccepted) {
        updatedTempValueSpotAccepted = updatedTempValueSpotAccepted - 250;
        return "1";
      }
    } else if (distanceInMeter > 30.toDouble() &&
        distanceInMeter < 100.toDouble()) {
      if (distanceInMeter < updatedTempValueSpotAccepted) {
        updatedTempValueSpotAccepted = updatedTempValueSpotAccepted - 30;
        return "1";
      }
    } else if (distanceInMeter > 1.toDouble() &&
        distanceInMeter < 30.toDouble()) {
      print(
          "################### SpotAccepted $distanceInMeter #######################");
      return "2";
    }
    return "";
  }

  Future<DestTimeAndDistance> processTravelTimeAndDistance(double sourceLat,
      double sourceLong, double destLat, double destLong) async {
    DestTimeAndDistance destTimeAndDistance;

    var actionTimeAndDistance = WebConstants.ACTION_TRAVEL_TIME_AND_DISTANCE +
        WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_1_ORIGIN +
        "$sourceLat,$sourceLong" +
        WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_2_DEST +
        "$destLat,$destLong" +
        WebConstants.PARAM_TRAVEL_TIME_AND_DISTANCE_3_MODE +
        WebConstants.DISTANCE_MODE_DRIVING;
    await Webservice()
        .postAPICallOnlyAction(actionTimeAndDistance)
        .then((timeAndDistanceResponseValue) {
      timeAndDistanceResponse =
          TimeAndDistanceResponse.fromJson(timeAndDistanceResponseValue);
      if (timeAndDistanceResponse.status ==
          WebConstants.STATUS_VALUE_DISTANCE_OK) {
        print(
            "Google Time value ${timeAndDistanceResponse.rows[0].elements[0].duration.text}  \n Distance value ${timeAndDistanceResponse.rows[0].elements[0].distance.text}");
        destTimeAndDistance = DestTimeAndDistance(
            distance: timeAndDistanceResponse.rows[0].elements[0].distance.text,
            duration:
                timeAndDistanceResponse.rows[0].elements[0].duration.text);
      } else {
        NotificationUtils().showNotificationWithTitleBody(
            1004,
            MessageConstants.APP_NAME,
            MessageConstants.MESSAGE_WEBSERVICE_EXCEPTION,
            false);
      }
    });
    return destTimeAndDistance;
  }
}
