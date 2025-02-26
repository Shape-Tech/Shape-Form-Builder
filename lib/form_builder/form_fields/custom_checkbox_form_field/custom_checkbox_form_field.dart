import 'package:flutter/material.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomCheckboxFormField extends FormField<bool> {
  CustomCheckboxFormField({
    Widget? title,
    String? description,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    bool autovalidate = false,
    ShapeFormStyling? styling,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<bool> state) {
              return Container(
                decoration: styling?.containerDecoration ??
                    BoxDecoration(
                      color: styling?.background ?? Colors.white,
                      border: Border.all(
                          color: styling?.border ?? Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10),
                    ),
                child: CheckboxListTile(
                  title: title,
                  value: state.value,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: styling?.spacingMedium ?? padding,
                      vertical: styling?.spacingSmall ?? spacing),
                  activeColor: styling?.secondary ?? FormColors.secondary,
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
                            style:
                                TextStyle(color: styling?.error ?? Colors.red),
                          ),
                        )
                      : description != null
                          ? Text(description)
                          : null,
                ),
              );
            });
}
