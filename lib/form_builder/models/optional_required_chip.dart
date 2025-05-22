import 'package:flutter/material.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class OptionalRequiredChip {
  final bool showChip;
  final bool isOptional;

  OptionalRequiredChip({required this.showChip, required this.isOptional});

  Widget getChip(ShapeFormStyling? styling) {
    return Chip(
      label: Text(isOptional ? "Optional" : "Required"),
      backgroundColor: Colors.white,
      side: BorderSide(
          color: isOptional
              ? Colors.grey.shade300
              : styling?.secondary ?? Colors.grey.shade900),
      labelStyle: styling?.captionStyle.copyWith(
        color: isOptional
            ? Colors.grey.shade500
            : styling?.secondary ?? Colors.grey.shade900,
      ),
    );
  }
}
