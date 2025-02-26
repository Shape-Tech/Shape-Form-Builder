import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
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
import 'package:shape_form_builder/form_builder/form_fields/custom_option_form_field/option_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_phone_number_field/custom_phone_number_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_text_field/custom_text_form_field.dart';
import 'package:shape_form_builder/form_builder/models/form_field_theme.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question_type.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_option.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

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
  MapsRepo? mapsRepoForAddress;
  List<ShapeFormQuestion>? conditionalQuestions;
  int Function(dynamic)? showConditionalQuestionsCase;
  int? conditionalQuestionsCase;
  final TextEditingController textController = TextEditingController();
  final PhoneController phoneController = PhoneController();
  ShapeFormStyling? styling;
  bool? showOuterContainer;

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
    this.conditionalQuestions,
    this.showConditionalQuestionsCase,
    this.conditionalQuestionsCase,
    this.showOuterContainer = true,
  }) {
    if (response != null) {
      textController.text = response?.toString() ?? '';
    } else if (originalValue != null) {
      if (type == ShapeFormQuestionType.text ||
          type == ShapeFormQuestionType.secureText ||
          type == ShapeFormQuestionType.multiLineText) {
        textController.text = originalValue?.toString() ?? '';
        response = originalValue as String;
      }
    }
  }

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
        conditionalQuestions,
        showConditionalQuestionsCase,
        conditionalQuestionsCase,
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

  Widget? buildUI({
    VoidCallback? onResponseChanged,
    ShapeFormStyling? styling,
    dynamic parentResponse,
  }) {
    void updateResponse(dynamic newValue) {
      response = newValue;
      if (additionalOnSave != null) {
        additionalOnSave!(newValue);
      }
      if (onResponseChanged != null) {
        onResponseChanged();
      }
    }

    Widget buildConditionalQuestions() {
      if (conditionalQuestions != null &&
          showConditionalQuestionsCase != null &&
          response != null) {
        int caseToShow = showConditionalQuestionsCase!(response);

        List<Widget> conditionalQuestionsToShow = [];
        for (ShapeFormQuestion question in conditionalQuestions ?? []) {
          if (question.conditionalQuestionsCase == caseToShow) {
            Widget? questionWidget = question.buildUI(
              onResponseChanged: onResponseChanged,
              styling: styling,
              parentResponse: response,
            );
            if (questionWidget != null) {
              conditionalQuestionsToShow
                  .add(Gap(styling?.spacingSmall ?? spacing));
              conditionalQuestionsToShow.add(questionWidget);
            }
          }
        }
        if (conditionalQuestionsToShow.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: conditionalQuestionsToShow,
          );
        }
        return Container();
      }
      return Container();
    }

    Widget wrapWithConditional(Widget field) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          field,
          if (conditionalQuestions != null &&
              showConditionalQuestionsCase != null &&
              response != null) ...[
            buildConditionalQuestions(),
          ]
        ],
      );
    }

    switch (type) {
      case ShapeFormQuestionType.text:
        return wrapWithConditional(
          CustomTextFormField(
            textfieldController: textController,
            hintText: hintText,
            initalText: originalValue as String?,
            textInputAction: textInputAction,
            label: question,
            styling: styling,
            onChanged: (value) {
              updateResponse(value);
            },
            onSaved: (newVal) {
              updateResponse(newVal);
            },
            validator: (value) {
              if (isRequired) {
                if (value == null || value.isEmpty) {
                  return "Is required";
                }
                if (validator != null) {
                  return validator!(value);
                }
              }
              return null;
            },
            showOuterContainer: showOuterContainer,
          ),
        );
      case ShapeFormQuestionType.secureText:
        return wrapWithConditional(
          CustomTextFormField(
            textfieldController: textController,
            hintText: hintText,
            secure: true,
            initalText: originalValue as String?,
            label: question,
            textInputAction: textInputAction,
            styling: styling,
            onChanged: (value) {
              updateResponse(value);
            },
            onSaved: (newVal) {
              updateResponse(newVal);
            },
            validator: (value) {
              if (isRequired) {
                if (value == null || value.isEmpty) {
                  return "Is required";
                }
                if (validator != null) {
                  return validator!(value);
                }
              }
              return null;
            },
            showOuterContainer: showOuterContainer,
          ),
        );
      case ShapeFormQuestionType.multiLineText:
        return wrapWithConditional(
          CustomTextFormField(
            textfieldController: textController,
            hintText: hintText,
            label: question,
            initalText: originalValue as String?,
            textInputAction: textInputAction,
            maxLines: 5,
            styling: styling,
            onChanged: (value) {
              updateResponse(value);
            },
            onSaved: (newVal) {
              updateResponse(newVal);
            },
            validator: (value) {
              if (isRequired) {
                if (value == null || value.isEmpty) {
                  return "Is required";
                }
                if (validator != null) {
                  return validator!(value);
                }
              }
              return null;
            },
            showOuterContainer: showOuterContainer,
          ),
        );
      case ShapeFormQuestionType.date:
        return wrapWithConditional(
          DateFormField(
            label: question,
            labelDescription: description,
            originalValue: originalValue as DateTime?,
            onSaved: (newValue) {
              if (newValue != null) {
                updateResponse(newValue);
              }
            },
            styling: styling,
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
            initialValue: parentResponse != null
                ? (parentResponse as DateTimeRange).start
                : initialValue as DateTime?,
          ),
        );
      case ShapeFormQuestionType.dateRange:
        return wrapWithConditional(
          DateRangeFormField(
            label: question,
            labelDescription: description,
            initialValue: initialValue as DateTimeRange?,
            originalValue: originalValue as DateTimeRange?,
            styling: styling,
            onSaved: (newValue) {
              if (newValue != null) {
                updateResponse(newValue);
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
          ),
        );
      case ShapeFormQuestionType.checkbox:
        return wrapWithConditional(
          CustomCheckboxFormField(
            title: Text(question),
            description: description,
            onSaved: (newValue) {
              if (newValue != null) {
                updateResponse(newValue);
              }
            },
            styling: styling,
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
          ),
        );
      case ShapeFormQuestionType.boolean:
        return wrapWithConditional(
          TrueFalseFormField(
            label: question,
            labelDescription: description,
            styling: styling,
            trueLabel: options?[0].label ?? '',
            falseLabel: options?[1].label ?? '',
            onSaved: (newValue) {
              if (newValue != null) {
                updateResponse(newValue);
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
          ),
        );
      case ShapeFormQuestionType.dropdown:
        return wrapWithConditional(
          CustomDropDownFormField(
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
                updateResponse(newValue.value);
              }
            },
            label: question,
            styling: styling,
            initialValue: initialValue != null
                ? CustomPopUpMenuItem(
                    label: (initialValue as ShapeFormOption).label ?? '',
                    description:
                        (initialValue as ShapeFormOption).description ?? '',
                    value:
                        (initialValue as ShapeFormOption).selectedValue ?? '')
                : null,
            originalValue: originalValue != null
                ? CustomPopUpMenuItem(
                    label: (originalValue as ShapeFormOption).label ?? '',
                    description:
                        (originalValue as ShapeFormOption).description ?? '',
                    value:
                        (originalValue as ShapeFormOption).selectedValue ?? '')
                : null,
          ),
        );
      case ShapeFormQuestionType.optionList:
        return wrapWithConditional(
          OptionFormField(
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
            styling: styling,
            options: buildOptionItems(options),
            onSaved: (newValue) {
              if (newValue != null) {
                List<dynamic> selectedOptionValues = [];
                for (OptionsDataItem option in newValue) {
                  selectedOptionValues.add(option.object);
                }
                updateResponse(selectedOptionValues);
              }
            },
            buttonText: 'Select',
            originalValue: originalValue != null
                ? buildOptionItems(originalValue as List<ShapeFormOption>)
                : null,
          ),
        );
      case ShapeFormQuestionType.phone:
        return wrapWithConditional(
          CustomPhoneNumberField(
            phoneController: phoneController,
            isRequired: isRequired,
            onSaved: (newVal) {
              updateResponse(newVal);
            },
            styling: styling,
            label: question,
          ),
        );
      case ShapeFormQuestionType.address:
        return wrapWithConditional(
          AddressFormField(
            label: question,
            labelDescription: description,
            onSaved: (newVal) {
              updateResponse(newVal);
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
            styling: styling,
          ),
        );
      case ShapeFormQuestionType.imageUpload:
        return wrapWithConditional(
          ImageFormField(
            label: question,
            onSaved: (newVal) {
              updateResponse(newVal);
            },
            styling: styling,
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
          ),
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
