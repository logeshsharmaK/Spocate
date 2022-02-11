import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spocate/screens/home_screen/view/seeker/search_destination/repo/destination_location.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';

import 'core/constants/app_bar_constants.dart';
import 'core/constants/word_constants.dart';
import 'core/widgets/app_widgets.dart';
import 'data/local/shared_prefs/shared_prefs.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  SourceLocation sourceLocation;
  DestLocation destLocation;

  Set<Marker> _markerPins = {};
  // Set<Polyline> _polyLines = {};
  // List<LatLng> polylineCoordinates = [];

  GoogleMapController _googleMapController;

  CameraPosition _cameraPositionOnMap;

  // PolylinePoints polylinePoints = PolylinePoints();
  String googleAPIKey = "AIzaSyA1fCASJErNUjWPPhCrXofo9WRgFNy8f5Q";

  bool _visibleMange = true;

  CountDownController _controller1 = CountDownController();



  @override
  void initState() {
    super.initState();
    _cameraPositionOnMap =
        CameraPosition(target: LatLng(40.740156, -73.997701), zoom: 18.0);

    _getSourceAndDestDetails();
  }

  Future<void> _getSourceAndDestDetails() async {
    SharedPrefs().getSourceLocationDetails().then((sourceDetails) {
      setState(() {
        sourceLocation = sourceDetails;
      });
      SharedPrefs().getDestLocationDetails().then((destDetails) {
        setState(() {
          destLocation = destDetails;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppWidgets.showAppBar(AppBarConstants.APP_BAR_ROUTE_TO_DESTINATION),
      resizeToAvoidBottomInset: false,
      body: Center(
        child: RaisedButton(
          onPressed: () {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height - 700,
                    padding: EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width , // or use fixed size like
                          height: MediaQuery.of(context).size.height - 100,
                          child: new Stack(
                            children: [
                              _mapView(),
                              showSpotLocatedView(context),
                              // _buildTimerBody()
                              // _topView(),
                              // _bottomView(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );

    /*Container(
        child: );*/
  }

  Widget showSpotLocatedView(BuildContext context) {
    return Column(

        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context)
                .size
                .width, // or use fixed size like 200
            height: MediaQuery.of(context).size.height,
            child: new Stack(
              // fit: StackFit.expand,
              children: [

                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.white.withOpacity(0.75),
                      BlendMode.srcOut),
                  // This one will create the magic
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            backgroundBlendMode: BlendMode
                                .dstOut), // This one will handle background + difference out
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          margin: const EdgeInsets.only(top: 1),
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(150),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // _topSpotLocatedView(),
                _buildTimerBody(),
              ],
            ),),]
    );
  }


  Widget _mapView() {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _markerPins,
      // polylines: _polyLines,
      mapType: MapType.normal,
      initialCameraPosition: _cameraPositionOnMap,
      onMapCreated: (GoogleMapController mapController) {
        _googleMapController = mapController;

        // Locate source location in map
        _locateSourceLocationInMap();

        // Set source and dest markers
        _setMarkerPins(sourceLocation, destLocation);

        // Extract poly line points between source and dest
        // Set the poly lines in map
        // _getLocationPointsBetweenSourceAndDest();
      },
    );
  }

  Widget _topSpotLocatedView() {
    return   Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Color.fromRGBO(30, 144, 255, 1),


        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("T LOCATED!",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0)),
              Container(
                width: 320,
                child: Text("Accept within 30 seconds before loosing it.",textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 19.0)),
              ),
            ]),
      ),

    );
  }

  Widget _buildTimerBody() {
    return   Center(

      child: CircularCountDownTimer(
        // Countdown duration in Seconds
        duration: 30,

        // Controller to control (i.e Pause, Resume, Restart) the Countdown
        controller: _controller1,

        // Width of the Countdown Widget
        width: MediaQuery.of(context).size.width / 1.3,

        // Height of the Countdown Widget
        height: MediaQuery.of(context).size.height / 2,

        // Default Color for Countdown Timer
        ringColor: Colors.green,

        // Filling Color for Countdown Timer
        fillColor: Colors.black87,

        // Background Color for Countdown Widget
        backgroundColor: null,

        // Border Thickness of the Countdown Circle
        strokeWidth: 8.0,

        // Begin and end contours with a flat edge and no extension
        strokeCap: StrokeCap.butt,

        // Text Style for Countdown Text
        textStyle: TextStyle(
            fontSize: 50.0, color: Colors.green, fontWeight: FontWeight.bold),

        // Optional [String] to format Countdown Text
        // textFormat: CountdownTextFormat.HH_MM_SS,

        // true for reverse countdown (max to 0), false for forward countdown (0 to max)
        isReverse: false,

        // true for reverse animation, false for forward animation
        isReverseAnimation: false,

        // Optional [bool] to hide the [Text] in this widget.
        isTimerTextShown: false,

        // Optional [bool] to handle timer start
        // autoStart: true,

        // Function which will execute when the Countdown Starts
        // onStart: () {
        //   // Here, do whatever you want
        //   print('Countdown Started');
        // },

        // Function which will execute when the Countdown Ends
        onComplete: () {
          // Here, do whatever you want
          print('Countdown Ended');
          setState(() {

            Navigator.of(context).pop();

          });

        },
      ),
    );
  }


  _locateSourceLocationInMap() {
    // Updated Camera Position
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
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
    // destination pin
    // _markerPins.add(Marker(
    //     markerId: MarkerId('dest_marker'),
    //     position: LatLng(destLocation.destLatitude, destLocation.destLongitude),
    //     icon:
    //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));
  }

  // _getLocationPointsBetweenSourceAndDest() async {
  //   await PolylinePoints()
  //       .getRouteBetweenCoordinates(
  //     WordConstants.GOOGLE_PLACES_API_KEY, // Google Maps API Key
  //     PointLatLng(
  //         sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
  //     PointLatLng(destLocation.destLatitude, destLocation.destLongitude),
  //     travelMode: TravelMode.driving,
  //   )
  //       .then((polyLineResult) {
  //     if (polyLineResult.points.isNotEmpty) {
  //       polyLineResult.points.forEach((PointLatLng point) {
  //         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
  //       });
  //     }
  //   });
  //
  //   setState(() {
  //     Polyline polyline = Polyline(
  //         polylineId: PolylineId("poly"),
  //         color: Colors.black87,
  //         points: polylineCoordinates,
  //         geodesic: true,
  //         width: 4);
  //     _polyLines.add(polyline);
  //   });
  // }




/*
  Widget _bottomView() {
    return Visibility(
        visible : _visibleMange,
        child :Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),

              child: Container(
                height: 150,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    // color: Color.fromRGBO(30, 144, 255, 1),
                    color: Colors.white,

                    border: Border.all(color: Colors.white,width: 0)
                ),
                child :   Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 300,
                      child: Text('Have you spot your provider!',style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 17.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87),textAlign: TextAlign.center,),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                          new InkWell(
                            onTap: () {
                              setState(() {
                                _visibleMange = false;
                              });
                            },
                            child: new Container(
                              width: 150.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.black87,
                                borderRadius: new BorderRadius.circular(0.0),
                              ),
                              child: new Center(child: new Text('Yes', style: new TextStyle(    fontFamily: 'Roboto',
                                  fontSize: 16.0, color: Colors.white,fontWeight: FontWeight.w700,letterSpacing: 1.0),),),
                            ),
                          ),
                          new InkWell(
                            onTap: () {
                              setState(() {
                                _visibleMange = false;

                              });

                            },
                            child: new Container(
                              width: 150.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: new BorderRadius.circular(0.0),
                              ),
                              child: new Center(child: new Text('No', style: new TextStyle(fontFamily: 'Roboto',
                                  fontSize: 16.0, color: Colors.black87,fontWeight: FontWeight.w700,letterSpacing: 1.0 ),),),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
*/

/*
  Widget _topView() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 120,
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(00)),
            color: Color.fromRGBO(30, 144, 255, 1),
            border: Border.all(color: Colors.white,width: 0)
        ),

        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child :       new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width : 35,
                child: Icon(
                  Icons.car_repair,
                  color: Colors.white,
                  size: 30.0,

                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(height: 15),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                    children: [
                      Container(
                        width: 240,
                        child: Text( '${'Car no : '}',style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 19.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                      ),
                      Text( " Logesh sharma",style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))
                    ],
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
*/
}

class HomeTest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeTestState();
}

class HomeTestState extends State<HomeTest> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offset;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: RaisedButton(
              child: Text('Show / Hide'),
              onPressed: () {
                switch (controller.status) {
                  case AnimationStatus.completed:
                    controller.reverse();
                    break;
                  case AnimationStatus.dismissed:
                    controller.forward();
                    break;
                  default:
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: offset,
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: CircularProgressIndicator(),
              ),
            ),
          )
        ],
      ),
    );
  }
}



typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size oldSize;
  final OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key key,
    @required this.onChange,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }
}




/*
*
* import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/message_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';
import 'package:spocate/core/constants/word_constants.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/routes/route_constants.dart';
import 'package:spocate/screens/home_screen/view/seeker/route_destination/repo/source_and_dest.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String routeValue;
  BuildContext providerContext;
  bool isActionSteam = false;

  @override
  void initState() {
    _navigateRespectiveScreens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                WordConstants.SPLASH_APP_NAME,
                style: TextStyle(
                    fontSize: SizeConstants.SIZE_46,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.primaryColor),
              ),
              SizedBox(
                height: SizeConstants.SIZE_16,
              ),
              Text(
                WordConstants.SPLASH_APP_LOGO_SUBTITLE,
                style: TextStyle(
                    fontSize: SizeConstants.SIZE_26,
                    fontWeight: FontWeight.w400,
                    color: ColorConstants.primaryColor),
              )
            ],
          ),
        ));
  }

  _navigateRespectiveScreens() async {
    await SharedPrefs().getNotificationToken().then((value) {
      print("Notification Token $value");
    });

/*    await SharedPrefs().getUserId().then((userIdValue) {
      if(userIdValue!="null" && userIdValue.isNotEmpty){
        routeValue = RouteConstants.ROUTE_HOME_SCREEN;
      }else{
        routeValue = RouteConstants.ROUTE_LOGIN;
      }
    }).then((value){
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, routeValue);
      });
    });*/

    await SharedPrefs().getUserId().then((userIdValue) async {
      if (userIdValue != "null" && userIdValue.isNotEmpty) {
        AwesomeNotifications()
            .actionStream
            .listen((receivedNotification) async {
          isActionSteam = true;
          print("receivedNotification.body = ${receivedNotification.body}");
          switch (receivedNotification.body) {
            case MessageConstants.MESSAGE_SPOT_LOCATED_MESSAGE:
              {
                routeValue = RouteConstants.ROUTE_ROUTE_TO_DESTINATION;
                break;
              }

            case MessageConstants.MESSAGE_SEEKER_NOTIFICATION_SPOT_REACHED:
              {
                routeValue = RouteConstants.ROUTE_ROUTE_TO_SPOT;
                break;
              }

            case MessageConstants.MESSAGE_SPOT_CONFIRMED:
              {
                // state.isSpotted == "1" --> Logic need to discuss
                routeValue =
                    RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION;
                break;
              }

            case MessageConstants.PROVIDER_NOTIFICATION_SEEKER_ON_WAY:
              {
                routeValue = RouteConstants.ROUTE_WAIT_FOR_SEEKER;
                break;
              }
            case MessageConstants.PROVIDER_NOTIFICATION_SEEKER_REACHED:
              {
                routeValue = RouteConstants.ROUTE_WAIT_FOR_SEEKER;
                break;
              }
          }
        });
        Future.delayed(Duration(seconds: 2), () async {
          if (!isActionSteam) {
            print("Spot Located ROUTE_HOME_SCREEN");
            Navigator.pushReplacementNamed(
                context, RouteConstants.ROUTE_HOME_SCREEN);
          } else if (routeValue == RouteConstants.ROUTE_ROUTE_TO_DESTINATION) {
            print("Spot Located ROUTE_ROUTE_TO_DESTINATION");
            await SharedPrefs().getSourceLocationDetails().then((
                sourceDetails) async {
              await SharedPrefs().getDestLocationDetails().then((
                  destDetails) {
                print(
                    "sourceDetails = ${sourceDetails.sourceLongitude}");
                print("destDetails   = ${destDetails.destAddress}");
                print("destDetails   = ${destDetails.destLatitude}");
                print("destDetails   = ${destDetails.destLongitude}");
                if(mounted){
                  Navigator.pushReplacementNamed(
                      context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION,
                      arguments:
                      SourceAndDest(
                          sourceLocation: sourceDetails,
                          destLocation: destDetails)
                  );
                }
              });
            });
            // if (mounted) {
            //   Navigator.pushReplacementNamed(
            //       context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION);
            // }
          } else if (routeValue == RouteConstants.ROUTE_ROUTE_TO_SPOT) {
            print("Spot Located ROUTE_ROUTE_TO_DESTINATION");
            Navigator.pushNamedAndRemoveUntil(
                context, RouteConstants.ROUTE_ROUTE_TO_SPOT, (route) => false);
          } else if (routeValue ==
              RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION) {
            Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.ROUTE_SEEKER_WAIT_PROVIDER_CONFIRMATION,
                    (route) => false);
          } else if (routeValue == RouteConstants.ROUTE_WAIT_FOR_SEEKER) {
            print("Spot Located ROUTE_WAIT_FOR_SEEKER");
            SharedPrefs().getSourceLocationDetails().then((
                sourceDetails)  {
              print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
              print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
              Navigator.pushReplacementNamed(
                  context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                  arguments: sourceDetails);
            });
            // Navigator.pushNamedAndRemoveUntil(context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,(route) => false);
          } else if (routeValue == RouteConstants.ROUTE_WAIT_FOR_SEEKER) {
            print("Spot Located ROUTE_WAIT_FOR_SEEKER");
            SharedPrefs().getSourceLocationDetails().then((
                sourceDetails)  {
              print("sourceLatitude   = ${sourceDetails.sourceLatitude}");
              print("sourceLongitude   = ${sourceDetails.sourceLongitude}");
              Navigator.pushReplacementNamed(
                  context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                  arguments: sourceDetails);
            });
            // Navigator.pushNamedAndRemoveUntil(context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,(route) => false);
          }
        });
      } else {
        print("else ROUTE_LOGIN");
        // routeValue = RouteConstants.ROUTE_LOGIN;
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, RouteConstants.ROUTE_LOGIN);
        });
      }
    });
  }
}

/* NotificationNavigation.getCommonNotificationMessage().then((commonNotificationMessage) async {
             if(commonNotificationMessage != null){
               print("Notification commonNotificationMessage  $commonNotificationMessage");
               switch(commonNotificationMessage){
                 case "Spot Located" : {
                   print("Spot Located ROUTE_ROUTE_TO_DESTINATION");

                  await SharedPrefs().getSourceLocationDetails().then((sourceDetails) async {
                   await  SharedPrefs().getDestLocationDetails().then((destDetails) {
                       Navigator.pushReplacementNamed(context, RouteConstants.ROUTE_ROUTE_TO_DESTINATION , arguments:
                       SourceAndDest(
                           sourceLocation: sourceDetails,
                           destLocation: destDetails)
                       );
                     });
                   });
                 }
                 break;
                 case "Another car is on the way to park on your spot. Appreciate if you wait for few minutes. A minutes of wait will get you 1 credit." : {
                   print("Spot Located ROUTE_WAIT_FOR_SEEKER");
                   await SharedPrefs().getSourceLocationDetails().then((sourceDetails) async {
                     Navigator.pushReplacementNamed(
                         context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                         arguments: sourceDetails );
                   });
                 }
                 break;
                 case "Have you spot your seeker?" : {
                   print("Spot Located ROUTE_WAIT_FOR_SEEKER");
                   await SharedPrefs().getSourceLocationDetails().then((sourceDetails) async {
                     Navigator.pushReplacementNamed(
                         context, RouteConstants.ROUTE_WAIT_FOR_SEEKER,
                         arguments: sourceDetails );
                   });
                 }
                 break;
                 default :{
                   print("Spot Located ROUTE_HOME_SCREEN");
                   Navigator.pushReplacementNamed(context,  RouteConstants.ROUTE_HOME_SCREEN);
                 }
                 break;
               }
             }else {
               print("Spot Located ROUTE_HOME_SCREEN");
               Navigator.pushReplacementNamed(context,  RouteConstants.ROUTE_HOME_SCREEN);
             }
           });
         });

      } else {
         print("else ROUTE_LOGIN");
         // routeValue = RouteConstants.ROUTE_LOGIN;
         Future.delayed(Duration(seconds: 2), () {
           Navigator.pushReplacementNamed(context,  RouteConstants.ROUTE_LOGIN);
         });
       }
    });2021-08-10 15:03:09.221441+0530 Runner[848:96229] flutter: Sending stream as location 13.065032890086579
2021-08-10 15:03:09.225769+0530 Runner[848:96229] flutter: getBackgroundLocationScreen location screen shared pref = 2
2021-08-10 15:03:09.226103+0530 Runner[848:96229] flutter: callback getBackgroundLocationScreen 2
2021-08-10 15:03:09.226609+0530 Runner[848:96229] flutter: BG Dest userIdValue 48
2021-08-10 15:03:09.227014+0530 Runner[848:96229] flutter: BG Dest destLocation Instance of 'ProviderData'
2021-08-10 15:03:09.227334+0530 Runner[848:96229] flutter: ################### SpotAccepted 19.896809334552536 #######################
2021-08-10 15:03:09.227573+0530 Runner[848:96229] flutter: BG Dest isParsingRequired 2
2021-08-10 15:03:09.229701+0530 Runner[848:96229] flutter: appState shared pref = 1
2021-08-10 15:03:09.230664+0530 Runner[848:96229] flutter: appState shared pref = seeker_state_spot_reached
2021-08-10 15:03:09.234832+0530 Runner[848:96229] [VERBOSE-2:ui_dart_state.cc(213)] Unhandled Exception: MissingPluginException(No implementation found for method LocatorPlugin.isServiceRunning on channel app.rekab/locator_plugin)
#0      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:154:7)
<asynchronous suspension>
#1      BackgroundLocator.isServiceRunning (package:background_locator/background_locator.dart:59:13)
<asynchronous suspension>
#2      BGServiceHandler.stopBackgroundService (package:spocate/location/bg_service_handler.dart:79:24)
<asynchronous suspension>
2021-08-10 15:03:10.905413+0530 Runner[848:95667] flutter: initState HomeScreen
2021-08-10 15:03:10.924 Runner[848/0x104233880] [lvl=3] +[GMSx_CCTClearcutUploader crashIfNecessary] Multiple instances of CCTClearcutUploader were instantiated. Multiple uploaders function correctly but have an adverse affect on battery performance due to lock contention.
2021-08-10 15:03:11.484998+0530 Runner[848:95667] flutter: onResume
2021-08-10 15:03:11.485778+0530 Runner[848:95667] flutter: userId => 48
2021-08-10 15:03:11.486036+0530 Runner[848:95667] flutter: appState shared pref = 0
2021-08-10 15:03:11.486335+0530 Runner[848:95667] flutter: appState shared pref = false
2021-08-10 15:03:11.486951+0530 Runner[848:95667] flutter: background location screen shared pref = 0
2021-08-10 15:03:11.490533+0530 Runner[848:95667] flutter: appState shared pref =
2021-08-10 15:03:11.491462+0530 Runner[848:95667] flutter: onStop true
2021-08-10 15:03:11.496041+0530 Runner[848:95667] flutter: check PermissionForApp value LocationPermission.always
2021-08-10 15:03:11.512424+0530 Runner[848:95667] flutter: check Device Location value true
2021-08-10 15:03:11.513485+0530 Runner[848:96229] flutter: ***********Dispose callback handler
2021-08-10 15:03:11.516283+0530 Runner[848:95667] flutter: Webservice action http://113.193.25.21:710/api/Login/DashboardDetails
2021-08-10 15:03:11.516368+0530 Runner[848:95667] flutter: Webservice requestJson {"Id":"48"}
2021-08-10 15:03:11.557931+0530 Runner[848:95667] flutter: Webservice response {"UserInfo":{"Id":48,"Username":"8608922177","Name":"lokesh","Email":"sharma@gmail.com","Mobile":"8608922177","CarNumber":"2456","Status":"Active","IsParked":1,"DeviceID":"4998B297-78D9-463F-A64A-F511A8E72282"},"CarInfo":{"Mode":null,"Id":150,"Customerid":48,"Carmake":"TESLA","Carmodel":"Model X","Carcolor":"Silver","Carnumber":"1234","Isdefault":1},"SupportEmail":"carpal@openwavecomp.in","SupportMobile":"9860001234","Status":"Success","Message":"Data fetched Successfully"}
2021-08-10 15:03:11.558106+0530 Runner[848:95667] flutter: Webservice responseJson {UserInfo: {Id: 48, Username: 8608922177, Name: lokesh, Email: sharma@gmail.com, Mobile: 8608922177, CarNumber: 2456, Status: Active, IsParked: 1, DeviceID: 4998B297-78D9-463F-A64A-F511A8E72282}, CarInfo: {Mode: null, Id: 150, Customerid: 48, Carmake: TESLA, Carmodel: Model X, Carcolor: Silver, Carnumber: 1234, Isdefault: 1}, SupportEmail: carpal@openwavecomp.in, SupportMobile: 9860001234, Status: Success, Message: Data fetched Successfully}
2021-08-10 15:03:11.564784+0530 Runner[848:95667] flutter: Home Success 1234
2021-08-10 15:03:11.565039+0530 Runner[848:95667] flutter: Home Success 8608922177
2021-08-10 15:03:11.675199+0530 Runner[848:95667] flutter: sourceAddress 1/13, Sterling Road 3rd Street, Nungambakkam, Chennai, 600034, Tamil Nadu, India
2021-08-10 15:03:11.675345+0530 Runner[848:95667] flutter: sourcePostalCode 600034
2021-08-10 15:03:13.125264+0530 Runner[848:95667] [VERBOSE-2:ui_dart_state.cc(213)] Unhandled Exception: This widget has been unmounted, so the State no longer has a context (and should be considered defunct).
Consider canceling any active work during "dispose" or using the "mounted" getter to determine if the State is still active.
#0      State.context.<anonymous closure> (package:flutter/src/widgets/framework.dart:909:9)
#1      State.context (package:flutter/src/widgets/framework.dart:915:6)
#2      _SeekerWaitingState._navigateToHome.<anonymous closure> (package:spocate/screens/home_screen/view/seeker/spotted_provider_thanks/seeker_waiting.dart:44:11)
#3      new Future.delayed.<anonymous closure> (dart:async/future.dart:315:39)
#4      _rootRun (dart:async/zone.dart:1420:47)
#5      _CustomZone.run (dart:async/zone.dart:1328:19)
#6      _CustomZone.runGuarded (dart:async/zone.dart:1236:7)
#7      _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:1276:23)
#8      _rootRun (dart:async/zone.dart:1428:13)
#9      _CustomZone.run (dart:async/zone.dart:1328:19)
#10     _CustomZone.bindCallback.<anonymous closure> (dart:async/zone.dart:1260:23)
#11     Timer._createTimer.<anonymous closure> (dart:async-patch/timer_patch.dart:18:15)
#12     _Timer._runTimers (dart:isolate-patch/timer_impl.dart:395:19)
#13     _Timer._handleMessage (dart:isolate-patch/timer_impl.dart:426:5)
#14     _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:184:12)

            */

*
* */