import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CustomPhoneNumberField extends FormField<String> {
  CustomPhoneNumberField({
    required PhoneController phoneController,
    bool? isRequired,
    required BuildContext context,
  }) : super(
            // onSaved: onSaved,
            builder: (FormFieldState<String> state) {
          PhoneNumberInputValidator? _getValidator() {
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
            shouldFormat: true && !false,
            autofocus: false,
            autofillHints: const [AutofillHints.telephoneNumber],
            countrySelectorNavigator:
                const CountrySelectorNavigator.dialog(width: 500),
            defaultCountry: IsoCode.US,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  )),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  )),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey),
              fillColor: Colors.white,
              // hintText: hintText ?? '',
            ),
            enabled: true,
            showFlagInInput: true,
            validator: _getValidator(),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // onSaved: (p) => onSaved(p!.getFormattedNsn()),
            // onChanged: (p) => onSaved(p!.getFormattedNsn()),
            isCountryChipPersistent: true,
          );
        });
}