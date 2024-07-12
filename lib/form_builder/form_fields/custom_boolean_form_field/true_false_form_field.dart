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
    bool? disableDecoration,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          builder: (FormFieldState<bool> state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Container(
                decoration: disableDecoration == true
                    ? null
                    : const BoxDecoration(
                        boxShadow: [
                            BoxShadow(
                                color: const Color(0x4D1E1E1E),
                                offset: Offset.zero,
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                      if (state.value == null ||
                                          state.value == false)
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            child: Text(trueLabel),
                                            onPressed: (() {
                                              state.setState(() {
                                                state.setValue(true);
                                                initialValue = true;
                                              });
                                              onSaved(true);
                                            }),
                                          ),
                                        ),
                                      if (state.value == true)
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            child: Text(trueLabel),
                                            onPressed: (() {
                                              state.setState(() {
                                                state.setValue(true);
                                                initialValue = true;
                                              });
                                              onSaved(true);
                                            }),
                                          ),
                                        ),
                                      Container(width: 10),
                                      if (state.value == null ||
                                          state.value == true)
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            child: Text(falseLabel),
                                            onPressed: (() {
                                              state.setState(() {
                                                state.setValue(false);
                                                initialValue = false;
                                              });
                                              onSaved(false);
                                            }),
                                          ),
                                        ),
                                      if (state.value == false)
                                        Expanded(
                                          flex: 1,
                                          child: ElevatedButton(
                                            child: Text(falseLabel),
                                            onPressed: (() {
                                              state.setState(() {
                                                state.setValue(false);
                                                initialValue = false;
                                              });
                                              onSaved(false);
                                            }),
                                          ),
                                        ),
                                    ],
                                  )),
                              if (originalValue != null)
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
              ),
            );
          },
        );
}
