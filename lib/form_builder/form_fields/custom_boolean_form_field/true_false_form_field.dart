import 'package:flutter/material.dart';

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
              );
            }

            Widget buildNonSelectedButton(bool value, String label) {
              return TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.grey.shade100),
                ),
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
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
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
                                    Container(width: 10),
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
                                      ),
                                    if (originalValue == false)
                                      ElevatedButton(
                                        child: Text(falseLabel),
                                        onPressed: (() {}),
                                      ),
                                  ],
                                ),
                              ),
                            if (state.hasError == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(state.errorText!,
                                    style: TextStyle(color: Colors.red)),
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
