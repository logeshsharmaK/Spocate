import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/enum_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';

class AppWidgets {
  AppWidgets._();

  static Widget showAppBar(String title) {
    return AppBar(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 20.0, color: Colors.white),
        ),
        backgroundColor: ColorConstants.primaryColor,
        brightness: Brightness.dark);
  }

  static showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      duration: const Duration(seconds: 3),
    ));
  }

  static ScaffoldFeatureController showSnackBarWithEndListener(BuildContext context, String message) {
  var snackBarController =  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$message'),
      duration: const Duration(seconds: 3),
    ));
  return snackBarController;
  }

  static showProgressBar() {
    EasyLoading.show();
  }

  static hideProgressBar() {
    EasyLoading.dismiss();
  }

/*  static Future<DialogAction> showAlertDialog(
    BuildContext context,
    String title,
    String body, {
    DialogActionControl actionControl, //  show,  hide
    String negativeActionText,
    String positiveActionText,
  }) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: ColorConstants.primaryColorDark, fontSize: 22.0),
            ),
            content: Text(
              body,
              style: TextStyle(
                  color: ColorConstants.primaryColorDark, fontSize: 22.0),
            ),
            actions: <Widget>[
              actionControl != null
                  ? actionControl == DialogActionControl.HIDE
                      ? TextButton(
                          onPressed: () {},
                          child: null,
                        )
                      : TextButton(
                          onPressed: () =>
                              Navigator.of(context).pop(DialogAction.No),
                          child: Text(
                            negativeActionText != null
                                ? negativeActionText.isNotEmpty
                                    ? negativeActionText
                                    : 'No'
                                : 'No',
                            style: TextStyle(
                                color: ColorConstants.primaryColorDark,
                                fontSize: 18.0),
                          ),
                        )
                  : TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(DialogAction.No),
                      child: Text(
                        'No',
                        style: TextStyle(
                            color: ColorConstants.primaryColorDark,
                            fontSize: 18.0),
                      )),
              TextButton(
                onPressed: () => Navigator.of(context).pop(DialogAction.Yes),
                child: Text(
                  positiveActionText != null
                      ? positiveActionText.isNotEmpty
                          ? positiveActionText
                          : 'Yes'
                      : 'Yes',
                  style: TextStyle(
                      color: ColorConstants.primaryColorDark, fontSize: 18.0),
                ),
              ),
            ],
          );
        });
    return (action != null) ? action : DialogAction.No;
  }*/

  static Future<DialogAction> showCustomDialogYesNo(
    BuildContext context,
    String message, {
    String negativeActionText,
    String positiveActionText,
  }) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsets.all(SizeConstants.SIZE_16),
                    child: Center(
                        child: Text(
                      "$message",
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
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                                onPressed: () {
                                  Navigator.of(context).pop(DialogAction.Yes);
                                },
                                child: Text(
                                  positiveActionText != null
                                      ? positiveActionText.isNotEmpty
                                          ? positiveActionText
                                          : 'Yes'
                                      : 'Yes',
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
                                onPressed: () {
                                  Navigator.of(context).pop(DialogAction.No);
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    side: BorderSide(
                                        width: 1.5, color: Colors.black87)),
                                child: Text(
                                  negativeActionText != null
                                      ? negativeActionText.isNotEmpty
                                          ? negativeActionText
                                          : 'No'
                                      : 'No',
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
          );
        });
    return (action != null) ? action : DialogAction.Cancel;
  }

  static Future<DialogAction> showCustomDialogOK(
    BuildContext context,
    String message, {
    String negativeActionText,
    String positiveActionText,
  }) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                    padding: const EdgeInsets.all(SizeConstants.SIZE_16),
                    child: Center(
                        child: Text(
                      "$message",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                  Container(
                      height: 45,
                      width: 90,
                      margin: EdgeInsets.all(SizeConstants.SIZE_16),
                      child: ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () {
                            Navigator.of(context).pop(DialogAction.OK);
                          },
                          child: Text(
                            "OK",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          )))
                ],
              ),
            ),
          );
        });
    return (action != null) ? action : DialogAction.Cancel;
  }
}
