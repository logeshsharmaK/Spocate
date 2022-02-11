import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:spocate/routes/route_constants.dart';

class OnPauseResumeCheck extends StatefulWidget {
  @override
  _OnPauseResumeCheckState createState() => _OnPauseResumeCheckState();
}

class _OnPauseResumeCheckState extends State<OnPauseResumeCheck> {
  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      child: Container(
        child: Center(
          child: ElevatedButton(
            child: Text("First screen"),
            onPressed: () {
              Navigator.pushNamed(context,
                  RouteConstants.ROUTE_QUESTIONS_LIST);
            },
          ),
        ),
      ),
      onFocusLost: () {
        print("FocusDetector OnPause");
      },
      onFocusGained: () {
        print("FocusDetector OnResume");
      },
      onVisibilityGained: (){
        print("FocusDetector onVisibilityGained");
      },
      onVisibilityLost: (){
        print("FocusDetector onVisibilityLost");
      },
    );
  }
}
