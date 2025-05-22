import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomCheckboxFormField extends FormField<bool> {
  final bool? originalValue;

  CustomCheckboxFormField({
    Widget? title,
    Widget? description,
    FormFieldSetter<bool>? onSaved,
    FormFieldValidator<bool>? validator,
    bool initialValue = false,
    this.originalValue,
    bool autovalidate = false,
    ShapeFormStyling? styling,
    OptionalRequiredChip? optionalRequiredChip,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CheckboxListTile(
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
                                style: TextStyle(
                                    color: styling?.error ?? Colors.red),
                              ),
                            )
                          : description != null
                              ? description
                              : null,
                    ),
                    if (originalValue != null ||
                        optionalRequiredChip != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          if (originalValue != null) ...[
                            Text(
                              "Original Value: " + originalValue.toString(),
                              style: styling?.captionStyle,
                            ),
                          ],
                          Gap(styling?.spacingMedium ?? padding),
                          if (optionalRequiredChip != null &&
                              optionalRequiredChip.showChip == true) ...[
                            optionalRequiredChip.getChip(styling),
                          ],
                        ],
                      ).horizontalPadding(padding),
                      Gap(styling?.spacingMedium ?? padding),
                    ],
                  ],
                ),
              );
            });
}
