import 'dart:async';

import 'package:flutter/material.dart';
import 'package:spocate/data/local/shared_prefs/shared_prefs.dart';

class ScreenStateCheck extends StatefulWidget {
  @override
  _ScreenStateCheckState createState() => _ScreenStateCheckState();
}

class _ScreenStateCheckState extends State<ScreenStateCheck> with WidgetsBindingObserver {

  String initScreenState = "0";
  String resumeScreenState = "0";
  String spScreenState = "0";

  @override
  void initState() {
    print("AppLifecycleState initState ");
    WidgetsBinding.instance.addObserver(this);
    SharedPrefs().getSpState().then((spState) {
      print("getSpState spState $spState");
      spScreenState = spState;

    });

    initScreenState = "1";

    super.initState();
  }

  void getAppState(){

    print("App State spScreenState $spScreenState");
    print("App State initScreenState $initScreenState");
    print("App State resumeScreenState $resumeScreenState");


    if(spScreenState=="0" && initScreenState=="1" && resumeScreenState=="0"){
      print("App State - Foreground Access");
    }else   if(spScreenState=="0" && initScreenState=="1" && resumeScreenState=="1"){
      print("App State - Background Access");
    }else   if(spScreenState=="1" && initScreenState=="1" && resumeScreenState=="0"){
      print("App State - Terminated Access");
    }else   if(spScreenState=="1" && initScreenState=="1" && resumeScreenState=="1"){
      print("App State - Background and Notification Clicked");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          child: Text("Screen State Check"),
          onPressed: ()  {
            getAppState();
          },
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("AppLifecycleState resumed ");
      resumeScreenState="1";

    } else if (state == AppLifecycleState.paused) {
      print("AppLifecycleState paused ");
    }
    else if (state == AppLifecycleState.inactive) {
      print("AppLifecycleState inactive ");
    }
    else if (state == AppLifecycleState.detached) {
      print("AppLifecycleState detached ");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
