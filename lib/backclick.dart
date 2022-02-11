import 'package:flutter/material.dart';
import 'package:spocate/core/widgets/app_widgets.dart';

import 'core/constants/enum_constants.dart';

class BackClick extends StatefulWidget {
  @override
  _BackClickState createState() => _BackClickState();
}

class _BackClickState extends State<BackClick> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          body: Container(
        child: Center(
          child: Text("Center text"),
        ),
      )),
      onWillPop: _executePopClick,
    );
  }

  Future<bool> _executePopClick(){
    AppWidgets.showCustomDialogYesNo(
        context, "Do you want to cancel this trip?")
        .then((value) async {
      if (value == DialogAction.Yes) {
        Navigator.of(context).pop();

      }else if (value == DialogAction.No) {

      }
    });
  }
}
