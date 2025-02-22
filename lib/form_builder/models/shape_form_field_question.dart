import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/repository/google_maps_repo.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_boolean_form_field/true_false_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_checkbox_form_field/custom_checkbox_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_date_form_field/date_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_date_range_field/date_range_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_drop_down_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_drop_down_form_field/custom_pop_up_menu_item.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/image_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_image_form_field/repository/image_repo.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_option_form_field/option_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_phone_number_field/custom_phone_number_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_text_field/custom_text_form_field.dart';
import 'package:shape_form_builder/form_builder/models/form_field_theme.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question_type.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_option.dart';

// ignore: must_be_immutable
class ShapeFormQuestion extends Equatable {
  int? id;
  String fieldName;
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
  GoogleMapsRepo? mapsRepoForAddress;
  // ImageRepo? imageRepo;

  ShapeFormQuestion({
    this.id,
    required this.fieldName,
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
    this.mapsRepoForAddress,
    // this.imageRepo,
  });

  @override
  List<Object?> get props => [
        id,
        fieldName,
        question,
        description,
        hintText,
        type,
        isRequired,
        options,
        validator,
        additionalOnSave,
        initialValue,
        originalValue,
        response,
        overrideFormFieldTheme,
        textInputAction,
        mapsRepoForAddress,
      ];

  dynamic getResponse() {
    switch (type) {
      case ShapeFormQuestionType.text:
        return response;
      case ShapeFormQuestionType.secureText:
        return response;
      case ShapeFormQuestionType.multiLineText:
        return response;
      case ShapeFormQuestionType.date:
        return (response as DateTime).toIso8601String();
      case ShapeFormQuestionType.dateRange:
        return {
          "start": (response as DateTimeRange).start.toIso8601String(),
          "end": (response as DateTimeRange).end.toIso8601String()
        };
      case ShapeFormQuestionType.checkbox:
        return response;
      case ShapeFormQuestionType.boolean:
        return response;
      case ShapeFormQuestionType.dropdown:
        return response;
      case ShapeFormQuestionType.optionList:
        return response;
      case ShapeFormQuestionType.phone:
        return response;
      case ShapeFormQuestionType.address:
        return {
          "address": (response as Address).addressLineOne,
          "city": (response as Address).city,
          "state": (response as Address).state,
          "zip": (response as Address).zip,
          "country": (response as Address).country
        };
      case ShapeFormQuestionType.imageUpload:
        return (response as PlatformFile).name;
      default:
        return null;
    }
  }

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
          onSaved: (newVal) {
            response = newVal;
          },
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
          onSaved: (newVal) {
            response = newVal;
          },
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
          onSaved: (newVal) {
            response = newVal;
          },
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.dropdown:
        return CustomDropDownFormField(
          hintText: hintText,
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
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
          multiSelectEnabled: true,
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  debugPrint("Option List Validator");
                  List<dynamic> selectedOptionValues = [];
                  for (OptionsDataItem option
                      in value.where((elem) => elem.selected == true)) {
                    selectedOptionValues.add(option.object);
                  }
                  return validator!(selectedOptionValues);
                } else {
                  return null;
                }
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
          onSaved: (newVal) {
            response = newVal;
          },
          validator: (value) {
            if (isRequired) {
              if (value == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(value);
                } else {
                  return null;
                }
              }
            } else {
              return null;
            }
          },
        );
      case ShapeFormQuestionType.phone:
        return CustomPhoneNumberField(
          phoneController: phoneController,
          isRequired: isRequired,
          onSaved: (newVal) {
            response = newVal;
          },
        );
      case ShapeFormQuestionType.address:
        return AddressFormField(
          label: question,
          labelDescription: description,
          onSaved: (newVal) {
            response = newVal;
          },
          validator: (newValue) {
            if (isRequired) {
              if (newValue == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(newValue);
                } else {
                  return null;
                }
              }
            } else {
              return null;
            }
          },
          mapsRepo: mapsRepoForAddress,
        );
      case ShapeFormQuestionType.imageUpload:
        return ImageFormField(
          label: "Upload Image",
          onSaved: (newVal) {
            response = newVal;
            if (additionalOnSave != null) {
              additionalOnSave!(newVal);
            }
          },
          validator: (newValue) {
            if (isRequired) {
              if (newValue == null) {
                return "Is required";
              } else {
                if (validator != null) {
                  return validator!(newValue);
                } else {
                  return null;
                }
              }
            } else {
              return null;
            }
          },
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
