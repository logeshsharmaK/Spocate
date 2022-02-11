import 'dart:async';

import 'package:flutter/material.dart';

class DistanceCheck extends StatefulWidget {
  @override
  _DistanceCheckState createState() => _DistanceCheckState();
}

class _DistanceCheckState extends State<DistanceCheck> {
  double updatedTempValue = 10000.0;
  double distanceInMeter =9000;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
          child: Text("Execute Now"),
          onPressed: ()  {
            distanceInMeter = distanceInMeter -500;
            // print("Execution distanceInMeter $distanceInMeter");
            print("Execution distanceInMeter $distanceInMeter");
            print("Execution return ${distanceBasedLocationUpdateAPI()}");

            // if (distanceInMeter > 5000.toDouble() &&
            //     distanceInMeter < 10000.toDouble()) {
            //   if (distanceInMeter < updatedTempValue) {
            //     print("Execution 1 before  $updatedTempValue");
            //     updatedTempValue = distanceInMeter;
            //     print("Execution 1 after $updatedTempValue");
            //     return false;
            //   }else{
            //     updatedTempValue = updatedTempValue - 2000;
            //     return true;
            //   }
            // } else if (distanceInMeter > 1000.toDouble() &&
            //     distanceInMeter < 5000.toDouble()) {
            //   if (distanceInMeter < updatedTempValue) {
            //     print("Execution 2 before  $updatedTempValue");
            //     updatedTempValue = distanceInMeter;
            //     print("Execution 2 after $updatedTempValue");
            //     return false;
            //   }else{
            //     updatedTempValue = updatedTempValue - 1000;
            //     return true;
            //   }
            // } else if (distanceInMeter > 100.toDouble() &&
            //     distanceInMeter < 1000.toDouble()) {
            //   if (distanceInMeter < updatedTempValue) {
            //     print("Execution 3 before  $updatedTempValue");
            //     updatedTempValue = distanceInMeter;
            //     print("Execution 3 after $updatedTempValue");
            //     return false;
            //   }else{
            //     updatedTempValue = updatedTempValue - 100;
            //     return true;
            //   }
            // }else {
            //   return false;
            // }



            // Timer.periodic(Duration(seconds: 5), (Timer t) {
            //   for(int i=0;i<10;i++){
            //     distanceBasedLocationUpdateAPI().then((value) {
            //       print("Execution value ${value}");
            //     });
            //   }
            // });
            // Future.delayed(Duration(seconds: 3),(){
            //   for(int i=0;i<10;i++){
            //     distanceBasedLocationUpdateAPI().then((value) {
            //       print("Execution value ${value}");
            //     });
            //   }
            // });
            },
        ),
      ),
    );
  }
   distanceBasedLocationUpdateAPI()  {

    

    if (distanceInMeter > 5000.toDouble() &&
        distanceInMeter < 10000.toDouble()) {
      if (distanceInMeter < updatedTempValue) {
        print("Execution 1 before  $updatedTempValue");
        updatedTempValue = updatedTempValue - 2000;
        print("Execution 1 after $updatedTempValue");
        return true;
      }else{
        return false;
      }
    } else if (distanceInMeter > 1000.toDouble() &&
        distanceInMeter < 5000.toDouble()) {
      if (distanceInMeter < updatedTempValue) {
        print("Execution 2 before  $updatedTempValue");
        updatedTempValue = updatedTempValue - 1000;
        print("Execution 2 after $updatedTempValue");
        return true;
      }else{
        return false;
      }
    } else if (distanceInMeter > 100.toDouble() &&
        distanceInMeter < 1000.toDouble()) {
      if (distanceInMeter < updatedTempValue) {
        print("Execution 3 before  $updatedTempValue");
        updatedTempValue = updatedTempValue - 100;
        print("Execution 3 after $updatedTempValue");
        return true;
      }else{
        return false;
      }
    }else {
      return false;
    }
  }
}
