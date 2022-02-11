import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/leave_spot/provider_leave_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/leave_spot/provider_leave_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/leave_spot/provider_leave_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_accept_extra_time/provider_accept_extra_time_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_accept_extra_time/provider_accept_extra_time_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_accept_extra_time/provider_accept_extra_time_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_cancel/provider_cancel_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_cancel/provider_cancel_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_cancel/provider_cancel_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_ignore_extra_time/provider_ignore_extra_time_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_ignore_extra_time/provider_ignore_extra_time_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/provider_ignore_extra_time/provider_ignore_extra_time_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/refresh_location/refresh_location_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/refresh_location/refresh_location_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/refresh_location/refresh_location_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/spotted_seeker/spotted_seeker_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/spotted_seeker/spotted_seeker_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/spotted_seeker/spotted_seeker_state.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/wait_for_seeker/provider_wait_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/wait_for_seeker/provider_wait_event.dart';
import 'package:spocate/screens/home_screen/view/provider/bloc/wait_for_seeker/provider_wait_state.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/leave_spot/provider_leaving_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/notification/provider_notification.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_accept_extra_time/provider_accept_extra_time_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_repo.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_cancel/provider_cancel_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_ignore_extra_time/provider_ignore_extra_time_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/provider_repo.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/refresh_location/refresh_location_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/spotted_seeker/spotted_seeker_request.dart';
import 'package:spocate/screens/home_screen/view/provider/repo/wait_for_seeker/provider_waiting_request.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/bloc/seeker_cancel_provider_wait_bloc.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/bloc/seeker_cancel_provider_wait_event.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/bloc/seeker_cancel_provider_wait_state.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_repo.dart';
import 'package:spocate/screens/home_screen/view/provider/seeker_cancel_provider_wait/repo/seeker_cancel_provider_wait_request.dart';
import 'package:spocate/utils/network_utils.dart';

import '../../../../../payload_passer.dart';
import '../../source_location.dart';

class ProviderWaiting extends StatefulWidget {
  final SourceLocation sourceLocation;

  // final double sourceLatitude;
  // final double sourceLongitude;
  const ProviderWaiting({Key key, this.sourceLocation}) : super(key: key);

  @override
  _ProviderWaitingState createState() => _ProviderWaitingState(sourceLocation);
}

class _ProviderWaitingState extends State<ProviderWaiting>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  SourceLocation sourceLocation;

  FirebaseMessaging _firebaseMessaging;

  _ProviderWaitingState(this.sourceLocation);

  GoogleMapController _googleMapController;
  CameraPosition _cameraPositionOnMap;
  Set<Marker> _markerPins = {};
  Set<Polyline> _polyLines = {};
  List<LatLng> polylineCoordinates = [];

  SeekerData _seekerData;

  ProviderLeaveBloc _providerLeaveBloc;
  ProviderWaitBloc _providerWaitBloc;
  SpottedSeekerBloc _spottedSeekerBloc;
  RefreshLocationBloc _refreshLocationBloc;
  SeekerCancelProviderWaitBloc _seekerCancelProviderWaitBloc;
  ProviderCancelBloc _providerCancelBloc;
  ProviderAcceptExtraTimeBloc _providerAcceptExtraTimeBloc;
  ProviderIgnoreExtraTimeBloc _providerIgnoreExtraTimeBloc;

  String userId;

  String seekerCarNumber = "";
  String seekerCarColor = "";
  String seekerCarModel = "";
  String seekerCarMake = "";
  String seekerAddress = "";
  String seekerDistance = "";
  String seekerDuration = "";
  double seekerLatitude = 0.0;
  double seekerLongitude = 0.0;

  bool isSeekerDetailsToShow = false;

  CarInfoAnimState carInfoAnimState;

  AnimationController controller;
  Animation<Offset> offset;

  Timer timerToRefreshSeekerLocation;

  // App State handling variables
  String initScreenState = "0";
  String resumeScreenState = "0";
  String spScreenState = "0";

  // terminated state navigation
  bool isTerminatedState = false;

  @override
  void initState() {
    super.initState();
    SharedPrefs().setLastVisitedScreen(AppBarConstants.APP_BAR_WAIT_FOR_SEEKER);
    WidgetsBinding.instance.addObserver(this);
    print("initState ProviderWaiting");

    final ProviderRepository repository = ProviderRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());
    _providerLeaveBloc = ProviderLeaveBloc(repository: repository);
    _providerWaitBloc = ProviderWaitBloc(repository: repository);
    _spottedSeekerBloc = SpottedSeekerBloc(repository: repository);
    _refreshLocationBloc = RefreshLocationBloc(repository: repository);

    final ProviderCancelRepository providerCancelRepository = ProviderCancelRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());
    _providerCancelBloc = ProviderCancelBloc(repository: providerCancelRepository);

    final SeekerCancelProviderWaitRepository
        seekerCancelProviderWaitRepository = SeekerCancelProviderWaitRepository(
            webservice: Webservice(), sharedPrefs: SharedPrefs());
    _seekerCancelProviderWaitBloc = SeekerCancelProviderWaitBloc(
        repository: seekerCancelProviderWaitRepository);


    _providerAcceptExtraTimeBloc = ProviderAcceptExtraTimeBloc(repository: repository);

    _providerIgnoreExtraTimeBloc = ProviderIgnoreExtraTimeBloc(repository: repository);

    _initializeCarViewShowHideAnimation();
    _initializeAppState();
    _processNotification();
    _getUserDetails();
    _initializeCameraPosition();
    if (sourceLocation != null) {
      // Foreground Handling

    } else {
      // Teminated Handling
      // sourceLocation = SourceLocation();

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
    print("App State navigatedFrom ${sourceLocation.navigatedFrom}");

    if (spScreenState == "0" &&
        initScreenState == "1" &&
        resumeScreenState == "0" &&
        sourceLocation.navigatedFrom == RouteConstants.ROUTE_HOME_SCREEN) {
      print("App State Provider waiting Screen - Foreground Access");

      _foregroundAppStateHandling();
      return "Foreground";
    } else if (spScreenState == "0" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      _backgroundAppStateNotificationHandling();
      print("App State Provider waiting Screen - Background Access");
      return "Background";
    } else if (initScreenState == "1" &&
        resumeScreenState == "0" &&
        sourceLocation.navigatedFrom == RouteConstants.ROUTE_SPLASH) {
      print("App State Provider waiting Screen - Terminated Access");
      isTerminatedState = true;
      _terminatedAppStateHandling();
      SharedPrefs().setSpState("0");
      return "Terminated";
    } else if (spScreenState == "1" &&
        initScreenState == "1" &&
        resumeScreenState == "1") {
      print(
          "App State Provider waiting Screen - Background and Notification Clicked");
      _backgroundAppStateNotificationHandling();
      SharedPrefs().setSpState("0");
      return "Background-Notification-Click";
    }
  }

  _foregroundAppStateHandling() async {
    // get User Detail
    // Locate source location in Map
    // Process notification receiving

    // Accept will draw route and map pin markers
    // show address and car details
    // Refresh seeker User info webservice

    // Yes clicked for have you spotted seeker
    // SharedPrefs().getProviderWaitingSeekerData().then((seekerData) {
    //   if(seekerData!=null && seekerData.message.isNotEmpty){
    //     _seekerData = seekerData;
    //     _processSeekerDataParsing();
    //   }
    //   SharedPrefs().getIsSeekerDetailsToShow().then((isSeekerDetailsToShowValue) {
    //     // if(isSeekerDetailsToShowValue) {
    //     setState(() {
    //       isSeekerDetailsToShow = isSeekerDetailsToShowValue;
    //       print("isSeekerDetailsToShow  $isSeekerDetailsToShow");
    //       SharedPrefs().setIsSeekerDetailsToShow(false);
    //       _updateLocationMarkerRoute(_seekerData);
    //       _autoRefreshSeekerLocation();
    //     });
    //     // }
    //   });
    // });
  }

  _backgroundAppStateNotificationHandling() {
    SharedPrefs().getProviderWaitingSeekerData().then((seekerData) {
      print(
          "_backgroundAppStateNotificationHandling seeker message ${seekerData.message}");
      if (seekerData != null && seekerData.message.isNotEmpty) {
        _seekerData = seekerData;
        _processIsSeekerDetailVisibility();
        _processSeekerDataParsing(spScreenState);
      }
    });
  }

  _terminatedAppStateHandling() async {
    SharedPrefs().getProviderWaitingSeekerData().then((seekerData) {
      // print("_terminatedAppStateHandling seeker userId ${seekerData.userId}");
      _seekerData = seekerData;
      print(
          "_terminatedAppStateHandling _seekerData to json ${_seekerData.toJson()}");
      print(
          "_terminatedAppStateHandling seekerData to json ${seekerData.toJson()}");
      SharedPrefs().getIsSeekerDetailsToShow().then((isSeekerDetailsToShowValue) {
        // if(isSeekerDetailsToShowValue) {
        setState(() {
          isSeekerDetailsToShow = isSeekerDetailsToShowValue;
          print("isSeekerDetailsToShow  $isSeekerDetailsToShow");
        });
        // }
      });
      _processIsSeekerDetailVisibility();
      _processSeekerDataParsing(spScreenState);
      _getCurrentLocationAndLocate();
      if (_seekerData.userId > 0) {
              _autoRefreshSeekerLocation();
       }
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

  _initializeCameraPosition() {
    // Initial Camera Position
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        zoom: 18.0);
    // _cameraPositionOnMap = CameraPosition(
    //     target: LatLng(40.740156, -73.997701), zoom: 18.0);
  }

  Future<void> _getCurrentLocationAndLocate() async {
    await Geolocator.isLocationServiceEnabled().then((isLocationEnabled) async {
      if (isLocationEnabled) {
        await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high)
            .then((currentPosition) {
          if (mounted) {
            setState(() {
              sourceLocation.sourceLatitude = currentPosition.latitude;
              sourceLocation.sourceLongitude = currentPosition.longitude;
              print(
                  "Provider_waiting sourceLatitude ${sourceLocation.sourceLatitude} ");
              print(
                  "Provider_waiting sourceLongitude ${sourceLocation.sourceLongitude} ");
              _initializeCameraPosition();
              if(_seekerData.sourceLat != "0.0"){
                _updateLocationMarkerRoute(_seekerData);
              }
            });
          }
        });
      }
    });
  }

  _processNotification() {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.subscribeToTopic("all");
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      print("onMessage data ProviderWaiting ${remoteMessage.data.toString()}");
      // remoteMessage.data['data'].toString().contains("Car Number")
      print("onMessage data ProviderWaiting Notification code = ${remoteMessage.data['Notificationcode']}");
      if(remoteMessage.data['Notificationcode'] == MessageConstants.PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME){
       SharedPrefs().setNotificationCode(remoteMessage.data['Notificationcode']);
       SharedPrefs().setNotificationMessage(remoteMessage.data['message']);
       SharedPrefs().setNotificationUserType(remoteMessage.data['UserType']);
       SharedPrefs().getProviderWaitingSeekerData().then((seekerDataValue) {
         _seekerData = seekerDataValue;
         _processIsSeekerDetailVisibility();
         _processSeekerDataParsing("1");
       });
      }else{
        _seekerData = ProviderNotification.fromJson(remoteMessage).data;
        SharedPrefs().setProviderWaitingSeekerData(_seekerData);
        _processIsSeekerDetailVisibility();
        _processSeekerDataParsing("1");
      }
    });
  }

  _processIsSeekerDetailVisibility(){
    if (_seekerData.notificationCode ==
        MessageConstants
            .PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER ||
        _seekerData.notificationCode ==
            MessageConstants
                .PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER) {
      if (timerToRefreshSeekerLocation != null &&
          timerToRefreshSeekerLocation.isActive) {
        timerToRefreshSeekerLocation.cancel();
      }
      if(mounted){
        setState(() {
          isSeekerDetailsToShow = false;
          SharedPrefs().setIsSeekerDetailsToShow(isSeekerDetailsToShow);
        });
      }
    }
  }
  _processSeekerDataParsing(String spScreenState) {
    // if(_seekerData.userId != null){
    if (mounted) {
      setState(() {
        // _seekerData = tempSeekerData;
        seekerCarNumber = _seekerData.carNumber;
        seekerCarColor = _seekerData.carColor;
        seekerCarModel = _seekerData.carModel;
        seekerCarMake = _seekerData.carMake;
        seekerAddress = _seekerData.address;
        seekerDistance = _seekerData.distance;
        seekerDuration = _seekerData.drivingMinutes;
        seekerLatitude = _seekerData.sourceLat != null
            ? double.parse(_seekerData.sourceLat)
            : 0.0;
        seekerLongitude = _seekerData.sourceLong != null
            ? double.parse(_seekerData.sourceLong)
            : 0.0;
      });
      // }
    }
    print("_seekerData  ${_seekerData.message}");

    if (spScreenState == "1") {
      _showAlert(_seekerData.message, _seekerData.notificationCode);
    }
  }

  _showAlert(String message, String notificationCode) {
    if (mounted) {
      if (notificationCode ==
          MessageConstants.PROVIDER_NOTIFICATION_3_SEEKER_CANCELLED_FOUND_NO_SEEKER) {
        AppWidgets.showCustomDialogOK(context, message).then((value) {
          // if (value == DialogAction.OK) {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
          // }
        });
      } else {
        AppWidgets.showCustomDialogYesNo(context, message).then((value) {
          if (value == DialogAction.Yes) {
            print("Yes Clicked");
            if (notificationCode ==
                MessageConstants.PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY) {
              // Seeker on the way, will you wait
              _submitProviderWaitSpot();
            } else if (notificationCode ==
                MessageConstants.PROVIDER_NOTIFICATION_2_SEEKER_REACHED) {
              // Have you spotted Seeker
              _submitProviderSpottedSeeker("1");
            } else if (notificationCode ==
                MessageConstants
                    .PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER) {
              // Seeker Cancelled and Provider wait for another seeker and tap on YES Action
              _submitSeekerCancelledProviderWait("1");
            }
            else if (notificationCode ==
                MessageConstants
                    .PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME) {
              // Seeker asking for extra time and Provider accepting the request by tapping  on YES Action
              _submitProviderAcceptExtraTime();
            }
          } else if (value == DialogAction.No) {
            print("NO  Clicked");
            if (notificationCode ==
                MessageConstants.PROVIDER_NOTIFICATION_1_SEEKER_ON_WAY) {
              // Seeker on the way, will you wait
              _submitProviderLeaveSpot();
            } else if (notificationCode ==
                MessageConstants.PROVIDER_NOTIFICATION_2_SEEKER_REACHED) {
              // Have you spotted Seeker
              _submitProviderSpottedSeeker("0");
            } else if (notificationCode ==
                MessageConstants
                    .PROVIDER_NOTIFICATION_4_SEEKER_CANCELLED_FOUND_ANOTHER_SEEKER) {
              // Seeker Cancelled and Provider wait for another seeker and tap on NO Action
              _submitSeekerCancelledProviderWait("0");
            }
            else if (notificationCode ==
                MessageConstants
                    .PROVIDER_NOTIFICATION_5_SEEKER_ASKING_FOR_EXTRA_TIME) {
              // Seeker asking for extra time and Provider accepting the request by tapping on No Action
              _submitProviderIgnoreExtraTime();
            }
          }
        });
      }
    }
  }

  _autoRefreshSeekerLocation() {
    _submitRefreshSeekerLocation();
    timerToRefreshSeekerLocation =
        Timer.periodic(Duration(seconds: 15), (Timer t) {
      _submitRefreshSeekerLocation();
    });
  }

  void _getUserDetails() {
    SharedPrefs().getUserId().then((userIdValue) {
      userId = userIdValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        "notificationActionListener = ${context.watch<PayloadPasser>().payload}");
    return WillPopScope(
      onWillPop: _executePopClick,
      child: Scaffold(
        appBar: AppWidgets.showAppBar(AppBarConstants.APP_BAR_WAIT_FOR_SEEKER),
        body: MultiBlocListener(
          child: _buildProviderWaitView(),
          listeners: [
            BlocListener<ProviderLeaveBloc, ProviderLeaveState>(
                cubit: _providerLeaveBloc,
                listener: (context, state) {
                  _blocProviderLeaveListener(context, state);
                }),
            BlocListener<ProviderWaitBloc, ProviderWaitState>(
                cubit: _providerWaitBloc,
                listener: (context, state) {
                  _blocProviderWaitListener(context, state);
                }),
            BlocListener<SpottedSeekerBloc, SpottedSeekerState>(
                cubit: _spottedSeekerBloc,
                listener: (context, state) {
                  _blocProviderSpottedSeekerListener(context, state);
                }),
            BlocListener<RefreshLocationBloc, RefreshLocationState>(
                cubit: _refreshLocationBloc,
                listener: (context, state) {
                  _blocRefreshSeekerLocationListener(context, state);
                }),
            BlocListener<SeekerCancelProviderWaitBloc,
                    SeekerCancelProviderWaitState>(
                cubit: _seekerCancelProviderWaitBloc,
                listener: (context, state) {
                  _blocSeekerCancelProviderWaitListener(context, state);
                }),
            BlocListener<ProviderCancelBloc,
                    ProviderCancelState>(
                cubit: _providerCancelBloc,
                listener: (context, state) {
                  _blocProviderCancelListener(context, state);
                }),
            BlocListener<ProviderAcceptExtraTimeBloc,
                ProviderAcceptExtraTimeState>(
                cubit: _providerAcceptExtraTimeBloc,
                listener: (context, state) {
                  _blocProviderAcceptExtraTimeListener(context, state);
                }),
            BlocListener<ProviderIgnoreExtraTimeBloc,
                ProviderIgnoreExtraTimeState>(
                cubit: _providerIgnoreExtraTimeBloc,
                listener: (context, state) {
                  _blocProviderIgnoreExtraTimeListener(context, state);
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderWaitView() {
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
            // _updateLocationMarkerRoute(_seekerData);
          },
        ),
        Positioned(
          child: _buildAddressAndCarView(context),
          top: 0,
          left: 0,
          right: 0,
        ),
      ],
    );
  }

  Widget _buildAddressAndCarView(BuildContext context) {
    return Visibility(
        visible: isSeekerDetailsToShow,
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
                                            '${seekerAddress ?? ""}',
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
                                                      '${seekerDuration ?? ""}',
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
                                                      '${seekerDistance ?? ""}',
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
                              Text('${seekerCarMake ?? ""}',
                                  // Benz Car Make',
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              SizedBox(height: 12),
                              Text('${seekerCarModel ?? ""}',
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
                                          "${seekerCarNumber ?? ""}",
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
                                          "${seekerCarColor ?? ""}", //BLUE",
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

  _updateLocationMarkerRoute(SeekerData seekerData) {
    // Locate source location in map
    _locateSourceLocationInMap(seekerData);

    // Set source and dest markers
    if (seekerData == null) {
      // Initial first time provider current location
      _setSourcePin(
          sourceLocation.sourceLatitude, sourceLocation.sourceLongitude);
    } else {
      // Once notification received then draw 2 pins
      _setMarkerPins(seekerData);

      // isSeekerDetailsToShow = true;
    }

    // Extract poly line points between source and dest
    // Set the poly lines in map
    _getLocationPointsBetweenSourceAndDest(_seekerData);
  }

  _updateSeekerCurrentLocation(
      double seekerCurrentLat, double seekerCurrentLong) async {
    print("_markerPins size ${_markerPins.length}");
    _markerPins.add(Marker(
        markerId: MarkerId('seeker_marker'),
        position: LatLng(seekerCurrentLat, seekerCurrentLong),
        icon: await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(40, 40)),
            'assets/images/marker_map_icon.png')
        // BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
        ));
  }

  _locateSourceLocationInMap(SeekerData seekerData) {
    // Updated Camera Position
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(double.parse(seekerData.sourceLat),
            double.parse(seekerData.sourceLong)),
        zoom: 18.0);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPositionOnMap));
  }

  _setSourcePin(double sourceLat, double sourceLong) {
    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(sourceLat, sourceLong),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
  }

  _setMarkerPins(SeekerData seekerData) {
    print("Damu sourceLat ${sourceLocation.sourceLatitude}");
    print("Damu sourceLong ${sourceLocation.sourceLongitude}");
    print("Damu destLat ${seekerData.sourceLat}");
    print("Damu destLong${seekerData.sourceLong}");

    _markerPins.clear();
    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(double.parse(seekerData.sourceLat),
            double.parse(seekerData.sourceLong)),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
    // destination pin
    _markerPins.add(Marker(
        markerId: MarkerId('dest_marker'),
        // position: LatLng(double.parse(seekerData.destinationLat), double.parse(seekerData.destinationLong)),
        position: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        // position: LatLng(13.041519, 80.232391),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
  }

  _getLocationPointsBetweenSourceAndDest(SeekerData seekerData) async {
    await PolylinePoints()
        .getRouteBetweenCoordinates(
      WordConstants.GOOGLE_PLACES_API_KEY, // Google Maps API Key
      PointLatLng(double.parse(seekerData.sourceLat),
          double.parse(seekerData.sourceLong)),
      // PointLatLng(double.parse(seekerData.destinationLat),
      //     double.parse(seekerData.destinationLong)),
      PointLatLng(
          sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
      // PointLatLng(13.041519, 80.232391),
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

  Future<void> _submitProviderLeaveSpot() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var providerLeaveRequest = ProviderLeavingRequest(userId: userId);
        _providerLeaveBloc.add(ProviderLeaveClickEvent(
            providerLeavingRequest: providerLeaveRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitProviderWaitSpot() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var providerWaitRequest = ProviderWaitingRequest(
            userId: userId,
            sourceLat: sourceLocation.sourceLatitude.toString(),
            sourceLong: sourceLocation.sourceLongitude.toString());
        _providerWaitBloc.add(ProviderWaitClickEvent(
            providerWaitingRequest: providerWaitRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitProviderSpottedSeeker(String isSpotted) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var spottedSeekerRequest =
            SpottedSeekerRequest(unParkUserId: userId, isSpotted: isSpotted);
        _spottedSeekerBloc.add(SpottedSeekerClickEvent(
            spottedSeekerRequest: spottedSeekerRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitSeekerCancelledProviderWait(String isWait) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var seekerCancelProviderWaitRequest = SeekerCancelProviderWaitRequest(
            userId: userId,
            sourceLat: sourceLocation.sourceLatitude.toString(),
            sourceLong: sourceLocation.sourceLongitude.toString(),
            sourceAddress: sourceLocation.sourceAddress,
            sourcePinCode: sourceLocation.sourcePostalCode,
            isParked: "0",
            isWait: isWait);
        _seekerCancelProviderWaitBloc.add(SeekerCancelProviderWaitClickEvent(
            seekerCancelProviderWaitRequest: seekerCancelProviderWaitRequest,
            isWait: isWait));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitRefreshSeekerLocation() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var refreshLocationRequest =
            RefreshLocationRequest(userId: _seekerData.userId.toString());
        _refreshLocationBloc.add(RefreshLocationTriggerEvent(
            refreshLocationRequest: refreshLocationRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitProviderCancelled() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var providerCancelledRequest =
        ProviderCancelRequest(userId: userId.toString());
        _providerCancelBloc.add(ProviderCancelClickEvent(
            providerCancelRequest: providerCancelledRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  Future<void> _submitProviderAcceptExtraTime() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var providerAcceptExtraTimeRequest =
        ProviderAcceptExtraTimeRequest(seekerId: _seekerData.userId.toString());
        _providerAcceptExtraTimeBloc.add(ProviderAcceptExtraTimeClickEvent(
           providerAcceptExtraTimeRequest: providerAcceptExtraTimeRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }


  Future<void> _submitProviderIgnoreExtraTime() async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        var providerIgnoreExtraTimeRequest =
        ProviderIgnoreExtraTimeRequest(providerId: userId.toString() , seekerId: _seekerData.userId.toString());
        _providerIgnoreExtraTimeBloc.add(ProviderIgnoreExtraTimeClickEvent(
            providerIgnoreExtraTimeRequest: providerIgnoreExtraTimeRequest));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
  }

  _blocProviderLeaveListener(
      BuildContext context, ProviderLeaveState state) async {
    if (state is ProviderLeaveEmpty) {}
    if (state is ProviderLeaveLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProviderLeaveError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProviderLeaveSuccess) {
      AppWidgets.hideProgressBar();
      print("ProviderLeave Success ${state.providerLeaveResponse.message}");

      await AwesomeNotifications().cancelAll();

      // if(isTerminatedState){
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
      // }else{
      //   Navigator.pop(context);
      // }

    }
  }

  _blocProviderWaitListener(BuildContext context, ProviderWaitState state) {
    if (state is ProviderWaitEmpty) {}
    if (state is ProviderWaitLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProviderWaitError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProviderWaitSuccess) {
      AppWidgets.hideProgressBar();
      print("ProviderWait Success ${state.providerWaitResponse.message}");
      setState(() {
        // foreground state
        isSeekerDetailsToShow = true;
        // terminated state
        SharedPrefs().setIsSeekerDetailsToShow(isSeekerDetailsToShow);
        // SharedPrefs().setProviderWaitingSeekerData(_seekerData);
        _updateLocationMarkerRoute(_seekerData);
        _autoRefreshSeekerLocation();
      });
    }
  }

  _blocProviderSpottedSeekerListener(
      BuildContext context, SpottedSeekerState state) async {
    if (state is SpottedSeekerEmpty) {}
    if (state is SpottedSeekerLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is SpottedSeekerError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is SpottedSeekerSuccess) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.spottedSeekerResponse.message);
      await AwesomeNotifications().cancelAll();
      print("ProviderSpotted Success ${state.spottedSeekerResponse.message}");
      // if(isTerminatedState){
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
      // }else{
      //   Navigator.pop(context);
      // }
    }
  }

  _blocRefreshSeekerLocationListener(
      BuildContext context, RefreshLocationState state) {
    if (state is RefreshLocationEmpty) {}
    if (state is RefreshLocationLoading) {
      // AppWidgets.showProgressBar();
    }
    if (state is RefreshLocationError) {
      // AppWidgets.hideProgressBar();
      // AppWidgets.showSnackBar(context, state.message);
    }
    if (state is RefreshLocationSuccess) {
      // AppWidgets.hideProgressBar();
      print(
          "Refresh Location distance ${state.refreshLocationResponse.parkingUser.distance}");
      print(
          "Refresh Location drivingMinutes ${state.refreshLocationResponse.parkingUser.drivingMinutes}");
      setState(() {
        if (state.refreshLocationResponse.parkingUser.distance != null) {
          seekerDistance = state.refreshLocationResponse.parkingUser.distance;
        }
        if (state.refreshLocationResponse.parkingUser.drivingMinutes != null) {
          seekerDuration =
              state.refreshLocationResponse.parkingUser.drivingMinutes;
        }
        // _updateSeekerCurrentLocation(
        //     double.parse(state.refreshLocationResponse.parkingUser.sourcelat),
        //     double.parse(state.refreshLocationResponse.parkingUser.sourcelong));
      });
    }
  }

  _blocSeekerCancelProviderWaitListener(
      BuildContext context, SeekerCancelProviderWaitState state) {
    if (state is SeekerCancelProviderWaitEmpty) {}
    if (state is SeekerCancelProviderWaitLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is SeekerCancelProviderWaitError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is SeekerCancelProviderWaitSuccess) {
      AppWidgets.hideProgressBar();
      print(
          "Seeker cancel provider waiting Listener ${state.seekerCancelProviderWaitResponse.message}");
      if(state.isWait == "0"){
        Navigator.pushNamedAndRemoveUntil(
            context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
      }
    }
  }

  _blocProviderCancelListener(
      BuildContext context, ProviderCancelState state) {
    if (state is ProviderCancelEmpty) {}
    if (state is ProviderCancelLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProviderCancelError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProviderCancelSuccess) {
      AppWidgets.hideProgressBar();
      print("Provider Cancel Listener Success");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    }
  }


  _blocProviderAcceptExtraTimeListener(
      BuildContext context, ProviderAcceptExtraTimeState state) {
    if (state is ProviderAcceptExtraTimeEmpty) {}
    if (state is ProviderAcceptExtraTimeLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProviderAcceptExtraTimeError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProviderAcceptExtraTimeSuccess) {
      AppWidgets.hideProgressBar();
      print("ProviderAcceptExtraTime Success");
    }
  }


  _blocProviderIgnoreExtraTimeListener(
      BuildContext context, ProviderIgnoreExtraTimeState state) {
    if (state is ProviderIgnoreExtraTimeEmpty) {}
    if (state is ProviderIgnoreExtraTimeLoading) {
      AppWidgets.showProgressBar();
    }
    if (state is ProviderIgnoreExtraTimeError) {
      AppWidgets.hideProgressBar();
      AppWidgets.showSnackBar(context, state.message);
    }
    if (state is ProviderIgnoreExtraTimeSuccess) {
      AppWidgets.hideProgressBar();
      print("ProviderIgnoreExtraTime Success");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteConstants.ROUTE_HOME_SCREEN, (route) => false);
    }
  }

  Future<bool> _executePopClick() {
    AppWidgets.showCustomDialogYesNo(
        context, "Do you want to cancel this trip?")
        .then((value) async {
      if (value == DialogAction.Yes) {
        _submitProviderCancelled();
      } else if (value == DialogAction.No) {
        // Navigator.pop(context, false);
      }
    });
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      resumeScreenState = "1";
      _getSpScreenState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (timerToRefreshSeekerLocation != null &&
        timerToRefreshSeekerLocation.isActive) {
      timerToRefreshSeekerLocation.cancel();
    }
    super.dispose();
  }
}
