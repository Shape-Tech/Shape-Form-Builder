import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomPhoneNumberField extends FormField<String> {
  CustomPhoneNumberField({
    required PhoneController phoneController,
    bool? isRequired,
    Function(String?)? onSaved,
    ShapeFormStyling? styling,
    Function(String?)? onChanged,
    String? label,
    String? description,
    PhoneNumber? originalValue,
    OptionalRequiredChip? optionalRequiredChip,
  }) : super(
            onSaved: onSaved,
            builder: (FormFieldState<String> state) {
              PhoneNumberInputValidator? _getValidator(BuildContext context) {
                List<PhoneNumberInputValidator> validators = [];
                bool mobileOnly = false;
                if (mobileOnly) {
                  validators.add(PhoneValidator.validMobile(context));
                } else {
                  validators.add(PhoneValidator.valid(context));
                }
                if (isRequired == true) {
                  validators.add(PhoneValidator.required(context,
                      errorText: "Phone number is required"));
                }

                return validators.isNotEmpty
                    ? PhoneValidator.compose(validators)
                    : null;
              }

              return Container(
                decoration: styling?.containerDecoration ??
                    BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid,
                          color: styling?.border ?? Colors.grey,
                          width: 2),
                      color: styling?.background ?? Colors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(styling?.borderRadiusMedium ?? 10)),
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
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (label != null) ...[
                                Text(label!,
                                    style: styling?.bodyTextBoldStyle,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis),
                                Gap(styling?.spacingSmall ?? spacing),
                              ],
                              if (description != null) ...[
                                Text(description!,
                                    style: styling?.bodyTextStyle,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis),
                                Gap(styling?.spacingSmall ?? spacing),
                              ],
                            ],
                          ),
                        ),
                        Gap(styling?.spacingMedium ?? padding),
                        if (optionalRequiredChip != null &&
                            optionalRequiredChip.showChip == true) ...[
                          optionalRequiredChip.getChip(styling),
                        ],
                      ],
                    ),
                    PhoneFormField(
                      controller: phoneController,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      countrySelectorNavigator:
                          const CountrySelectorNavigator.dialog(width: 500),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: styling?.border ?? Colors.grey,
                              width: 1,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                              color: styling?.border ?? Colors.grey,
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
                            color: styling?.textDisabled ?? Colors.grey),
                        fillColor: styling?.background ?? Colors.white,
                        // hintText: hintText ?? '',
                      ),
                      enabled: true,
                      validator: _getValidator(state.context),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        if (onChanged != null) {
                          onChanged(value.international);
                        }
                      },
                    ),
                    if (originalValue != null) ...[
                      Gap(spacing),
                      Text(
                        "Original Value: ${originalValue.international}",
                        style: styling?.captionStyle,
                      ),
                    ],
                  ],
                ).allPadding(styling?.spacingMedium ?? padding),
              );
            });
}
