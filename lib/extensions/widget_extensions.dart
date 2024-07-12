import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget verticalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  Widget horizontalPadding(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  Widget allPadding(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  Widget addTooltip(String message) {
    return Tooltip(
      message: message,
      preferBelow: true,
      waitDuration: Duration(seconds: 1),
      showDuration: Duration(seconds: 2),
      padding: EdgeInsets.all(10),
      child: this,
    );
  }
}
