import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/form_builder/models/shape_form.dart';

class ShapeFormBuilder extends StatelessWidget {
  ShapeForm formConfig;
  Widget? loadingWidget;

  ShapeFormBuilder({
    super.key,
    required this.formConfig,
    this.loadingWidget,
  });

  List<Widget> generateFormFields(ShapeForm form) {
    List<Widget> children = [];
    form.formData.questions.forEach((question) {
      Widget? newQuestionUI = question.buildUI();
      if (newQuestionUI != null) {
        children.add(newQuestionUI);
        children.add(Gap(10));
      }
    });
    return children;
  }

  bool _isProcessing = false;
  String? _errorMessage;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (_isProcessing) {
      return loadingWidget ?? CircularProgressIndicator();
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            ...generateFormFields(formConfig),
            ElevatedButton(
                onPressed: () {
                  debugPrint("Pressed");
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation Passed')),
                    );
                    formConfig.submit();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Validation Failed')),
                    );
                  }
                },
                child: Text("Validate")),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  _errorMessage ?? "",
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      );
    }
  }
}
