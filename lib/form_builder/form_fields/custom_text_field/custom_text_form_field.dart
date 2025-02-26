import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomTextFormField extends FormField<String> {
  CustomTextFormField({
    TextEditingController? textfieldController,
    String? hintText,
    String? initalText,
    FormFieldValidator<String>? validator,
    bool? secure,
    TextInputType? textInputType,
    List<TextInputFormatter>? textInputFormatter,
    int? maxLines,
    Function(dynamic value)? onSaved,
    TextInputAction? textInputAction,
    Function(String value)? onChanged,
    ShapeFormStyling? styling,
  }) : super(
            initialValue: initalText,
            validator: validator,

            // onSaved: onSaved,
            builder: (FormFieldState<String> state) {
              return TextFormField(
                controller: textfieldController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: styling?.spacingMedium ?? padding,
                      vertical: styling?.spacingMedium ?? padding),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10.0),
                      borderSide: BorderSide(
                        color: styling?.secondary ?? FormColors.primary,
                        width: 1,
                      )),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10.0),
                      borderSide: BorderSide(
                        color: styling?.border ?? FormColors.border,
                        width: 1,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 10.0),
                      borderSide: BorderSide(
                        color: styling?.border ?? FormColors.border,
                        width: 1,
                      )),
                  filled: true,
                  hintStyle:
                      TextStyle(color: styling?.textSecondary ?? Colors.grey),
                  fillColor: styling?.background ?? Colors.white,
                  focusColor: styling?.secondary ?? Colors.black,
                  hintText: hintText ?? '',
                ),
                obscureText: secure ?? false,
                keyboardType: textInputType,
                onChanged: (value) {
                  state.setValue(value);
                  if (onSaved != null) {
                    onSaved(value);
                  }
                  if (onChanged != null) {
                    onChanged(value);
                  }
                },
                validator: validator,
                inputFormatters: textInputFormatter,
                maxLines: maxLines ?? 1,
                textInputAction: textInputAction,
                onFieldSubmitted: onSaved,
              );
            });
}
