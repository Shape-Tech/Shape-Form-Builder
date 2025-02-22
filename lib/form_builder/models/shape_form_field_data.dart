import 'package:equatable/equatable.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question.dart';

// ignore: must_be_immutable
class ShapeFormData extends Equatable {
  List<ShapeFormQuestion> questions;

  ShapeFormData({
    required this.questions,
  });

  @override
  List<Object?> get props => [questions];
}
