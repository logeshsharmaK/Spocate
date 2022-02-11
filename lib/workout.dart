import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';

import 'core/constants/app_bar_constants.dart';
import 'core/constants/enum_constants.dart';
import 'core/constants/size_constants.dart';
import 'core/widgets/app_widgets.dart';

class Workout extends StatefulWidget {
  const Workout({Key key}) : super(key: key);

  @override
  _WorkoutState createState() => _WorkoutState();
}

class _WorkoutState extends State<Workout> {
  TextEditingController _searchTextController = TextEditingController();

  GoogleMapController _googleMapController;
  CameraPosition _cameraPositionOnMap;
  Set<Marker> _markerPins = {};

  SourceLocation sourceLocation = SourceLocation();

  @override
  void initState() {
    // Initial Camera Position
    _cameraPositionOnMap =
        CameraPosition(target: LatLng(40.740156, -73.997701), zoom: 18.0);

    _getSourceDetails();

    super.initState();
  }

  _getSourceDetails() {
    SharedPrefs().getSourceLocationDetails().then((sourceLocationValue) {
      // print("sourceLocation ${sourceLocation.sourceLatitude}");
      // print("sourceLocation ${sourceLocation.sourceLongitude}");
      setState(() {
        // sourceLocation = sourceLocationValue;
        sourceLocation.sourceLatitude = 40.740156;
        sourceLocation.sourceLongitude = -73.997701;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppWidgets.showAppBar(
                AppBarConstants.APP_BAR_ROUTE_TO_DESTINATION),
            body: _buildAddressAndCarView(context)
            // Container(child: Center(child: ElevatedButton(child: Text("Show Alert"),onPressed: () async {
            //   showAcceptIgnoreDialog(context);
            // },)),),

        ));
  }

  Widget _socialLoginButton(){
    return ElevatedButton.icon(
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('assets/images/google.png',
            height: 32.0, width: 32.0),
      ),
      label: Text('Sign in with Google',style: TextStyle(color: Colors.black87,fontSize: 16.0),),);
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: new Text("Alert!!"),
          content: new Text("You are awesome!"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
   showAcceptIgnoreDialog(
    BuildContext context,
  ) async {
     await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
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
        });
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
        });
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
        Column(
          children: [
            _buildTopView(),
            Expanded(child: _buildMiddleView()),
            _buildBottomView()
          ],
        ),
      ],
    ));
  }


  Widget _buildFinalView(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0)),
              semanticContainer: true,
              clipBehavior: Clip.antiAlias,
              child:  Stack(
                  children : [
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
                  ]

            ))
    );
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

        _setMarkerPins(sourceLocation);
      },
    );
  }

  Widget _buildTopView() {
    return Container(
      child: Center(
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
                    "YOUR SPOT LOCATED!",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 22),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                  child: Text(
                    "Accept with in 30 seconds before loosing it",
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
      ),
    );
  }

  Widget _buildMiddleView() {
    return Center(
      child: CircularCountDownTimer(
        duration: 30,
        width: 200,
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
          padding: const EdgeInsets.fromLTRB(16.0,16.0,16.0,32.0),
          child: Container(
              height: 45,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(DialogAction.Yes);
                  },
                  child: Text(
                    "Accept",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ))),
        )),
        Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0,16.0,16.0,32.0),
          child: Container(
              height: 45,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(DialogAction.No);
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      side: BorderSide(width: 1.5, color: Colors.black87)),
                  child: Text(
                    "Ignore",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ))),
        )),
      ],
    );
  }

  _setMarkerPins(SourceLocation sourceLocation) {
    _markerPins.add(Marker(
        markerId: MarkerId('source_marker'),
        position: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)));

    // Update Camera position to locate our current position in Map
    _cameraPositionOnMap = CameraPosition(
        target: LatLng(
            sourceLocation.sourceLatitude, sourceLocation.sourceLongitude),
        zoom: 18.0);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(_cameraPositionOnMap));
  }
}

Widget _buildAddressAndCarView(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(8.0),
    decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(00)),
        color: Colors.blue,
        border: Border.all(color: Colors.white, width: 0)),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: Column(
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
                              left: 16, right: 16.0, top: 16.0),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8.0, top: 16.0),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                            size: 40.0,
                          ),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text(
                                '11 4th Cross Street, Village High Road, Sholinganallur, Chennai, Tamilnadu',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 3,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('30 Mins',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600,
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
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('500 Mts',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Divider(
                height: 1.0,
                color: Colors.white,
                thickness: 1.0,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16.0, top: 16.0),
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
                          Text('Car Model : Benz Car Model ',
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                          SizedBox(height: 12),
                          Text('Car Make :  Benz Car Make',
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "TN12BB1234",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
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
                                      "BLUE",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildThanksView() {
  return Container(
    child: Center(
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
                  "Thanks!",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 22),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                child: Text(
                  "We will notify you of  Spot availability once you near your destination",
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
    ),
  );
}

Widget customAlertDialog() {
  return Container(
    color: Colors.black26,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 150.0,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                    child: Text(
                  "Have you spot the provider?",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500),
                )),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 45,
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.black),
                            onPressed: () {},
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ))),
                  )),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                side: BorderSide(
                                    width: 1.5, color: Colors.black87)),
                            child: Text(
                              "No",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ))),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _carInfoWidget() {
  return Container(
    height: 130.0,
    margin: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
        SizeConstants.SIZE_16, SizeConstants.SIZE_12),
    padding: EdgeInsets.fromLTRB(SizeConstants.SIZE_16, SizeConstants.SIZE_16,
        SizeConstants.SIZE_16, SizeConstants.SIZE_12),
    decoration: BoxDecoration(
      color: Colors.blue[200],
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "PFS TRAILERS",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18.0),
          textAlign: TextAlign.start,
          maxLines: 1,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text("PFS TRAILERS",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            textAlign: TextAlign.start,
            maxLines: 1),
        SizedBox(
          height: 8.0,
        ),
        Divider(
          height: 1.0,
          color: Colors.black87,
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "TN12BB1234",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: Colors.black87,
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "BLUE",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _dummyWidget() {
  return Container(
    child: Row(
      children: [
        RadioListTile(
          title: Text(
            "No",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          activeColor: Colors.black,
          value: 0,
          groupValue: 0,
          onChanged: (int value) {
            print("No Clicked");
          },
        ),
        SizedBox(
          width: 32.0,
        ),
        RadioListTile(
          title: Text(
            "Yes",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          activeColor: Colors.black,
          value: 0,
          groupValue: 0,
          onChanged: (int value) {
            print("No Clicked");
          },
        ),
      ],
    ),
  );
}

// Container(
// color: Colors.black,
// child: Padding(
// padding: const EdgeInsets.all(SizeConstants.SIZE_16),
// child: Container(
// decoration: BoxDecoration(
// color: Colors.white,
// border: Border.all(color: Colors.white),
// borderRadius: BorderRadius.all(Radius.circular(8.0))),
// child: TextFormField(
// autocorrect: false,
// style: TextStyle(
// fontSize: SizeConstants.SIZE_20,
// color: Colors.black,
// backgroundColor: Colors.white),
// controller: _searchTextController,
// decoration: InputDecoration(
// contentPadding: EdgeInsets.all(12.0),
// prefixIcon: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Icon(Icons.search),
// ),
// prefixIconConstraints: BoxConstraints(
// minWidth: 10,
// minHeight: 10,
// ),
// suffixIcon: InkWell(
// child: Padding(
// padding: const EdgeInsets.all(8.0),
// child: Icon(Icons.close),
// ),
// onTap: () {
// _searchTextController.text = "";
// print("Close Clicked");
// },
// ),
// suffixIconConstraints: BoxConstraints(
// minWidth: 10,
// minHeight: 10,
// ),
// // border: OutlineInputBorder(borderSide: BorderSide(width: 0.0),borderRadius: BorderRadius.all(Radius.circular(8.0)))
// ),
// ),
// ),
// ),
// )
