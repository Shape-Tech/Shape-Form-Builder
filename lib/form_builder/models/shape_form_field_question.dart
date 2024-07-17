import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_boolean_form_field/true_false_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_checkbox/custom_checkbox_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_date_form_field/date_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_date_range_field/date_range_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down/custom_drop_down_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down/custom_pop_up_menu_item.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_option_form_field/option_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_phone_number_field/custom_phone_number_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_text_field/custom_text_form_field.dart';
import 'package:shape_form_builder/form_builder/models/form_field_theme.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question_type.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_option.dart';

// ignore: must_be_immutable
class ShapeFormQuestion extends Equatable {
  int? id;
  String question;
  String? description;
  String? hintText;
  ShapeFormQuestionType type;
  bool isRequired;
  List<ShapeFormOption>? options;
  Function(dynamic)? validator;
  Function(dynamic)? additionalOnSave;
  dynamic initialValue;
  dynamic originalValue;
  dynamic response;
  FormFieldTheme? overrideFormFieldTheme;

  TextInputAction? textInputAction;

  ShapeFormQuestion({
    this.id,
    required this.question,
    this.description,
    this.hintText,
    required this.type,
    required this.isRequired,
    this.options,
    this.validator,
    this.additionalOnSave,
    this.initialValue,
    this.originalValue,
    this.response,
    this.overrideFormFieldTheme,
    this.textInputAction,
  });

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  Widget? buildUI() {
    TextEditingController textController = TextEditingController();
    PhoneController phoneController = PhoneController();

    switch (type) {
      case ShapeFormQuestionType.text:
        return CustomTextFormField(
          textfieldController: textController,
          hintText: hintText,
          initalText: originalValue as String?,
          textInputAction: textInputAction,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.secureText:
        return CustomTextFormField(
          textfieldController: textController,
          hintText: hintText,
          secure: true,
          initalText: originalValue as String?,
          textInputAction: textInputAction,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.multiLineText:
        return CustomTextFormField(
          textfieldController: textController,
          hintText: hintText,
          initalText: originalValue as String?,
          textInputAction: textInputAction,
          maxLines: 5,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.date:
        return DateFormField(
          label: question,
          labelDescription: description,
          initialValue: initialValue as DateTime?,
          originalValue: originalValue as DateTime?,
          onSaved: (newValue) {
            if (newValue != null) {
              response = newValue;
              if (additionalOnSave != null) {
                additionalOnSave!(newValue);
              }
            }
          },
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.dateRange:
        return DateRangeFormField(
          label: question,
          labelDescription: description,
          initialValue: initialValue as DateTimeRange?,
          originalValue: originalValue as DateTimeRange?,
          onSaved: (newValue) {
            if (newValue != null) {
              response = newValue;
              if (additionalOnSave != null) {
                additionalOnSave!(newValue);
              }
            }
          },
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.checkbox:
        return CustomCheckboxFormField(
          title: Text(question),
          description: description,
          onSaved: (newValue) {
            if (newValue != null) {
              response = newValue;
              if (additionalOnSave != null) {
                additionalOnSave!(newValue);
              }
            }
          },
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.boolean:
        return TrueFalseFormField(
          label: question,
          labelDescription: description,
          trueLabel: options?[0].label ?? '',
          falseLabel: options?[1].label ?? '',
          onSaved: (newValue) {
            if (newValue != null) {
              response = newValue;
              if (additionalOnSave != null) {
                additionalOnSave!(newValue);
              }
            }
          },
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.dropdown:
        return CustomDropDownFormField(
          // hint: Text(question),
          // labelDescription: description,
          validator: (value) {
            if (validator != null) {
              return validator!(value?.value);
            } else {
              return null;
            }
          },
          menuItems: buildDropDownMenuItems(options),
          onSaved: (newValue) {
            if (newValue != null) {
              response = newValue.value;
              if (additionalOnSave != null) {
                additionalOnSave!(newValue.value);
              }
            }
          },
        );
      case ShapeFormQuestionType.optionList:
        return OptionFormField(
          label: question,
          labelDescription: description,
          validator: (value) {
            if (validator != null) {
              if (value != null) {
                List<dynamic> selectedOptionValues = [];
                for (OptionsDataItem option
                    in value.where((elem) => elem.selected == true)) {
                  selectedOptionValues.add(option.object);
                }
                return validator!(value);
              } else {
                validator!(value);
              }
            } else {
              return null;
            }
          },
          options: buildOptionItems(options),
          onSaved: (newValue) {
            if (newValue != null) {
              List<dynamic> selectedOptionValues = [];
              for (OptionsDataItem option
                  in newValue.where((elem) => elem.selected == true)) {
                selectedOptionValues.add(option.object);
              }
              response = selectedOptionValues;
              if (additionalOnSave != null) {
                additionalOnSave!(selectedOptionValues);
              }
            }
          },
          buttonText: 'Select',
        );
      case ShapeFormQuestionType.secureText:
        return CustomTextFormField(
          textfieldController: textController,
          hintText: hintText,
          initalText: originalValue as String?,
          textInputAction: textInputAction,
          secure: true,
          validator: (value) {
            if (validator != null) {
              return validator!(value);
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.phone:
        return CustomPhoneNumberField(
          phoneController: phoneController,
          isRequired: isRequired,
        );
      default:
        return null;
    }
  }

  List<CustomPopUpMenuItem> buildDropDownMenuItems(
      List<ShapeFormOption>? options) {
    List<CustomPopUpMenuItem> items = [];
    for (ShapeFormOption option in options ?? []) {
      items.add(
        CustomPopUpMenuItem(
          label: option.label,
          description: option.description,
          value: option.selectedValue,
        ),
      );
    }
    return items;
  }

  List<OptionsDataItem> buildOptionItems(List<ShapeFormOption>? options) {
    List<OptionsDataItem> items = [];
    for (ShapeFormOption option in options ?? []) {
      items.add(
        OptionsDataItem(
          displayLabel: option.label,
          displayDescription: option.description,
          object: option.selectedValue,
          selected: option.isSelected ?? false,
        ),
      );
    }
    return items;
  }
}
