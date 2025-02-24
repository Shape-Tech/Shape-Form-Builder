import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormFieldTheme extends Equatable {
  TextStyle? successText;
  TextStyle? errorText;
  TextStyle? questionText;
  TextStyle? descriptionText;
  TextStyle? hintText;
  Color? buttonColor;
  double? borderRadius;

  FormFieldTheme({
    this.successText,
    this.errorText,
    this.questionText,
    this.descriptionText,
    this.hintText,
    this.buttonColor,
    this.borderRadius,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
