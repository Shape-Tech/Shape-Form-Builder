import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';
import 'package:shape_form_builder/form_builder/models/shape_form.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class ShapeFormBuilder extends StatefulWidget {
  final ShapeForm formConfig;
  final Widget? loadingWidget;
  final ShapeFormStyling? styling;

  const ShapeFormBuilder({
    super.key,
    required this.formConfig,
    this.loadingWidget,
    this.styling,
  });

  @override
  State<ShapeFormBuilder> createState() => _ShapeFormBuilderState();
}

class _ShapeFormBuilderState extends State<ShapeFormBuilder> {
  bool _isProcessing = false;
  String? _errorMessage;
  final _formKey = GlobalKey<FormState>();

  List<Widget> generateFormFields(ShapeForm form) {
    List<Widget> children = [];
    for (var question in form.formData.questions) {
      Widget? newQuestionUI = question.buildUI(
        onResponseChanged: () {
          setState(() {}); // Rebuild the form when any response changes
        },
        styling: widget.styling,
      );
      if (newQuestionUI != null) {
        children.add(newQuestionUI);
        children.add(Gap(widget.styling?.spacingSmall ?? spacing));
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return widget.loadingWidget ?? const CircularProgressIndicator();
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            ...generateFormFields(widget.formConfig),
            ElevatedButton(
              onPressed: () {
                debugPrint("Pressed");
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Validation Passed')),
                  );
                  widget.formConfig.submit();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Validation Failed')),
                  );
                }
              },
              child: Container(
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      widget.formConfig.submitButtonText ?? "Submit Form",
                    ),
                  )),
              style: widget.styling?.primaryButtonStyle ??
                  FormButtonStyles.primaryButton,
            ),
            if (widget.formConfig.errorWidget != null)
              widget.formConfig.errorWidget!,
          ],
        ),
      );
    }
  }
}
