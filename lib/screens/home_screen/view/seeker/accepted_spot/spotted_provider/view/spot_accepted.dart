import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/location/bg_service_handler.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/bloc/spotted_provider_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/source_and_dest.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/bloc/seeker_cancel_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/bloc/seeker_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/bloc/seeker_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_cancel/repo/seeker_cancel_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/bloc/seeker_cancel_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/bloc/seeker_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/bloc/seeker_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/seeker_extra_time/repo/seeker_extra_time_request.dart';
import 'package:spocate/utils/app_utils.dart';
import 'package:spocate/utils/location_utils/location_utils.dart';
import 'package:spocate/utils/network_utils.dart';
import 'package:spocate/utils/notification_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SpotAccepted extends StatefulWidget {
  const SpotAccepted({Key key}) : super(key: key);

  @override
  _SpotAcceptedState createState() => _SpotAcceptedState();
}

class _SpotAcceptedState extends State<SpotAccepted>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  SpottedProviderBloc _spottedProviderBloc;
  SeekerCancelBloc _seekerCancelBloc;
  SeekerExtraTimeBloc _seekerExtraTimeBloc;
  ProviderData providerData;

  GoogleMapController _googleMapController;
  CameraPosition _cameraPositionOnMap;

  Set<Marker> _markerPins = {};
  Set<Polyline> _polyLines = {};
  List<LatLng> polylineCoordinates = [];

  // bool isDestReachedShown = false;
  String userId;

  CarInfoAnimState carInfoAnimState;
  AnimationController controller;
  Animation<Offset> offset;

  String providerCarNumber;
  String providerCarColor;
  String providerCarModel;
  String providerCarMake;
  String providerAddress;
  String providerDistance = "";
  String providerDuration = "";

  // StreamSubscription positionStream;

  double sourceLatitude;
  double sourceLongitude;
  String sourceAddress;
  String sourcePinCode;
  double destLatitude;
  double destLongitude;
  String destAddress;
  String destPinCode;
  bool isVeryFirstTimeAndDistanceUpdate = false;

  // App State handling variables
  String initScreenState = "0";
  String resumeScreenState = "0";
  String spScreenState = "0";

  bool isLocationExecutedOnce = false;

  FirebaseMessaging _firebaseMessaging;
  bool isProviderDetailsToShow = true;

  Timer timerToRefreshSeekerLocation;
  Timer startBufferTimer;
  Timer bufferTimer;
  Timer graceTimer;
  Timer graceTimerListener;

  bool isActionInExtendedTime = false;
  int bufferCount = 0;
  bool isExtendedTimeAlertShown = false;

  bool ignoreExtendedAlert = false;

  int graceTime = 3;

  int graceCount = 0;

  @override
  void initState() {
    print("initState Spot Accepted");
    WidgetsBinding.instance.addObserver(this);
    _initializeAndProcessNotification();
    _initializeProviderDetailsToShow();
    SharedPrefs().setLastVisitedScreen(AppBarConstants.APP_BAR_ROUTE_TO_SPOT);
    SharedPrefs().setBackgroundLocationScreen("2");
    final SpottedProviderRepository repository = SpottedProviderRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());
    _spottedProviderBloc = SpottedProviderBloc(repository: repository);

    final SeekerCancelRepository seekerCancelRepository =
        SeekerCancelRepository(
            webservice: Webservice(), sharedPrefs: SharedPrefs());
    _seekerCancelBloc = SeekerCancelBloc(repository: seekerCancelRepository);

    final SeekerExtraTimeRepository seekerExtraTimeRepository =
        SeekerExtraTimeRepository(
            webservice: Webservice(), sharedPrefs: SharedPrefs());
    _seekerExtraTimeBloc =
        SeekerExtraTimeBloc(repository: seekerExtraTimeRepository);

    // Initial Camera Position
    _cameraPositionOnMap =
        CameraPosition(target: LatLng(40.740156, -73.997701), zoom: 18.0);

    _initializeAppState();
    _initializeCarViewShowHideAnimation();
    _listener();

    super.initState();
  }

  _initializeAppState() {
    initScreenState = "1";
    _getSpScreenState();
  }

  _getSpScreenState() {
    SharedPrefs().getSpState().then((spState) {
      print("getSpState spState $spState");
      spScreenState = spState;
      getAppState();
    });
  }

  getAppState() {
    print("App State spScreenState $spScreenState");
    print("App State initScreenState $initScreenState");
    print("App State resumeScreenState $resumeScreenState");

    if (spScreenState == "0" &&
        initScreenState == "1" &&
        resumeScreenState == "0") {
      print("App State Spot Accepted Screen - Foreground Access");

      _foregroundAppStateHandling();
      return "Foreground";
    } else if (spScreenState == "0" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      _backgroundAppStateNotificationHandling();
      SharedPrefs().setSpState("0");
      print("App State Spot Accepted Screen - Background Access");
      return "Background";
    } else if (spScreenState == "1" &&
        initScreenState == "1" &&
        resumeScreenState == "0") {
      print("App State Spot Accepted Screen - Terminated Access");

      _terminatedAppStateHandling();
      SharedPrefs().setSpState("0");
      return "Terminated";
    } else if (spScreenState == "1" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      print(
          "App State Spot Accepted Screen - Background and Notification Clicked");
      _backgroundAppStateNotificationHandling();
      SharedPrefs().setSpState("0");
      return "Background-Notification-Click";
    }
  }

  _foregroundAppStateHandling() async {
    await _getCurrentLocation();
  }

  _backgroundAppStateNotificationHandling() {
    print("_backgroundAppStateNotificationHandling Spot Accepted ");
    SharedPrefs().getNotificationCode().then((notificationCode) {
      if (notificationCode ==
              MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED ||
          notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP ||
          notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME) {
        timerToRefreshSeekerLocation.cancel();
      }

      if (notificationCode ==
          MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED) {
        if (bufferCount < 30) {
          if (isExtendedTimeAlertShown) {
            Navigator.of(context, rootNavigator: true).pop();
            NotificationUtils().cancelNotificationById(1002);
          }
          if (bufferTimer != null && bufferTimer.isActive) {
            bufferTimer.cancel();
          }
          if (startBufferTimer != null && startBufferTimer.isActive) {
            startBufferTimer.cancel();
          }
        }
      }
      if (spScreenState == "1") {
        SharedPrefs().getNotificationMessage().then((message) {
          _showAlert(message, notificationCode);
        });
      }
    });
  }

  _terminatedAppStateHandling() async {
    SharedPrefs().getNotificationCode().then((notificationCode) async {
      if (notificationCode ==
              MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED ||
          notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP ||
          notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME) {
        timerToRefreshSeekerLocation.cancel();
      }

      if (notificationCode ==
          MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED) {
        if (bufferCount < 30) {
          if (isExtendedTimeAlertShown) {
            Navigator.of(context, rootNavigator: true).pop();
            NotificationUtils().cancelNotificationById(1002);
          }
          if (bufferTimer != null && bufferTimer.isActive) {
            bufferTimer.cancel();
          }
          if (startBufferTimer != null && startBufferTimer.isActive) {
            startBufferTimer.cancel();
          }
        }
      }
      await _getCurrentLocation(notificationCode: notificationCode);
      SharedPrefs().getNotificationMessage().then((message) {
        if (spScreenState == "1") {
          SharedPrefs().getNotificationMessage().then((message) {
            _showAlert(message, notificationCode);
          });
        }
      });
    });
  }

  _initializeAndProcessNotification() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print("onMessage data Spot Accepted ${remoteMessage.data}");
      if (remoteMessage.data['Notificationcode'] ==
          MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME) {
        String providerMessage = remoteMessage.data['message'];
        String providerNotificationCode =
            remoteMessage.data['Notificationcode'];
        String providerUserType = remoteMessage.data['UserType'];
        SharedPrefs().setNotificationCode(providerNotificationCode);
        SharedPrefs().setNotificationMessage(providerMessage);
        SharedPrefs().setNotificationUserType(providerUserType);
        _showAlert(providerMessage, providerNotificationCode);
      } else {
        var providerCancelledTrip =
            SpotLocatedNotification.fromJson(remoteMessage).data;
        SharedPrefs().setSpotAcceptedProviderData(providerCancelledTrip);
        _showAlert(providerCancelledTrip.message,
            providerCancelledTrip.notificationCode);
      }
    });
  }

  _showAlert(String message, String notificationCode) {
    if (mounted) {
      if (notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP ||
          notificationCode ==
              MessageConstants
                  .SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME) {
        // timerToRefreshSeekerLocation.cancel();
        if (timerToRefreshSeekerLocation != null &&
            timerToRefreshSeekerLocation.isActive) {
          timerToRefreshSeekerLocation.cancel();
        }
        if (bufferTimer != null && bufferTimer.isActive) {
          bufferTimer.cancel();
        }
        if (startBufferTimer != null && startBufferTimer.isActive) {
          startBufferTimer.cancel();
        }

        if (graceTimerListener != null && graceTimerListener.isActive) {
          graceTimerListener.cancel();
        }
        if (graceTimer != null && graceTimer.isActive) {
          graceTimer.cancel();
        }
        setState(() {
          isProviderDetailsToShow = false;
          SharedPrefs().setIsProviderDetailsToShow(isProviderDetailsToShow);
        });
        AppWidgets.showCustomDialogOK(context, message).then((value) {
          // if(value == DialogAction.OK){
          SharedPrefs().setIsProviderDetailsToShow(true);
          SharedPrefs().getSourceLocationDetails().then((sourceDetails) async {
            await SharedPrefs().getDestLocationDetails().then((destDetails) {
              print(
                  "spot Accepted sourceLatitude  = ${sourceDetails.sourceLatitude}");
              print(
                  "spot Accepted sourceLongitude = ${sourceDetails.sourceLongitude}");
              print(
                  "spot Accepted destLatitude    = ${destDetails.destLatitude}");
              print(
                  "spot Accepted destLongitude   = ${destDetails.destLongitude}");
              if (mounted) {
                Navigator.pushNamed(
                    context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION,
                    arguments: SourceAndDest(
                        sourceLocation: sourceDetails,
                        destLocation: destDetails));
              }
            });
          });
          // }
        });
      } else if (notificationCode ==
          MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED) {
        print("notificationCode = $notificationCode");
        print("message =  $message");
        // isDestReachedShown = true;
        BGServiceHandler().stopBackgroundService();
        AppWidgets.showCustomDialogYesNo(context,
                MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED)
            .then((value) {
          if (value == DialogAction.Yes) {
            print("Yes Clicked");
            _submitSpottedProvider("1");
            // isDestReachedShown = true;
          } else if (value == DialogAction.No) {
            print("NO  Clicked");
            _submitSpottedProvider("0");
            // isDestReachedShown = true;
          }
        });
      } else if (notificationCode ==
          MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME) {
        // _startGraceTime();
        AppWidgets.showCustomDialogOK(context, message).then((value) {});
      } else if (notificationCode ==
          MessageConstants.SEEKER_NOTIFICATION_6_EXTENDED_TIME) {
        AppWidgets.showCustomDialogYesNo(context, message).then((value) {
          if (value == DialogAction.Yes) {
            print("Yes Clicked");
            _submitSeekerExtraTime();
            _startGraceTime();
            bufferTimer.cancel();
            isActionInExtendedTime = true;
            isExtendedTimeAlertShown = false;
          } else if (value == DialogAction.No) {
            print("NO  Clicked");
            _submitSeekerCancelled(0);
            isExtendedTimeAlertShown = false;
          } else if (value == DialogAction.Cancel) {
            isExtendedTimeAlertShown = false;
          }
        });
      }
    }
  }

  _initializeProviderDetailsToShow() {
    SharedPrefs().getIsProviderDetailsToShow().then((value) {
      setState(() {
        isProviderDetailsToShow = value;
      });
    });
  }

  _initializeCarViewShowHideAnimation() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);

    controller.forward().then((value) {
      setState(() {
        carInfoAnimState = CarInfoAnimState.forward;
      });
    });
  }

  Future<void> _getUserIdDetails() async {
    SharedPrefs().getUserId().then((userIdValue) {
      setState(() {
        print("spot accepted  foreground User Id 1 : $userIdValue ");
        userId = userIdValue;
      });
    });
  }

  Future<void> _getProviderData() async {
    SharedPrefs().getSpotAcceptedProviderData().then((providerDataValue) {
      setState(() {
        providerData = providerDataValue;
        // Frequent location update to find reached destination
        providerCarNumber = providerData.carNumber;
        providerCarColor = providerData.carColor;
        providerCarModel = providerData.carModel;
        providerCarMake = providerData.carMake;
        providerAddress = providerData.address;
        providerDistance = providerData.distance;
        providerDuration = providerData.drivingMinutes;

        destLatitude = double.parse(providerData.sourcelat);
        destLongitude = double.parse(providerData.sourcelong);
      });
    });
  }

  _launchNavigationMap(double destLatitude, double destLongitude) {
    if (AppUtils.getPlatform() == WordConstants.PLATFORM_ANDROID) {
      var androidGoogleMapURI =
          Uri.parse("google.navigation:q=$destLatitude,$destLongitude&mode=d");
      _launchAndroidPlatformURL(androidGoogleMapURI.toString());
    } else if (AppUtils.getPlatform() == WordConstants.PLATFORM_IOS) {
      // apple native map
      var iosURI = Uri.parse(
          "http://maps.apple.com/maps?daddr=$destLatitude,$destLongitude&dirflg=d");
      _launchIosPlatformUrl(iosURI.toString(), destLatitude, destLongitude);
    }
  }

  void _launchAndroidPlatformURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchIosPlatformUrl(
      String url, double destLatitude, double destLongitude) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      var iOSGoogleMapURI = Uri.parse(
          "comgooglemaps://?saddr=&daddr=\($destLatitude),\($destLongitude)&directionsmode=driving");
      if (await canLaunch(iOSGoogleMapURI.toString())) {
        await launch(iOSGoogleMapURI.toString());
      }
    }
  }

  _updateLocationMarkerRoute() {
    // Locate source location in map
    _locateSourceLocationInMap();

    // Set source and dest markers
    _setMarkerPins(providerData);

    // Extract poly line points between source and dest
    // Set the poly lines in map
    _getLocationPointsBetweenSourceAndDest(providerData);
  }

  _locateSourceLocationInMap() {
    // Updated Camera Position
    /* initially the  sourceLatitude and sourceLongitude is null
    *  without handling null condition the camera position will return exception
    * */
    print("TEST2 sourceLatitude $sourceLatitude ");
    print("TEST2 sourceLongitude $sourceLongitude ");
    if (sourceLatitude != null && sourceLongitude != null) {
      _cameraPositionOnMap = CameraPosition(
          target: LatLng(sourceLatitude, sourceLongitude), zoom: 18.0);
      _googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(_cameraPositionOnMap));
    }
  }

  _setMarkerPins(ProviderData providerData) {
    print("TEST3 sourceLatitude $sourceLatitude ");
    print("TEST3 sourceLongitude $sourceLongitude ");
    print("_setMarkerPins DestinationLatitude ${providerData.sourcelat}");
    print("_setMarkerPins DestinationLongitude ${providerData.sourcelong}");

    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(sourceLatitude, sourceLongitude),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
    // destination pin
    _markerPins.add(Marker(
        markerId: MarkerId('dest_marker'),
        position: LatLng(double.parse(providerData.sourcelat),
            double.parse(providerData.sourcelong)),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
  }

  _getLocationPointsBetweenSourceAndDest(ProviderData providerData) async {
    print("sourceLatitude $sourceLatitude");
    print("sourceLongitude $sourceLongitude");
    print("providerData sourceLatitude = ${providerData.sourcelat}");
    print("providerData sourceLatitude = ${providerData.sourcelong}");
    await PolylinePoints()
        .getRouteBetweenCoordinates(
      WordConstants.GOOGLE_PLACES_API_KEY, // Google Maps API Key
      PointLatLng(sourceLatitude, sourceLongitude),
      PointLatLng(double.parse(providerData.sourcelat),
          double.parse(providerData.sourcelong)),
      travelMode: TravelMode.driving,
    )
        .then((polyLineResult) {
      if (polyLineResult.points.isNotEmpty) {
        polyLineResult.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    });

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Colors.black87,
          points: polylineCoordinates,
          geodesic: true,
          width: 4);
      _polyLines.add(polyline);
    });
  }

  Future<void> _getCurrentLocation({String notificationCode}) async {
    Geolocator.isLocationServiceEnabled().then((isLocationEnabled) async {
      if (isLocationEnabled) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation)
            .then((currentPosition) {
          setState(() {
            sourceLatitude = currentPosition.latitude;
            sourceLongitude = currentPosition.longitude;
            print("TEST sourceLatitude $sourceLatitude ");
            print("TEST sourceLongitude $sourceLongitude ");
          });
          _getUserIdDetails().then((userIdValue) {
            // userId = userIdValue;
            _getProviderData().then((providerDataValue) {
              _updateLocationMarkerRoute();
              print("spot accepted  foreground User Id  2 : $userId ");
              if (notificationCode == null ||
                  notificationCode ==
                      MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED ||
                  notificationCode ==
                      MessageConstants
                          .SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME) {
                _submitOneTimeAddressAndTimeAndDistance();
              }
            });
          });
        });
      }
    });
  }

  Future<void> _submitOneTimeAddressAndTimeAndDistance() async {
    if (mounted) {
      print(
          "isVeryFirstTimeAndDistanceUpdate = $isVeryFirstTimeAndDistanceUpdate ");
      if (!isVeryFirstTimeAndDistanceUpdate) {
        /*
        * We are accessing the Util methods but without UserId allocation
        * the submit will be empty customer id, so calling UserId here
        * once to allocate the user Id in Util class methods
        *
        * */
        LocationUtils().getSharedPrefUserId().then((tempUserId) {
          LocationUtils()
              .getAddressFromLocation(sourceLatitude, sourceLongitude)
              .then((locationAddress) {
            print("FG Dest locationAddress ${locationAddress.toString()}");
            LocationUtils()
                .processTravelTimeAndDistance(
                    sourceLatitude,
                    sourceLongitude,
                    double.parse(providerData.sourcelat),
                    double.parse(providerData.sourcelong))
                .then((destTimeAndDistance) {
              setState(() {
                providerDistance = destTimeAndDistance.distance;
                providerDuration = destTimeAndDistance.duration;
              });
              print(
                  "FG Dest duration ${destTimeAndDistance.duration} distance ${destTimeAndDistance.distance} ");
              print(
                  "FG Dest duration after split ${destTimeAndDistance.duration.split(" ")[0]}");

              _startExtendedTime(destTimeAndDistance.duration.split(" ")[0]);

              // Future.delayed(
              //     Duration(
              //         minutes: int.parse(
              //             destTimeAndDistance.duration.split(" ")[0])),
              //     () async {
              //
              //      // dismiss the alert by below code
              //      //  Navigator.of(context, rootNavigator: true).pop();
              //
              //       // test that the notification is show background or not.
              //
              //   print("Have you spotted the provider notification is cancelled******");
              //   /* - Below are the points need to develop -
              // * 1.we need to check the notification before cancelling whether it is clicked or not.
              // * 2.in foreground we will not receive notification. how to handle that case.
              // * 3.need to handle (hide) the alert after cancelling the notification. - *update shared pref value to handle this point
              // * 4.need to call the cancel webservices.
              // */
              //   await AwesomeNotifications().cancel(1001);
              // });
              LocationUtils()
                  .submitUpdateLocation(sourceLatitude, sourceLongitude,
                      locationAddress.address, locationAddress.postalCode,
                      distanceValue: destTimeAndDistance.distance,
                      durationValue: destTimeAndDistance.duration,
                      providerData: providerData,
                      useProviderData: true)
                  .then((emptyValue) {
                print("FG Dest Location submitted successfully from UI ");
                isVeryFirstTimeAndDistanceUpdate = true;
                print(
                    "FG Dest Location submitted successfully isVeryFirstTimeAndDistanceUpdate = $isVeryFirstTimeAndDistanceUpdate ");

                // _launchNavigationMap(destLatitude, destLongitude);
                isLocationExecutedOnce = true;
              });
            });
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _executePopClick,
      child: Scaffold(
        appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_ROUTE_TO_SPOT),
        body: MultiBlocListener(
          child: _buildSpotAcceptedView(context),
          listeners: [
            BlocListener<SpottedProviderBloc, SpottedProviderState>(
                cubit: _spottedProviderBloc,
                listener: (context, state) {
                  _blocSpottedProviderListener(context, state);
                }),
            BlocListener<SeekerCancelBloc, SeekerCancelState>(
                cubit: _seekerCancelBloc,
                listener: (context, state) {
                  _blocSeekerCancelledListener(context, state);
                }),
            BlocListener<SeekerExtraTimeBloc, SeekerExtraTimeState>(
                cubit: _seekerExtraTimeBloc,
                listener: (context, state) {
                  _blocSeekerExtraTimeListener(context, state);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildSpotAcceptedView(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          padding: EdgeInsets.all(16.0),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          markers: _markerPins,
          polylines: _polyLines,
          mapType: MapType.normal,
          initialCameraPosition: _cameraPositionOnMap,
          onMapCreated: (GoogleMapController mapController) {
            _googleMapController = mapController;
            // _updateLocationMarkerRoute();
          },
        ),
        Positioned(
          child: _buildAddressAndCarView(context),
          top: 0,
          left: 0,
          right: 0,
        ),
        Positioned(
          child: ElevatedButton(
            child: Text(
              "Navigate",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
            ),
            onPressed: () {
              _launchNavigationMap(destLatitude, destLongitude);
            },
          ),
          left: 80,
          right: 80,
          bottom: 20.0,
        ),
      ],
    );
  }

  Widget _buildAddressAndCarView(BuildContext context) {
    return Visibility(
        visible: isProviderDetailsToShow,
        child: Stack(
          children: [
            SlideTransition(position: offset, child: _buildCarView(context)),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(00)),
                  color: Colors.blue,
                  border: Border.all(color: Colors.white, width: 0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Stack(children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 16.0, top: 16.0),
                                      child: Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.white,
                                        size: 30.0,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8.0, top: 16.0),
                                        child: InkWell(
                                          splashColor: Colors.blue,
                                          // splash color
                                          onTap: () {
                                            switch (controller.status) {
                                              case AnimationStatus.completed:
                                                {
                                                  controller
                                                      .reverse()
                                                      .then((value) {
                                                    setState(() {
                                                      carInfoAnimState =
                                                          CarInfoAnimState
                                                              .reverse;
                                                    });
                                                  });
                                                }
                                                break;
                                              case AnimationStatus.dismissed:
                                                {
                                                  controller
                                                      .forward()
                                                      .then((value) {
                                                    setState(() {
                                                      carInfoAnimState =
                                                          CarInfoAnimState
                                                              .forward;
                                                    });
                                                  });
                                                }
                                                break;
                                              default:
                                            }
                                          },
                                          // button pressed
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                carInfoAnimState ==
                                                        CarInfoAnimState.forward
                                                    ? Icons
                                                        .keyboard_arrow_up_sharp
                                                    : Icons
                                                        .keyboard_arrow_down_sharp,
                                                color: Colors.white,
                                                size: 40.0,
                                              ), // icon
                                            ],
                                          ),
                                        )),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 1,
                                    color: Colors.white70,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            '${providerAddress ?? ""}',
                                            //'11 4th Cross Street, Village High Road, Sholinganallur, Chennai, Tamilnadu',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                            maxLines: 2,
                                          ),
                                        ),
                                        SizedBox(height: 12),
                                        Divider(
                                          height: 1,
                                          thickness: 1,
                                          color: Colors.white70,
                                        ),
                                        IntrinsicHeight(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${providerDuration ?? ""}',
                                                      //'30 Mins',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                              VerticalDivider(
                                                thickness: 1,
                                                width: 1,
                                                color: Colors.white70,
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      '${providerDistance ?? ""}',
                                                      //'500 Mts',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontFamily: 'Roboto',
                                                          fontSize: 24.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildCarView(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(00)),
            color: Colors.blue,
            border: Border.all(color: Colors.white, width: 0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 16.0),
                          child: Icon(
                            Icons.directions_car_sharp,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: VerticalDivider(
                            thickness: 1,
                            width: 1,
                            color: Colors.white70,
                          ),
                        ),
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 12),
                              Text('${providerCarMake ?? ""}',
                                  // Benz Car Make',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              SizedBox(height: 12),
                              Text('${providerCarModel ?? ""}',
                                  // Benz Car Model ',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              SizedBox(height: 12),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.white70,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${providerCarNumber ?? ""}",
                                          //TN12BB1234",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    VerticalDivider(
                                      thickness: 1,
                                      width: 1,
                                      color: Colors.white70,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${providerCarColor ?? ""}", //BLUE",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18.0,
                                              color: Colors.white),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future<void> _submitSpottedProvider(String isSpotted) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var spottedProviderRequest = SpottedProviderRequest(
            userId: userId,
            unParkUserId: providerData.userId.toString(),
            isSpotted: isSpotted);
        _spottedProviderBloc.add(SpottedProviderClickEvent(
            spottedProviderRequest: spottedProviderRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitSeekerCancelled(int isForceCancelled) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var seekerCancelRequest = SeekerCancelRequest(userId: userId);
        _seekerCancelBloc.add(
            SeekerCancelClickEvent(seekerCancelRequest: seekerCancelRequest, isSeekerForceCancelled: isForceCancelled));
        print("_submitSeekerCancelled added");
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitSeekerExtraTime() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        print(
            "_submitSeekerExtraTime providerId = ${providerData.userId.toString()}");

        var seekerExtraTimeRequest =
            SeekerExtraTimeRequest(providerId: providerData.userId.toString());
        _seekerExtraTimeBloc.add(SeekerExtraTimeClickEvent(
            seekerExtraTimeRequest: seekerExtraTimeRequest));
        print("_submitSeekerExtraTime Request Submitted");
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocSpottedProviderListener(
      BuildContext context, SpottedProviderState state) {
    if (state is SpottedProviderEmpty) {}
    if (state is SpottedProviderLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is SpottedProviderError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is SpottedProviderSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "Spotted Provider Success ${state.spottedProviderResponse.message}");
      if (timerToRefreshSeekerLocation != null &&
          timerToRefreshSeekerLocation.isActive) {
        timerToRefreshSeekerLocation.cancel();
      }
      if (state.isSpotted == "1") {
        Navigator.pushNamedAndRemoveUntil(
            context,
            RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION,
            (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConstants.ROUTE_QUESTIONS_LIST, (route) => false);
      }
    }
  }

  Future<bool> _executePopClick() {
    AppWidgets.showCustomDialogYesNo(
            context, "Do you want to cancel this trip?")
        .then((value) async {
      if (value == DialogAction.Yes) {
        print("_executePopClick clicked");
        _submitSeekerCancelled(0);
      } else if (value == DialogAction.No) {
        // Navigator.pop(context, false);
      }
    });
  }

  _blocSeekerCancelledListener(BuildContext context, SeekerCancelState state) {
    if (state is SeekerCancelEmpty) {}
    if (state is SeekerCancelLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is SeekerCancelError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is SeekerCancelSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "seekerCancelResponse Success ${state.seekerCancelResponse.message}");
      if (timerToRefreshSeekerLocation != null &&
          timerToRefreshSeekerLocation.isActive) {
        timerToRefreshSeekerLocation.cancel();
      }
      if (bufferTimer != null && bufferTimer.isActive) {
        bufferTimer.cancel();
      }
      if (startBufferTimer != null && startBufferTimer.isActive) {
        startBufferTimer.cancel();
      }

      if (graceTimerListener != null && graceTimerListener.isActive) {
        graceTimerListener.cancel();
      }
      if (graceTimer != null && graceTimer.isActive) {
        graceTimer.cancel();
      }
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    }
  }

  _blocSeekerExtraTimeListener(
      BuildContext context, SeekerExtraTimeState state) {
    if (state is SeekerExtraTimeEmpty) {}
    if (state is SeekerExtraTimeLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is SeekerExtraTimeError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is SeekerExtraTimeSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "SeekerExtraTimeResponse Success ${state.seekerExtraTimeResponse.message}");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("AppLifecycleState resumed ");
      resumeScreenState = "1";
      _getSpScreenState();
      _listener();
      // positionStream.resume();
    } else if (state == AppLifecycleState.paused) {
      print("AppLifecycleState paused ");
      timerToRefreshSeekerLocation.cancel();
      // positionStream.pause();
    }
  }

  @override
  void dispose() {
    // if (positionStream != null) {
    //   positionStream.cancel();
    // }
    if (timerToRefreshSeekerLocation != null &&
        timerToRefreshSeekerLocation.isActive) {
      timerToRefreshSeekerLocation.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _listener() {
    timerToRefreshSeekerLocation =
        Timer.periodic(Duration(seconds: 1), (Timer t) {
      SharedPrefs().getNotificationCode().then((notificationCode) {
        if (notificationCode ==
                MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED ||
            notificationCode ==
                MessageConstants
                    .SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP) {
          if (timerToRefreshSeekerLocation != null &&
              timerToRefreshSeekerLocation.isActive) {
            timerToRefreshSeekerLocation.cancel();
          }
          if (notificationCode ==
              MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED) {
            if (bufferCount < 30) {
              if (isExtendedTimeAlertShown) {
                Navigator.of(context, rootNavigator: true).pop();
                NotificationUtils().cancelNotificationById(1002);
              }
              if (bufferTimer != null && bufferTimer.isActive) {
                bufferTimer.cancel();
              }
              if (startBufferTimer != null && startBufferTimer.isActive) {
                startBufferTimer.cancel();
              }
            }
          }
          SharedPrefs().getNotificationMessage().then((message) {
            _showAlert(message, notificationCode);
          });
        }
      });
    });
  }

  _startExtendedTime(String seekerDuration) {
    startBufferTimer = Timer(Duration(minutes: int.parse(seekerDuration)), () {

      SharedPrefs().getNotificationCode().then((notificationCode) {
        if (notificationCode ==
            MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED
        || notificationCode ==
            MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP
        || notificationCode ==
                MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME ) {
          startBufferTimer.cancel();
        } else {
          _showAlert(MessageConstants.MESSAGE_SEEKER_NOTIFICATION_EXTENDED_TIME,
              MessageConstants.SEEKER_NOTIFICATION_6_EXTENDED_TIME);
          isExtendedTimeAlertShown = true;
          // SharedPrefs().setNotificationCode(MessageConstants.SEEKER_NOTIFICATION_6_EXTENDED_TIME);
          // SharedPrefs().setNotificationMessage(MessageConstants.MESSAGE_SEEKER_NOTIFICATION_EXTENDED_TIME);
          // SharedPrefs().setNotificationUserType(MessageConstants.SEEKER_NOTIFICATION_USER_TYPE);

          NotificationUtils().showNotificationWithTitleBody(
              1002,
              MessageConstants.APP_NAME,
              MessageConstants.MESSAGE_SEEKER_NOTIFICATION_EXTENDED_TIME,
              true);
          _listenExtendedTime();
        }
      });
    });
  }

  _listenExtendedTime() {
    bufferTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      print("Timer is printing........................ before inc $bufferCount");
      bufferCount++;
      SharedPrefs().getNotificationCode().then((notificationCode) {
        if (notificationCode ==
            MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED
        || notificationCode ==
        MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP
        || notificationCode ==
        MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME  ) {
          if (bufferTimer != null && bufferTimer.isActive) {
            bufferTimer.cancel();
          }
        } else if (bufferCount > 30) {
          if (!isActionInExtendedTime) {
            BGServiceHandler().stopBackgroundService();
            // force cancelling the trip when no response to the buffer time alert
            _submitSeekerCancelled(1);
          }
        }
      });
    });
  }

  _startGraceTime(){
    graceTimerListener = Timer.periodic(Duration(seconds: 1), (Timer t) {
      print("Grace Timer Listener is printing........................");
      SharedPrefs().getNotificationCode().then((notificationCode) {
        if (notificationCode ==
            MessageConstants.SEEKER_NOTIFICATION_4_PROVIDER_ACCEPTED_EXTRA_TIME) {
          graceTimerListener.cancel();
          graceTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
            print("Grace Timer is printing........................");
            graceCount++;
            SharedPrefs().getNotificationCode().then((notificationCode) {
              if (notificationCode ==
                  MessageConstants.SEEKER_NOTIFICATION_0_SPOT_REACHED
              || notificationCode ==
              MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME
              || notificationCode ==
              MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP) {
                if (graceTimer != null && graceTimer.isActive) {
                  graceTimer.cancel();
                }
              } else if(graceCount > 180 ) {
                // force cancelling the trip when seeker (user) didn't reached the spot(destination
                _submitSeekerCancelled(1);
                if (graceTimer != null && graceTimer.isActive) {
                  graceTimer.cancel();
                }
                if (timerToRefreshSeekerLocation != null &&
                    timerToRefreshSeekerLocation.isActive) {
                  timerToRefreshSeekerLocation.cancel();
                }
              }
            });
          });
        }
        else if(notificationCode ==
            MessageConstants.SEEKER_NOTIFICATION_5_PROVIDER_IGNORE_EXTRA_TIME
            || notificationCode ==
                MessageConstants.SEEKER_NOTIFICATION_3_PROVIDER_CANCELLED_THE_TRIP
        ){
          graceTimerListener.cancel();
        }
      });
    });
  }
}
