import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomTextFormField extends FormField<String> {
  final String? originalValue;

  CustomTextFormField({
    TextEditingController? textfieldController,
    String? hintText,
    String? label,
    String? description,
    String? initalText,
    this.originalValue,
    FormFieldValidator<String>? validator,
    bool? secure,
    TextInputType? textInputType,
    List<TextInputFormatter>? textInputFormatter,
    int? maxLines,
    Function(dynamic value)? onSaved,
    TextInputAction? textInputAction,
    Function(String value)? onChanged,
    ShapeFormStyling? styling,
    bool? showOuterContainer = true,
  }) : super(
            initialValue: initalText,
            validator: validator,

            // onSaved: onSaved,
            builder: (FormFieldState<String> state) {
              return Container(
                decoration: showOuterContainer == true
                    ? styling?.containerDecoration ??
                        BoxDecoration(
                            border: Border.all(
                                style: BorderStyle.solid,
                                color: styling?.border ?? Colors.grey,
                                width: 2),
                            color: styling?.background ?? Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(
                                styling?.borderRadiusMedium ?? 10)))
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (showOuterContainer == true && label != null) ...[
                      Text(label!, style: styling?.bodyTextBoldStyle),
                      Gap(styling?.spacingSmall ?? spacing),
                      if (description != null) ...[
                        Text(description!, style: styling?.bodyTextStyle),
                        Gap(styling?.spacingSmall ?? spacing),
                      ],
                    ],
                    TextFormField(
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
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: styling?.error ?? Colors.red,
                              width: 1,
                            )),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: styling?.error ?? Colors.red,
                              width: 1,
                            )),
                        errorStyle: TextStyle(
                          color: styling?.error ?? Colors.red,
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color: styling?.textSecondary ?? Colors.grey),
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
                    ),
                    if (originalValue != null) ...[
                      Gap(styling?.spacingSmall ?? spacing),
                      Text(
                        "Original Value: " + originalValue!,
                        style: styling?.captionStyle,
                      ),
                    ],
                  ],
                ).allPadding(showOuterContainer == true
                    ? (styling?.spacingMedium ?? padding)
                    : 0),
              );
            });
}
