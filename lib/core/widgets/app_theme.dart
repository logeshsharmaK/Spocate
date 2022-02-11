import 'package:flutter/material.dart';
import 'package:spocate/core/constants/color_constants.dart';

// please refer for back navigation
// https://stackoverflow.com/questions/49894406/how-to-implement-swipe-to-previous-page-in-flutter

class AppTheme {
  AppTheme._();

  static ThemeData applyAppTheme(BuildContext context) {
    return ThemeData(
      // By default the font family is Roboto for android and San Fransisco for iOS
      fontFamily: 'Roboto',
        primaryColor: ColorConstants.primaryColor,
        primaryColorDark: ColorConstants.primaryColorDark,
        accentColor: ColorConstants.accentColor,
        backgroundColor: ColorConstants.backgroundColor,
        scaffoldBackgroundColor: ColorConstants.scaffoldBackgroundColor,
        dividerColor: ColorConstants.dividerColor,
        errorColor: ColorConstants.errorColor,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: ColorConstants.primaryColor,
            displayColor: ColorConstants.primaryColor)
    );
  }

  ButtonThemeData applyButtonTheme() {
    return ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        buttonColor: ColorConstants.primaryColorDark);
  }

  TextSelectionThemeData applyTextSelectionTheme() {
    return TextSelectionThemeData();
  }

  TextTheme applyTextTheme() {
    return TextTheme();
  }

  DialogTheme applyDialogTheme() {
    return DialogTheme();
  }

  RadioTheme applyRadioTheme() {}

  SnackBarThemeData applySnackBarTheme() {
    return SnackBarThemeData();
  }
}
