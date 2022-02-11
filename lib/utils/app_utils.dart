import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:spocate/core/constants/word_constants.dart';

class AppUtils {
  // Singleton approach
  static final AppUtils _instance = AppUtils._internal();

  factory AppUtils() => _instance;

  AppUtils._internal();

  static Future<String> getAppVersionCode() async {
    String projectCode;
    try {
      projectCode = await GetVersion.projectCode;
    } on PlatformException {
      projectCode = 'Failed to get build number.';
    }
    return projectCode;
  }

  static String getPlatform() {
    try {
      if (Platform.isAndroid) {
        return WordConstants.PLATFORM_ANDROID;
      } else if (Platform.isIOS) {
        return WordConstants.PLATFORM_IOS;
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return "";
  }

  static bool isValidString(String value) {
    RegExp regex = new RegExp(WordConstants.PATTERN_ONLY_TEXT);
    return (!regex.hasMatch(value)) ? false : true;
  }
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  static bool isValidNumber(String value) {
    RegExp regex = new RegExp(WordConstants.PATTERN_ONLY_NUMBER);
    return (!regex.hasMatch(value)) ? false : true;
  }
  static bool isValidEmail(String value) {
    RegExp regex = new RegExp(WordConstants.PATTERN_EMAIL);
    return (!regex.hasMatch(value)) ? false : true;
  }
  static bool isValidPhone(String value) {
    return (value.length>=10 && value.length<=15) ? true : false;
  }
  static showKeyboard(BuildContext context){
    FocusScope.of(context).requestFocus(new FocusNode());
  }
  static hideKeyboard(BuildContext context){
    FocusScope.of(context).unfocus();
  }
}
