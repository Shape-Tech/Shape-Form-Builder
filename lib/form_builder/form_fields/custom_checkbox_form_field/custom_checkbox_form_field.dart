import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';

class CustomCheckboxFormField extends FormField<bool> {
  CustomCheckboxFormField(
      {Widget? title,
      String? description,
      FormFieldSetter<bool>? onSaved,
      FormFieldValidator<bool>? validator,
      bool initialValue = false,
      bool autovalidate = false})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CheckboxListTile(
                  contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  title: title,
                  value: state.value,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      state.setState(() {
                        state.setValue(newValue);
                      });
                      if (onSaved != null) {
                        onSaved(newValue);
                      }
                    }
                  },
                  subtitle: state.hasError
                      ? Builder(
                          builder: (BuildContext context) => Text(
                            state.errorText ?? "",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : description != null
                          ? Text(description)
                          : null,
                ).horizontalPadding(20).verticalPadding(10),
              );
            });
}
