import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              child: Padding(
                padding: EdgeInsets.all(styling?.spacingMedium ?? 20.0),
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(label),
                        if (labelDescription != null)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(labelDescription)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    if (state.value != true)
                                      Expanded(
                                        flex: 1,
                                        child: buildNonSelectedButton(
                                            true, trueLabel),
                                      ),
                                    if (state.value == true)
                                      Expanded(
                                        flex: 1,
                                        child: buildSelectedButton(
                                            true, trueLabel),
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
                                        child: buildSelectedButton(
                                            false, falseLabel),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text("Originally Selected: "),
                                    ),
                                    if (originalValue == true)
                                      ElevatedButton(
                                        child: Text(trueLabel),
                                        onPressed: (() {}),
                                        style: styling?.secondaryButtonStyle ??
                                            FormButtonStyles.secondaryButton,
                                      ),
                                    if (originalValue == false)
                                      ElevatedButton(
                                        child: Text(falseLabel),
                                        onPressed: (() {}),
                                        style: styling?.secondaryButtonStyle ??
                                            FormButtonStyles.secondaryButton,
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
                      ]),
                ),
              ),
            );
          },
        );
}
