import "package:flutter/material.dart";

class CustomPopUpMenuItem {
  dynamic value;
  String? label;
  String? description;
  Widget? customDisplay;

  CustomPopUpMenuItem(
      {required this.value, this.label, this.description, this.customDisplay});
}
