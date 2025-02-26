import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu_item.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomDropDownFormField extends FormField<CustomPopUpMenuItem> {
  CustomDropDownFormField({
    FormFieldSetter<CustomPopUpMenuItem>? onSaved,
    FormFieldValidator<CustomPopUpMenuItem>? validator,
    CustomPopUpMenuItem? initialValue,
    CustomPopUpMenuItem? originalValue,
    String? hintText,
    String? label,
    required List<CustomPopUpMenuItem> menuItems,
    ShapeFormStyling? styling,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            builder: (FormFieldState<dynamic> state) {
              return Container(
                decoration: styling?.containerDecoration ??
                    BoxDecoration(
                        border: Border.all(
                            style: BorderStyle.solid,
                            color: styling?.border ?? Colors.grey,
                            width: 2),
                        color: styling?.background ?? Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(
                            styling?.borderRadiusMedium ?? 10))),
                child: LayoutBuilder(
                  builder: (layoutBuilderContext, constraints) {
                    return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (label != null) ...[
                                Text(label),
                                Gap(spacing),
                              ],
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
                                styling: styling,
                              ),
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
                                        child: Text(
                                            "Originally Selected: ${originalValue.value}"),
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
                        ]);
                  },
                ).allPadding(styling?.spacingMedium ?? padding),
              );
            });
}
