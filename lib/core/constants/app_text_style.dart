import 'package:flutter/cupertino.dart';

class AppTextStyle {
  AppTextStyle._();
  static extraLight({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-extra-light",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w100,
      );
  static thin({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-thin",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w200,
      );
  static light({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-light",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
      );
  static regular({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-regular",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
      );
  static medium({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-medium",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      );
  static semiBold({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-semi-bold",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      );
  static bold({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-bold",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
      );
  static extraBold({Color? color, double? fontSize}) => TextStyle(
        fontFamily: "Poppins-extra-bold",
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
      );
}
