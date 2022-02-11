import 'package:flutter/material.dart';
import 'package:spocate/core/constants/color_constants.dart';
import 'package:spocate/core/constants/size_constants.dart';

class AppStyles {
  AppStyles._();

/* Text Style */
  static TextStyle buttonFillTextStyle() {
    return TextStyle(color: Colors.white, fontSize: 20.0);
  }

  static TextStyle buttonOutlineTextStyle() {
    return TextStyle(color: Colors.black, fontSize: 20.0);
  }

  static TextStyle blackTextStyle() {
    return TextStyle(color: Colors.black87, fontSize: 20.0);
  }

  static TextStyle otpTextStyle() {
    return TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
        fontSize: SizeConstants.SIZE_32);
  }

  /* Button Style */
  static ButtonStyle buttonFillStyle() {
    return ButtonStyle(
        padding:
            MaterialStateProperty.all(EdgeInsets.all(SizeConstants.SIZE_12)),
        backgroundColor:
            MaterialStateProperty.all<Color>(ColorConstants.primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
                side: BorderSide(color: ColorConstants.primaryColor))));
  }

  static ButtonStyle buttonOutlineStyle() {
    return ButtonStyle(
        padding:
            MaterialStateProperty.all(EdgeInsets.all(SizeConstants.SIZE_12)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
                side: BorderSide(color: ColorConstants.primaryColor))));
  }

  static ButtonStyle buttonLoginSocialStyle() {
    return ButtonStyle(
        alignment: Alignment.topLeft,
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.black87, fontSize: 14.0,fontWeight: FontWeight.w500)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(SizeConstants.SIZE_10),
                side: BorderSide(color: Colors.black87, width: 1.0, style: BorderStyle.none)
            )));
  }

  // Add Car

  static TextStyle textLabelStyle() {
    return TextStyle(
        fontSize: SizeConstants.SIZE_20, fontWeight: FontWeight.w500);
  }

  static TextStyle buttonTextLabelStyle() {
    return TextStyle(
        color: ColorConstants.primaryColor,
        fontSize: SizeConstants.SIZE_18,
        fontWeight: FontWeight.w400);
  }

  static InputDecoration textInputDecorationStyle([String hintText]) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12.0),
      fillColor: Colors.black12,
      filled: true,
      border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
      hintText: hintText
    );
  }

  static InputDecoration addCarTextInputDecorationStyle([String hintText]) {
    return  InputDecoration(
        contentPadding: EdgeInsets.all(12.0),
        fillColor: Colors.black12,
        filled: true,
        border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0.7)),
        hintText: hintText);
  }

  static ButtonStyle buttonOutlineGreyStyle() {
    return ButtonStyle(
        padding:
            MaterialStateProperty.all(EdgeInsets.all(SizeConstants.SIZE_12)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white54),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(SizeConstants.SIZE_8),
                side: BorderSide(color: ColorConstants.primaryColor))));
  }


  static ButtonStyle buttonMyCarListDefaultStyle() {
    return ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.white70, fontSize: 14.0,fontWeight: FontWeight.w500)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(SizeConstants.SIZE_10),
            )));
  }

  static ButtonStyle buttonMyCarListMakeDefaultStyle() {
    return ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(color: Colors.black87, fontSize: 14.0,fontWeight: FontWeight.w500)),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(SizeConstants.SIZE_10),
              side: BorderSide(color: Colors.black87, width: 1.0, style: BorderStyle.none)
            )));
  }



  static InputDecoration textInputSearchDecorationStyle2() {
    return InputDecoration(
      contentPadding: EdgeInsets.all(12.0),
      filled: true,
      border: OutlineInputBorder(borderSide: BorderSide(width: 0.5)),
    );
  }

  static TextStyle questionListItemQuestionTextStyle() {
    return TextStyle(
        color: Colors.black87, fontSize: 18.0, fontWeight: FontWeight.w400);
  }

  static TextStyle questionListItemAnswerTextStyle() {
    return TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black87);
  }

  // Seeker waiting for provider confirmation
  static TextStyle seekerWaitingTitleTextStyle() {
    return TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 36.0);
  }
  static TextStyle seekerWaitingUserMessageTextStyle() {
    return TextStyle(color: Colors.black87,fontWeight: FontWeight.w500,fontSize: 26.0);
  }
}
