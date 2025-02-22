import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';
import 'package:shape_form_builder/form_builder/models/shape_form.dart';

class ShapeFormBuilder extends StatefulWidget {
  final ShapeForm formConfig;
  final Widget? loadingWidget;

  const ShapeFormBuilder({
    super.key,
    required this.formConfig,
    this.loadingWidget,
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
    form.formData.questions.forEach((question) {
      Widget? newQuestionUI = question.buildUI(
        onResponseChanged: () {
          setState(() {}); // Rebuild the form when any response changes
        },
      );
      if (newQuestionUI != null) {
        children.add(newQuestionUI);
        children.add(const Gap(10));
      }
    });
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
              child: const Text("Validate"),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  _errorMessage ?? "",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      );
    }
  }
}
