import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:flutter/material.dart';

import 'bg_location_handler.dart';
import 'bg_location_updates.dart';

class BGServiceHandler {
  // Singleton approach
  static final BGServiceHandler _instance = BGServiceHandler._internal();

  factory BGServiceHandler() => _instance;

  BGServiceHandler._internal();

  ReceivePort port;

  void initializePortListener() {
    port = ReceivePort();
    if (IsolateNameServer.lookupPortByName(BGLocationUpdates.isolateName) !=
        null) {
      IsolateNameServer.removePortNameMapping(BGLocationUpdates.isolateName);
    }

    IsolateNameServer.registerPortWithName(
        port.sendPort, BGLocationUpdates.isolateName);

    port.listen(
      (dynamic data) async {},
    );

    initializeBackgroundService();
  }

  Future<void> initializeBackgroundService() async {
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print('_startBackgroundService ${_isRunning.toString()}');
    if (!_isRunning) {
      print('Initializing...');
      await BackgroundLocator.initialize();
      print('Initialization done');
      startBackgroundService();
    }
  }

  void startBackgroundService() {
    Map<String, dynamic> data = {'countInit': 1};
    BackgroundLocator.registerLocationUpdate(BGLocationHandler.callback,
        initCallback: BGLocationHandler.initCallback,
        initDataCallback: data,
        disposeCallback: BGLocationHandler.disposeCallback,
        iosSettings: IOSSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            distanceFilter: 0,
            showsBackgroundLocationIndicator: true),
        autoStop: false,
        androidSettings: AndroidSettings(
            accuracy: LocationAccuracy.NAVIGATION,
            interval: 30,
            distanceFilter: 0,
            client: LocationClient.google,
            androidNotificationSettings: AndroidNotificationSettings(
                notificationChannelName: 'Location tracking',
                notificationTitle: 'Start Location Tracking',
                notificationMsg: 'Track location in background',
                notificationBigMsg:
                    'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
                notificationIconColor: Colors.grey,
                notificationTapCallback:
                    BGLocationHandler.notificationCallback)));
  }

  void stopBackgroundService() async {
    final _isRunning = await BackgroundLocator.isServiceRunning();
    print('onStop ${_isRunning.toString()}');
    if(_isRunning){
      BackgroundLocator.unRegisterLocationUpdate();
      if(port != null){
        port.close();
        port = ReceivePort();
      }
    }
  }
}
