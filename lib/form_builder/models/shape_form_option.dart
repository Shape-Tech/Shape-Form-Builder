import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShapeFormOption extends Equatable {
  int? id;
  String label;
  Icon? icon;
  String? description;
  Object? object;
  dynamic selectedValue;
  bool? isSelected;

  ShapeFormOption({
    this.id,
    required this.label,
    this.icon,
    this.description,
    this.object,
    this.selectedValue,
    this.isSelected,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
