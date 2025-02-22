import 'package:flutter/material.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu_item.dart';

class CustomDropDownFormField extends FormField<CustomPopUpMenuItem> {
  CustomDropDownFormField({
    FormFieldSetter<CustomPopUpMenuItem>? onSaved,
    FormFieldValidator<CustomPopUpMenuItem>? validator,
    CustomPopUpMenuItem? initialValue,
    CustomPopUpMenuItem? originalValue,
    String? hintText,
    required List<CustomPopUpMenuItem> menuItems,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<dynamic> state) {
              return LayoutBuilder(
                builder: (layoutBuilderContext, constraints) {
                  return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomPopUpMenu(
                              hintText: hintText,
                              maxWidth: constraints.maxWidth,
                              menuItems: menuItems,
                              initialSelection: initialValue,
                              onOptionSelected: (newOption) {
                                state.setValue(newOption);
                                if (onSaved != null) {
                                  onSaved(newOption);
                                }
                              },
                            ),
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
                      ]);
                },
              );
            });
}
