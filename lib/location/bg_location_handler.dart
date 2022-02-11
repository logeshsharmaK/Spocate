import 'package:background_locator/location_dto.dart';
import 'package:spocate/location/bg_location_updates.dart';

class BGLocationHandler {
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    BGLocationUpdates bgLocationUpdates = BGLocationUpdates();
    await bgLocationUpdates.init(params);
  }

  static Future<void> callback(LocationDto locationDto) async {
    BGLocationUpdates bgLocationUpdates = BGLocationUpdates();
    await bgLocationUpdates.callback(locationDto);
  }

  static Future<void> notificationCallback() async {
    BGLocationUpdates bgLocationUpdates = BGLocationUpdates();
    await bgLocationUpdates.notificationCallback();
  }

  static Future<void> disposeCallback() async {
    BGLocationUpdates bgLocationUpdates = BGLocationUpdates();
    await bgLocationUpdates.dispose();
  }
}
