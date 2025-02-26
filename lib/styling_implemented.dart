import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

ShapeFormStyling styleImplemented = ShapeFormStyling(
  // Colors
  primary: Color.fromARGB(255, 85, 0, 255),
  secondary: Color.fromARGB(255, 255, 0, 230),
  secondaryLight: Color.fromARGB(255, 255, 170, 247),
  background: Color.fromARGB(255, 255, 255, 255),

  // Text Sizes
  heading1: 32.0,
  body: 16.0,

  // Spacing
  spacingSmall: spacing,
  spacingMedium: padding,

  // Text Styles
  heading1Style: TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 85, 0, 255),
    fontFamily: "Arial Black",
  ),

  bodyTextStyle: TextStyle(
    fontSize: 16.0,
    color: Color(0xFF212121),
  ),

  // Button Styles
  primaryButtonStyle: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 85, 0, 255)),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    )),
  ),

  secondaryButtonStyle: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 255, 0, 230)),
    foregroundColor: WidgetStateProperty.all(Colors.white),
    padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    )),
  ),

  outlinedButtonStyle: ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(Color.fromARGB(255, 255, 0, 230)),
    padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
    shape: WidgetStateProperty.all(RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: Color.fromARGB(255, 255, 0, 230)),
    )),
  ),

  textButtonStyle: ButtonStyle(
    backgroundColor:
        WidgetStateProperty.all(const Color.fromARGB(92, 33, 0, 98)),
    foregroundColor: WidgetStateProperty.all(Color.fromARGB(255, 255, 0, 230)),
    padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 10, vertical: 8)),
  ),

  // Container Decoration
  containerDecoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: FormColors.border),
  ),
);
