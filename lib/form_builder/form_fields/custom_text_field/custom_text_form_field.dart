import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  }) : super(
            initialValue: initalText,
            validator: validator,

            // onSaved: onSaved,
            builder: (FormFieldState<String> state) {
              return TextFormField(
                initialValue: initalText,
                controller: textfieldController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  filled: true,
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
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
