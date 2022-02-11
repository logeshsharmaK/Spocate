import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/spotted_provider/repo/spotted_provider_repo.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_bloc.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_event.dart';
import 'package:spocate/screens/home_screen/view/seeker/accepted_spot/time_and_distance/bloc/time_and_distance_state.dart';
import 'package:spocate/screens/home_screen/view/source_location.dart';
import 'package:spocate/utils/network_utils.dart';

import 'core/constants/app_bar_constants.dart';
import 'core/constants/enum_constants.dart';
import 'core/constants/message_constants.dart';
import 'core/constants/size_constants.dart';
import 'core/widgets/app_widgets.dart';
import 'data/remote/web_constants.dart';
import 'data/remote/web_service.dart';

class DistanceWorkout extends StatefulWidget {
  const DistanceWorkout({Key key}) : super(key: key);

  @override
  _DistanceWorkoutState createState() => _DistanceWorkoutState();
}

class _DistanceWorkoutState extends State<DistanceWorkout> {
  String distanceValue = "0.9 km";
  String durationValue = "10 mins";

  double distance = 10.0;
  double duration = 10.0;

  TimeAndDistanceBloc _timeAndDistanceBloc;

  @override
  void initState() {
    super.initState();
    // updateTimeAndDistancePeriodic();

    final SpottedProviderRepository repository = SpottedProviderRepository(
        webservice: Webservice(), sharedPrefs: SharedPrefs());
    _timeAndDistanceBloc = TimeAndDistanceBloc(repository: repository);

    updateGoogleDistanceAndTime();
  }

  void updateTimeAndDistanceOneTime() {
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        distanceValue = "$distance km";
        durationValue = "$duration mins";
      });
    });
  }

  void updateTimeAndDistancePeriodic() {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        distance = distance + 10;
        duration = duration + 10;
        distanceValue = "$distance km";
        durationValue = "$duration mins";
      });
    });
  }

  void updateGoogleDistanceAndTime(){
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      _getTravelTimeAndDistance("13.073105313834224,80.23804245826982", "12.900816783823423,80.22705613103712");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(body: MultiBlocListener(listeners: [
      BlocListener<TimeAndDistanceBloc, TimeAndDistanceState>(
          cubit: _timeAndDistanceBloc,
          listener: (context, state) {
            _blocTimeAndDistanceListener(context, state);
          }),
    ], child: _buildTimeAndDistanceView(context))));
  }

  Widget _buildTimeAndDistanceView(BuildContext context) {
    return Container(
      height: 110.0,
      padding: EdgeInsets.all(16.0),
      color: Colors.amber,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  "Distance",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "$distanceValue",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  "Duration",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  "$durationValue",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _getTravelTimeAndDistance(
      String sourceLatLong, String destLatLong) async {
    await NetworkUtils().checkInternetConnection().then((isInternetAvailable) {
      if (isInternetAvailable) {
        _timeAndDistanceBloc.add(TimeAndDistanceTriggerEvent(
            sourceLatLong: sourceLatLong, destLatLong: destLatLong,travelMode: WebConstants.DISTANCE_MODE_DRIVING));
      } else {
        AppWidgets.showSnackBar(
            context, MessageConstants.MESSAGE_INTERNET_CHECK);
      }
    });
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
      setState(() {
        durationValue =
            state.timeAndDistanceResponse.rows[0].elements[0].duration.text;
        distanceValue =
            state.timeAndDistanceResponse.rows[0].elements[0].distance.text;
        // _submitUpdateLocation();
      });
    }
  }
}
