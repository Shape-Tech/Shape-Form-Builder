import 'package:equatable/equatable.dart';
import 'package:shape_form_builder/form_builder/models/form_field_theme.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_data.dart';

// ignore: must_be_immutable
class ShapeForm extends Equatable {
  int? formId;
  String? formName;
  ShapeFormData formData;
  Function(ShapeFormData)? onSubmission;
  FormFieldTheme? theme;

  ShapeForm({
    this.formId,
    this.formName,
    required this.formData,
    this.onSubmission,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
