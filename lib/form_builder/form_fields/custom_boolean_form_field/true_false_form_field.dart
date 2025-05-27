import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class TrueFalseFormField extends FormField<bool> {
  TrueFalseFormField({
    required String label,
    String? labelDescription,
    required String trueLabel,
    required String falseLabel,
    required FormFieldSetter<bool> onSaved,
    required FormFieldValidator<bool> validator,
    bool? initialValue,
    bool? originalValue,
    ShapeFormStyling? styling,
    OptionalRequiredChip? optionalRequiredChip,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            Widget buildSelectedButton(bool value, String label) {
              return ElevatedButton(
                // style: ButtonStyle(
                //   backgroundColor: WidgetStatePropertyAll(Colors.green),
                // ),
                child: Text(label),
                onPressed: (() {
                  state.setState(() {
                    state.setValue(value);
                    initialValue = value;
                  });
                  onSaved(value);
                }),
                style: styling?.secondaryButtonStyle ??
                    FormButtonStyles.secondaryButton,
              );
            }

            Widget buildNonSelectedButton(bool value, String label) {
              return TextButton(
                style: styling?.outlinedButtonStyle ??
                    FormButtonStyles.outlinedButton,
                child: Text(label),
                onPressed: (() {
                  state.setState(() {
                    state.setValue(value);
                    initialValue = value;
                  });
                  onSaved(value);
                }),
              );
            }

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
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(label,
                                  style: styling?.bodyTextBoldStyle,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis),
                              if (labelDescription != null)
                                Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    child: Text(labelDescription,
                                        style: styling?.bodyTextStyle,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                        ),
                        if (optionalRequiredChip != null &&
                            optionalRequiredChip.showChip == true) ...[
                          Gap(styling?.spacingMedium ?? spacing),
                          optionalRequiredChip.getChip(styling),
                        ],
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                if (state.value != true)
                                  Expanded(
                                    flex: 1,
                                    child:
                                        buildNonSelectedButton(true, trueLabel),
                                  ),
                                if (state.value == true)
                                  Expanded(
                                    flex: 1,
                                    child: buildSelectedButton(true, trueLabel),
                                  ),
                                Gap(styling?.spacingMedium ?? 10),
                                if (state.value != false)
                                  Expanded(
                                    flex: 1,
                                    child: buildNonSelectedButton(
                                        false, falseLabel),
                                  ),
                                if (state.value == false)
                                  Expanded(
                                    flex: 1,
                                    child:
                                        buildSelectedButton(false, falseLabel),
                                  ),
                              ],
                            )),
                        if (originalValue != null)
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Originally Selected: ${originalValue == true ? trueLabel : falseLabel}",
                                    style: styling?.captionStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (state.hasError == true)
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(state.errorText!,
                                style: TextStyle(
                                    color: styling?.error ?? Colors.red)),
                          )
                      ],
                    ),
                  ]).allPadding(styling?.spacingMedium ?? padding),
            );
          },
        );
}
