import 'package:flutter/material.dart';
import 'pp_colors.dart';

abstract class PpTypo {
  static const _fontFamily = 'Inter';

  // All the textstyles for the Inter family

  static const TextStyle header = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 20,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle cardHeader = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle tileHeader = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodySemibold = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyRegular = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle date = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.gray,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle buttonText = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.7,
  );

  static const TextStyle cardButtonText = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.dark,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.7,
  );

  static const TextStyle buttonTextWhite = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.white,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.7,
  );

  static const TextStyle hintText = TextStyle(
    // fontFamily: _fontFamily,
    color: PpColors.gray,
    fontSize: 14,
    fontStyle: FontStyle.italic,
  );
}
