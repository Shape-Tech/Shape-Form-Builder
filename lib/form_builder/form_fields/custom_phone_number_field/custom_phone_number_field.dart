import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class CustomPhoneNumberField extends FormField<String> {
  CustomPhoneNumberField({
    required PhoneController phoneController,
    bool? isRequired,
    Function(String?)? onSaved,
    ShapeFormStyling? styling,
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

              return PhoneFormField(
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
                  filled: true,
                  hintStyle:
                      TextStyle(color: styling?.textDisabled ?? Colors.grey),
                  fillColor: styling?.background ?? Colors.white,
                  // hintText: hintText ?? '',
                ),
                enabled: true,
                validator: _getValidator(state.context),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              );
            });
}
