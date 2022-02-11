import 'dart:async';
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:spocate/core/constants/app_bar_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/num_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/core/widgets/app_widgets.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/data/remote/web_constants.dart';
import 'package:spocate/data/remote/web_service.dart';
import 'package:spocate/location/bg_service_handler.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/accept_spot/accept_spot_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/accept_spot/accept_spot_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/accept_spot/accept_spot_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/ignore_spot/ignore_spot_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/ignore_spot/ignore_spot_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/ignore_spot/ignore_spot_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/remove_seeker/remove_seeker_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/remove_seeker/remove_seeker_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/remove_seeker/remove_seeker_state.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/bloc/time_and_distance/time_and_distance_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/accept_spot/accept_spot_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/ignore_spot/ignore_spot_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/notification/spot_location_notification.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/remove_seeker/remove_seeker_request.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/route_to_dest_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/source_and_dest.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';
import 'package:spocate/utils/network_utils.dart';

class RouteToDestination extends StatefulWidget {
  final SourceAndDest sourceAndDest;

  const RouteToDestination({Key key, this.sourceAndDest}) : super(key: key);

  @override
  _RouteToDestinationState createState() =>
      _RouteToDestinationState(sourceAndDest);
}

class _RouteToDestinationState extends State<RouteToDestination>
    with WidgetsBindingObserver {
  // Constructor value passed from Search Destination screen
  // We are using constructor passed value only to show initial map point
  SourceAndDest sourceAndDest;

  _RouteToDestinationState(this.sourceAndDest);

  LocationPermissionLevel _backGroundPermissionLevel =
      LocationPermissionLevel.values[2];

  // Extracting source value from SourceAndDest
  SourceLocation sourceLocation;
  double sourceLatitude;
  double sourceLongitude;
  String sourceAddress;
  String sourcePinCode;
  String spotId;

  // Extracting dest value from SourceAndDest
  DestLocation destLocation;

  String userId;

  GoogleMapController _googleMapController;
  CameraPosition _cameraPositionOnMap;

  Set<Marker> _markerPins = {};
  Set<Polyline> _polyLines = {};
  List<LatLng> polylineCoordinates = [];

  FirebaseMessaging _firebaseMessaging;
  ProviderData _spotProviderData = ProviderData();

  AcceptSpotBloc _acceptSpotBloc;
  IgnoreSpotBloc _ignoreSpotBloc;
  TimeAndDistanceBloc _timeAndDistanceBloc;
  RemoveSeekerBloc _removeSeekerBloc;

  // Need to hide once spot located alert implemented in this screen
  bool isShowThanksView = false;

  String distanceBetweenDestAndSpot = "Loading...";

  void Function(void Function()) dialogState;

  StreamSubscription positionStream;

  bool showSorryMessage = false;

  String initScreenState = "0";
  String resumeScreenState = "0";
  String spScreenState = "0";

  bool isOpenedSettings = false;

  @override
  void initState() {
    print("initState RouteToDestination");
    super.initState();
    // Handling background location service for location updates
    SharedPrefs().setBackgroundLocationScreen("1");

    SharedPrefs()
        .setLastVisitedScreen(AppBarConstants.APP_BAR_ROUTE_TO_DESTINATION);
    WidgetsBinding.instance.addObserver(this);

    final RouteToDestRepository repository = RouteToDestRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());

    _acceptSpotBloc = AcceptSpotBloc(repository: repository);
    _ignoreSpotBloc = IgnoreSpotBloc(repository: repository);
    _timeAndDistanceBloc = TimeAndDistanceBloc(repository: repository);
    _removeSeekerBloc = RemoveSeekerBloc(repository: repository);

    // If the user navigating from previous screen then directly update the route and markers
    // // Initial Camera Position
    _cameraPositionOnMap =
        CameraPosition(target: LatLng(40.740156, -73.997701), zoom: 18.0);

    // if (sourceLocation == null || destLocation == null) {
    //   // There are chances this screen got terminated, So launching this screen should have source and dest values which is taken from shared prefs
    //   _getSourceAndDestDetails();
    // } else {
    //   // If the user navigating from previous screen then directly update the route and markers
    //   // // Initial Camera Position
    //   _cameraPositionOnMap = CameraPosition(
    //       target: LatLng(
    //           sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
    //       zoom: 18.0);
    //
    //   sourceLatitude = sourceLocation.sourceLatitude;
    //   sourceLongitude = sourceLocation.sourceLongitude;
    //   sourceAddress = sourceLocation.sourceAddress;
    //   sourcePinCode = sourceLocation.sourcePostalCode;
    // }

    // _getUserDetail();
    //
    // _checkDestinationReach();
    //
    // _processNotification();
    //
    // _showHideThanksView();
    //
    // _initBackgroundNotification();
    // _initStreamDataListener();

    // distanceBetweenDestAndSpot = "Loading...";

    _initializeAppState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("AppLifecycleState resumed ");
      resumeScreenState = "1";
      _getSpScreenState();

      if(isOpenedSettings){
        _checkLocationPermission().then((isPermissionGranted) async {
          if (isPermissionGranted) {
            BGServiceHandler().initializePortListener();
          } else {
            _requestForceLocationPermissionRequest("Denied");
          }
        });
      }
    }
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
      print("App State - Foreground Access");

      _foregroundAppStateHandling();
      return "Foreground";
    } else if (spScreenState == "0" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      print("App State - Background Access");
      return "Background";
    } else if (spScreenState == "1" &&
        initScreenState == "1" &&
        resumeScreenState == "0") {
      print("App State - Terminated Access");
      _terminatedAppStateHandling();
      SharedPrefs().setSpState("0");
      return "Terminated";
    } else if (spScreenState == "1" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      print("App State - Background and Notification Clicked");
      _backgroundAppStateNotificationHandling();
      SharedPrefs().setSpState("0");
      return "Background-Notification-Click";
    }
  }

  _foregroundAppStateHandling() {
    _getUserDetail();
    _initializeAndProcessNotification();
    _foregroundLocationAndMap();
    _initializeBackgroundLocationProcess();
    _showHideThanksView();
    _checkDestinationReach();
  }

  _terminatedAppStateHandling() {
    _getUserDetail();
    _initializeAndProcessNotification();
    _backgroundLocationAndMap();
    _checkDestinationReach();
    _backgroundAppStateNotificationHandling();
    // _getSeekerBackgroundNotification();
    // _initializeBackgroundLocationProcess();
    // _showHideThanksView();
  }

  _foregroundLocationAndMap() {
    sourceLocation = sourceAndDest.sourceLocation;
    destLocation = sourceAndDest.destLocation;
    if (sourceLocation != null || destLocation != null) {
      sourceLatitude = sourceLocation.sourceLatitude;
      sourceLongitude = sourceLocation.sourceLongitude;
      sourceAddress = sourceLocation.sourceAddress;
      sourcePinCode = sourceLocation.sourcePostalCode;
    }
  }

  _backgroundLocationAndMap() {
    SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
      setState(() {
        sourceLocation = sourceDetails;
        sourceLatitude = sourceLocation.sourceLatitude;
        sourceLongitude = sourceLocation.sourceLongitude;
        sourceAddress = sourceLocation.sourceAddress;
        sourcePinCode = sourceLocation.sourcePostalCode;

        SharedPrefs().getDestLocationDetails().then((destDetails) {
          setState(() {
            destLocation = destDetails;
            print("destDetails ${destDetails.destLatitude}");
            print("destDetails ${destDetails.destLongitude}");

            // May be few delay might required as the google map to load and set route and marker values
            // _updateLocationMarkerRoute();
          });
        });
      });
    });
  }

  _backgroundAppStateNotificationHandling() async {
    // show accept and ignore alert dialog with the value from shared pref.
    // clear the notification from the notification bar.
    print("_backgroundAppStateNotificationHandling is coming........ ");

    await SharedPrefs().getSpotAcceptedProviderData().then((providerDataValue) {
      _spotProviderData = providerDataValue;
      if(spScreenState == "1") {
        if (mounted &&
            _spotProviderData.spotId != null &&
            _spotProviderData.spotId > 0 &&
            _spotProviderData.notificationCode == "1") {
          // need to remove the above _spotProviderData.notificationCode == "1" condition
          // inform Raji to remove the "Have you spot the provider?" notification when provider confirm for waiting.
          spotId = _spotProviderData.spotId.toString();

          _timeAndDistanceBloc.add(TimeAndDistanceTriggerEvent(
              sourceLatLong: "$sourceLatitude,$sourceLongitude",
              destLatLong:
              "${_spotProviderData.sourcelat},${_spotProviderData.sourcelong}",
              travelMode: WebConstants.DISTANCE_MODE_WALKING));

          showAcceptIgnoreDialog(context);
        }
      }
    });
  }

  Future<void> _getUserDetail() async {
    await SharedPrefs().getUserId().then((userIdValue) async {
      userId = userIdValue;
      print("userId => $userId");
    });
  }

  Future<void> _initializeBackgroundLocationProcess() {
    Future.delayed(Duration(seconds: 2), () {
      _checkLocationPermission().then((isPermissionGranted) {
        if (isPermissionGranted) {
          BGServiceHandler().initializePortListener();
        } else {
          _requestBackgroundPermissionAlert();
        }
      });
    });
  }

  Future<bool> _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    print('access _checkLocationPermission $access');
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        return false;
        break;
      case PermissionStatus.granted:
        return true;
        break;
      default:
        return false;
        break;
    }
  }

  _requestBackgroundPermissionAlert() {
    AppWidgets.showCustomDialogYesNo(context,
            "Allow us to access you location 'Allow All the time' so we can provide personal recommendations")
        .then((value) {
      if (value == DialogAction.Yes) {
        _checkBackGroundPermission();
      }
      else if(value == DialogAction.No){
        _requestForceLocationPermissionRequest("No");
      } else{
        _requestForceLocationPermissionRequest("Cancel");
      }
    });
  }

  Future<PermissionStatus> requestPermission(
      LocationPermissionLevel permissionLevel) async {
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);
    print("requestPermission = $permissionRequestResult");

    return Future<PermissionStatus>.value(permissionRequestResult);
  }

  _checkDestinationReach() async {
    await Geolocator.isLocationServiceEnabled().then((isLocationEnabled) {
      print("check Device Location value $isLocationEnabled");
      _checkLocationPermission().then((isPermissionAllowAlways) {
        if (isPermissionAllowAlways) {
          if (isLocationEnabled) {
            positionStream = Geolocator.getPositionStream()
                .listen((Position currentPosition) {
              print('current position latitude ${currentPosition.latitude}');
              print('current position longitude ${currentPosition.longitude}');
              print('destLocation latitude ${destLocation.destLatitude}');
              print('destLocation longitude ${destLocation.destLongitude}');
              var distanceInMeter = Geolocator.distanceBetween(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  destLocation.destLatitude,
                  destLocation.destLongitude);
              if (distanceInMeter > 0.toDouble() &&
                  distanceInMeter < 30.toDouble()) {
                if (!showSorryMessage) {
                  showSorryMessage = true;
                  AppWidgets.showCustomDialogOK(context,
                          MessageConstants.MESSAGE_SORRY_UNABLE_TO_SPOT)
                      .then((value) {
                    _removeSeekerBloc.add(RemoveSeekerClickEvent(
                        removeSeekerRequest:
                            RemoveSeekerRequest(customerid: userId)));
                  });
                }
              }
            });
          } else {
            AppWidgets.showSnackBar(
                context, MessageConstants.MESSAGE_LOCATION_CHECK);
          }
        }
      });
    });
  }

  _requestForceLocationPermissionRequest(String requestFrom) async {
    AppWidgets.showCustomDialogOK(context,
        "Please, Allow us to access you location 'Allow All the time'. We will open settings for you to grant location permission")
        .then((value) async {
          if(value == DialogAction.OK){
            if(requestFrom == "Denied"){
              await LocationPermissions().openAppSettings().then((isOpenedSettingsFuture) {
                isOpenedSettings = isOpenedSettingsFuture;
              });
            }else if(requestFrom == "No" || requestFrom == "Cancel"){
              requestPermission(_backGroundPermissionLevel).then((value) async {
                if (Platform.isAndroid) {
                  var androidInfo = await DeviceInfoPlugin().androidInfo;
                  var sdkInt = androidInfo.version.sdkInt;
                  print('Android  (SDK $sdkInt) ');
                  if (sdkInt > 29) {
                    _checkLocationPermission().then((isPermissionGranted) {
                      print("_checkLocationPermission = $isPermissionGranted");
                      if (isPermissionGranted) {
                        BGServiceHandler().initializePortListener();
                      } else {
                        _requestForceLocationPermissionRequest("Denied");
                      }
                    });
                  } else {
                    print("permission status = $value");
                    if (PermissionStatus.granted == value) {
                      _checkDestinationReach();
                      BGServiceHandler().initializePortListener();
                    } else if (PermissionStatus.denied == value) {
                      await LocationPermissions().openAppSettings().then((
                          isOpenedSettingsFuture) {
                        isOpenedSettings = isOpenedSettingsFuture;
                      });
                    }
                  }
                }
              });
            }
          }
    });
  }

  _checkBackGroundPermission(){
    requestPermission(_backGroundPermissionLevel).then((value) async {
      if (Platform.isAndroid) {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        print('Android  (SDK $sdkInt) ');
        if (sdkInt > 29) {
          _checkLocationPermission().then((isPermissionGranted) {
            print("_checkLocationPermission = $isPermissionGranted");
            if (isPermissionGranted) {
              BGServiceHandler().initializePortListener();
            } else {
              _requestForceLocationPermissionRequest("Denied");
            }
          });
        } else {
          print("permission status = $value");
          if (PermissionStatus.granted == value) {
            _checkDestinationReach();
            BGServiceHandler().initializePortListener();
          } else if (PermissionStatus.denied == value) {
            _requestForceLocationPermissionRequest("Denied");
          }
        }
      }
    });
  }
  _showHideThanksView() {
    if (mounted) {
      setState(() {
        isShowThanksView = true;
      });
    }
    Future.delayed(const Duration(seconds: NumConstants.THANKS_VIEW_DURATION),
        () {
      if (mounted) {
        setState(() {
          // After 15 seconds the thanks view should hide
          isShowThanksView = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _executePopClick,
      child: Scaffold(
        appBar:
            AppWidgets.showAppBar(AppBarConstants.APP_BAR_ROUTE_TO_DESTINATION),
        body: MultiBlocListener(
          child: _buildRouteView(context),
          listeners: [
            BlocListener<AcceptSpotBloc, AcceptSpotState>(
                cubit: _acceptSpotBloc,
                listener: (context, state) {
                  _blocAcceptSpotListener(context, state);
                }),
            BlocListener<IgnoreSpotBloc, IgnoreSpotState>(
                cubit: _ignoreSpotBloc,
                listener: (context, state) {
                  _blocIgnoreSpotListener(context, state);
                }),
            BlocListener<TimeAndDistanceBloc, TimeAndDistanceState>(
                cubit: _timeAndDistanceBloc,
                listener: (context, state) {
                  _blocTimeAndDistanceListener(context, state);
                }),
            BlocListener<RemoveSeekerBloc, RemoveSeekerState>(
                cubit: _removeSeekerBloc,
                listener: (context, state) {
                  _blocRemoveSeekerListener(context, state);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteView(BuildContext context) {
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
            _updateLocationMarkerRoute();
          },
        ),
        Positioned(
          child: _buildThanksView(),
          top: 0,
          left: 0,
          right: 0,
        ),
      ],
    );
  }

  Widget _buildThanksView() {
    return Visibility(
      visible: isShowThanksView,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                child: Text(
                  WordConstants.ROUTE_TO_DEST_LABEL_THANKS,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Text(
                  WordConstants.ROUTE_TO_DEST_LABEL_WILL_NOTIFY_SPOT_SOON,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAcceptIgnoreDialog(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            dialogState = setState;
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              contentPadding: EdgeInsets.all(8.0),
              content: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildSpotLocatedView(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSpotLocatedView() {
    return Container(
        child: Stack(
      children: [
        _buildMapView(),
        ColorFiltered(
          colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.75), BlendMode.srcOut),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.dstOut), // T
            child: Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 1),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
            ), // his one will handle background + difference out
          ),
        ),
        _buildMiddleView(),
        Positioned(
          bottom: 0.0,
          width: MediaQuery.of(context).size.width - 95,
          child: Column(
            children: [
              _buildSecondsTextView(),
              _buildBottomView(),
            ],
          ),
        ),
        Positioned(
          top: 4.0,
          width: MediaQuery.of(context).size.width - 95,
          child: _buildTopView(),
        ),
      ],
    ));
  }

  Widget _buildMapView() {
    return GoogleMap(
      padding: EdgeInsets.all(16.0),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      markers: _markerPins,
      initialCameraPosition: _cameraPositionOnMap,
      onMapCreated: (GoogleMapController mapController) {
        _googleMapController = mapController;

        _setSpotLocatedMarkerPin(sourceLocation);
      },
    );
  }

  Widget _buildTopView() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.blue,
              borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                  child: Text(
                    "SPOT LOCATED!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                  child: Text(
                    "$distanceBetweenDestAndSpot",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondsTextView() {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                  child: Text(
                    MessageConstants.MESSAGE_SPOT_ACCEPT_IN_30,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleView() {
    return Center(
      child: CircularCountDownTimer(
        duration: 30,
        width: 250,
        height: 200,
        ringColor: Colors.green,
        fillColor: Colors.black87,
        backgroundColor: Colors.transparent,
        strokeWidth: 8.0,
        strokeCap: StrokeCap.butt,
        isReverse: false,
        isReverseAnimation: false,
        isTimerTextShown: false,
        onComplete: () {
          // Here, do whatever you want
          print('Countdown Ended');
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildBottomView() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Container(
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(DialogAction.Yes);
                    _submitAcceptSpot(_spotProviderData);
                  },
                  child: Text(
                    WordConstants.ROUTE_TO_DEST_BUTTON_ACCEPT,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ))),
        )),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
          child: Container(
              height: 45,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(DialogAction.No);
                    _submitIgnoreSpot();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(width: 1.5, color: Colors.black87)),
                  child: Text(
                    WordConstants.ROUTE_TO_DEST_BUTTON_IGNORE,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ))),
        )),
      ],
    );
  }

  _updateLocationMarkerRoute() {
    // Locate source location in map
    _locateSourceLocationInMap(
        sourceLocation.sourceLatitude, sourceLocation.sourceLongitude);

    // Set source and dest markers
    _setMarkerPins(sourceLocation, destLocation);

    // Extract poly line points between source and dest
    // Set the poly lines in map
    _getLocationPointsBetweenSourceAndDest();
  }

  _locateSourceLocationInMap(double sourceLatitude, double sourceLongitude) {
    // Updated Camera Position
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(sourceLatitude, sourceLongitude), zoom: 18.0);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPositionOnMap));
  }

  _setSpotLocatedMarkerPin(SourceLocation sourceLocation) {
    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));

    // Update Camera position to locate our current position in Map
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        zoom: 18.0);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPositionOnMap));
  }

  _setMarkerPins(SourceLocation sourceLocation, DestLocation destLocation) {
    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)));
    // destination pin
    _markerPins.add(Marker(
        markerId: MarkerId('dest_marker'),
        position: LatLng(destLocation.destLatitude, destLocation.destLongitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
  }

  _getLocationPointsBetweenSourceAndDest() async {
    await PolylinePoints()
        .getRouteBetweenCoordinates(
      WordConstants.GOOGLE_PLACES_API_KEY, // Google Maps API Key
      PointLatLng(
          sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
      PointLatLng(destLocation.destLatitude, destLocation.destLongitude),
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

  _initializeAndProcessNotification() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print("onMessage data RouteToDestination ${remoteMessage.data}");
      print("onMessage data RouteToDestination notification code =  ${remoteMessage.data['Notificationcode']}");

      _spotProviderData = SpotLocatedNotification.fromJson(remoteMessage).data;
      print("Spot Id ${_spotProviderData.spotId}");
        if (mounted &&
            _spotProviderData.spotId != null &&
            _spotProviderData.spotId > 0 &&
            remoteMessage.data['Notificationcode'] != null) {
          // need to remove the above  remoteMessage.data['Notificationcode'] != null condition
          // inform Raji to remove the "Have you spot the provider?" notification when provider confirm for waiting.
          spotId = _spotProviderData.spotId.toString();

          // distanceBetweenDestAndSpot="Notification Received...";

          _timeAndDistanceBloc.add(TimeAndDistanceTriggerEvent(
              sourceLatLong:
              "${_spotProviderData.sourcelat},${_spotProviderData.sourcelong}",
              destLatLong:
              "${destLocation.destLatitude},${destLocation.destLongitude}",
              travelMode: WebConstants.DISTANCE_MODE_WALKING));

          showAcceptIgnoreDialog(context);
        }
    });
  }

  Future<void> _submitAcceptSpot(ProviderData providerData) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var acceptSpotRequest = AcceptSpotRequest(
            userId: userId,
            sourceLat: sourceLocation.sourceLatitude.toString(),
            sourceLong: sourceLocation.sourceLongitude.toString(),
            spotId: spotId);
        _acceptSpotBloc.add(AcceptSpotClickEvent(
            acceptSpotRequest: acceptSpotRequest, providerData: providerData));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitIgnoreSpot() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var ignoreSpotRequest =
            IgnoreSpotRequest(userId: userId, spotId: spotId);
        _ignoreSpotBloc
            .add(IgnoreSpotClickEvent(ignoreSpotRequest: ignoreSpotRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocAcceptSpotListener(BuildContext context, AcceptSpotState state) {
    if (state is AcceptSpotEmpty) {}
    if (state is AcceptSpotLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is AcceptSpotError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is AcceptSpotSuccess) {
      AppWidgets.hideProgressBar();
      print("AcceptSpot Success ${state.acceptSpotResponse.message}");
      if (positionStream != null) {
        print("AcceptSpot Success cancelled the position stream");
        positionStream.cancel();
      }
      Navigator.pushNamedAndRemoveUntil(context, RouteConstants.ROUTE_ROUTE_TO_SPOT, ModalRoute.withName(RouteConstants.ROUTE_HOME_SCREEN));
    }
  }

  _blocIgnoreSpotListener(BuildContext context, IgnoreSpotState state) {
    if (state is IgnoreSpotEmpty) {}
    if (state is IgnoreSpotLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is IgnoreSpotError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is IgnoreSpotSuccess) {
      AppWidgets.hideProgressBar();
      print("IgnoreSpot Success ${state.ignoreSpotResponse.message}");
    }
  }

  _blocTimeAndDistanceListener(
      BuildContext context, TimeAndDistanceState state) {
    if (state is TimeAndDistanceEmpty) {}
    if (state is TimeAndDistanceLoading) {
      // AppWidgets.showProgressBar();
    }
    if (state is TimeAndDistanceError) {
      // AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is TimeAndDistanceSuccess) {
      // AppWidgets.hideProgressBar();
      print(
          "Google Time value ${state.timeAndDistanceResponse.rows[0].elements[0].duration.text}  \n Distance value ${state.timeAndDistanceResponse.rows[0].elements[0].distance.text}");

      if (dialogState != null) {
        dialogState(() {
          distanceBetweenDestAndSpot =
              "${MessageConstants.MESSAGE_SPOT_DEST_DISTANCE_ONE} ${state.timeAndDistanceResponse.rows[0].elements[0].distance.text} ${MessageConstants.MESSAGE_SPOT_DEST_DISTANCE_TWO}";
          print(
              "Bloc listener distanceBetweenDestAndSpot $distanceBetweenDestAndSpot");
        });
      }
    }
  }

  _blocRemoveSeekerListener(
      BuildContext context, RemoveSeekerState state) {
    if (state is RemoveSeekerEmpty) {}
    if (state is RemoveSeekerLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is RemoveSeekerError) {
      AppWidgets.hideProgressBar();
      print("RemoveSeekerError");
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is RemoveSeekerSuccess) {
      AppWidgets.hideProgressBar();
      print("RemoveSeekerSuccess");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    }
  }

  Future<bool> _executePopClick() {
    AppWidgets.showCustomDialogYesNo(
            context, "Do you want to cancel this trip?")
        .then((value) async {
      if (value == DialogAction.Yes) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
      } else if (value == DialogAction.No) {
        // Navigator.pop(context, false);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (positionStream != null) {
      positionStream.cancel();
    }
    super.dispose();
  }
}
