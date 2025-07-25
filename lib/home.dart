import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_address_form_field/address.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_date_form_field/date_form_field.dart';
import 'package:shape_form_builder/form_builder/form_fields/custom_option_form_field/option_form_field.dart';
import 'package:shape_form_builder/form_builder/models/optional_required_chip.dart';
import 'package:shape_form_builder/form_builder/models/shape_form.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_data.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question_type.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_option.dart';
import 'package:shape_form_builder/form_builder/shape_form_builder.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';
import 'package:shape_form_builder/repositories/new_maps_repository.dart';
import 'package:shape_form_builder/styling_implemented.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  List<ShapeFormOption> foodOptions = [
    ShapeFormOption(
      label: 'Italian',
      description: "Italian is a delicious food",
      selectedValue: "Italian",
      object: "Italian",
    ),
    ShapeFormOption(
      label: 'MEXICAN',
      selectedValue: "MEXICAN",
      object: "MEXICAN",
      isSelected: true,
    ),
    ShapeFormOption(
      label: "Japanese",
      selectedValue: "Japanese",
      object: "Japanese",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Shape Form Builder",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DateFormField(
                          label: "Date",
                          suggestedDate: DateTime.now().add(Duration(days: 30)),
                          initialValue: DateTime.now(),
                          onSaved: (newValue) {
                            debugPrint(newValue.toString());
                          },
                          validator: (newValue) {
                            return null;
                          },
                        ),
                        // OptionFormField(
                        //     label: "What are your preferred lunch options?",
                        //     buttonText: "Select",
                        //     multiSelectEnabled: true,
                        //     options: foodOptions
                        //         .map((e) => OptionsDataItem(
                        //             displayLabel: e.label,
                        //             displayDescription: e.description,
                        //             selected: e.isSelected ?? false,
                        //             object: e.object))
                        //         .toList(),
                        //     onSaved: (newValue) {
                        //       debugPrint(newValue.toString());
                        //     },
                        //     validator: (newValue) {
                        //       if (newValue == null) {
                        //         return "Is required";
                        //       } else if (newValue.isNotEmpty) {
                        //         List<OptionsDataItem> selection =
                        //             (newValue as List<OptionsDataItem>);

                        //         if (selection.any((element) =>
                        //             element.displayLabel == "Italian")) {
                        //           return null;
                        //         } else {
                        //           return "Must include Italian";
                        //         }
                        //       } else {
                        //         return "Is required";
                        //       }
                        //     }),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fix the errors above'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ],
                    )),
                ShapeFormBuilder(
                  styling: styleImplemented,
                  formConfig: ShapeForm(
                    formData: createFormData(),
                    onSubmission: (data) {
                      debugPrint(data.toString());
                      // TODO: Use this validated data in a bloc event
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

  ShapeFormData createFormData() {
    OptionalRequiredChip displayChips = OptionalRequiredChip(
      showChip: true,
      isOptional: false,
    );

    return ShapeFormData(
      questions: [
        // ShapeFormQuestion(
        //   fieldName: "name",
        //   question: "What is your name?",
        //   type: ShapeFormQuestionType.text,
        //   optionalRequiredChip: displayChips,
        //   description: "This is a description",
        //   isRequired: true,
        //   hintText: "Enter your name",
        //   originalValue: "John Doe",
        //   initialValue: "Jane",
        //   showOuterContainer: true,
        // ),
        // ShapeFormQuestion(
        //     fieldName: "password",
        //     question: "Enter your password",
        //     optionalRequiredChip: displayChips,
        //     type: ShapeFormQuestionType.secureText,
        //     description: "This is a description",
        //     isRequired: true,
        //     hintText: "Enter your password",
        //     validator: (newValue) {
        //       if (newValue == null) {
        //         return "Is required";
        //       } else if ((newValue as String).isEmpty) {
        //         return "Is required";
        //       } else {
        //         return null;
        //       }
        //     }),
        // ShapeFormQuestion(
        //   fieldName: "lunch_description",
        //   question: "Describe your lunch",
        //   optionalRequiredChip: displayChips,
        //   type: ShapeFormQuestionType.multiLineText,
        //   description: "This is a description",
        //   isRequired: true,
        //   hintText: "Describe your lunch",
        //   originalValue: "I had a great lunch yesterday",
        //   initialValue: "I had a great lunch today",
        // ),
        // ShapeFormQuestion(
        //   fieldName: "next_lunch_availability",
        //   question: "What is the next lunch availability?",
        //   type: ShapeFormQuestionType.dateRange,
        //   description: "This is a description",
        //   isRequired: true,
        //   optionalRequiredChip: displayChips,
        //   hintText: "Select the date range for your next lunch",
        //   initialValue: DateTimeRange(
        //     start: DateTime.now(),
        //     end: DateTime.now().add(Duration(days: 2)),
        //   ),
        //   originalValue: DateTimeRange(
        //     start: DateTime.now().subtract(Duration(days: 1)),
        //     end: DateTime.now().add(Duration(days: 1)),
        //   ),
        //   validator: (newValue) {
        //     if (newValue == null) {
        //       return "Is required";
        //     } else if (newValue != null) {
        //       DateTime start = (newValue as DateTimeRange).start;

        //       DateTime end = (newValue as DateTimeRange).end;
        //       int difference = end.difference(start).inDays;
        //       if (difference < 2) {
        //         return "Must be more than 2 days apart";
        //       }
        //     } else {
        //       return null;
        //     }
        //   },
        // ),

        // ShapeFormQuestion(
        //   fieldName: "lunch_date",
        //   question: "What is the date of your lunch?",
        //   type: ShapeFormQuestionType.date,
        //   description: "This is a description",
        //   isRequired: false,
        //   optionalRequiredChip: displayChips,
        //   originalValue: DateTime.now().subtract(Duration(days: 1)),
        //   // validator: (newValue) {
        //   //   if (newValue == null) {
        //   //     return "Is required";
        //   //   } else if ((newValue as DateTime).compareTo(DateTime.now()) <
        //   //       0) {
        //   //     return "Must be in the future";
        //   //   } else {
        //   //     return null;
        //   //   }
        //   // },
        // ),
        // ShapeFormQuestion(
        //   fieldName: "invite_friends",
        //   question: "Tick this box if you want to invite friends",
        //   description: "This is a description",
        //   type: ShapeFormQuestionType.checkbox,
        //   isRequired: true,
        //   originalValue: true,
        //   initialValue: false,
        //   hintText: "Tick this box if you want to invite friends",
        //   optionalRequiredChip: displayChips,
        //   validator: (newValue) {
        //     if (newValue == null) {
        //       return "Is required";
        //     } else if (newValue != null) {
        //       bool selection = (newValue as bool);

        //       if (selection != true) {
        //         return "Must be ticked";
        //       }
        //     } else {
        //       return null;
        //     }
        //   },
        // ),
        // //     conditionalQuestions: [
        // ShapeFormQuestion(
        //   fieldName: 'which_friends',
        //   question: "Which friends?",
        //   type: ShapeFormQuestionType.text,
        //   isRequired: true,
        //   hintText: "Enter the names of the friends you want to invite",
        //   showConditionalQuestionsCase: (response) {
        //     if ((response as String).toLowerCase().contains("anna")) {
        //       return 1;
        //     }
        //     if ((response as String).toLowerCase().contains("phil")) {
        //       return 2;
        //     }
        //     return 0;
        //   },
        //   conditionalQuestionsCase: 1,
        //   conditionalQuestions: [
        //     ShapeFormQuestion(
        //       fieldName: 'why_anna',
        //       question: "Why Anna?",
        //       type: ShapeFormQuestionType.text,
        //       isRequired: true,
        //       hintText: "Enter the reason why Anna is invited",
        //       conditionalQuestionsCase: 1,
        //     ),
        //     ShapeFormQuestion(
        //       fieldName: 'why_phil',
        //       question: "Why Phil?",
        //       type: ShapeFormQuestionType.text,
        //       isRequired: true,
        //       hintText: "Enter the reason why Phil is invited",
        //       conditionalQuestionsCase: 2,
        //     )
        //   ],
        // ),
        // //     ],
        // //     showConditionalQuestionsCase: (response) {
        // //       return (response as bool) ? 1 : 0;
        // //     }),
        // ShapeFormQuestion(
        //     fieldName: "need_vegan_options",
        //     question: "Do you need vegan options?",
        //     type: ShapeFormQuestionType.boolean,
        //     description:
        //         "This is a description that is long so that it wraps and i know it works",
        //     isRequired: true,
        //     hintText: "Do you need vegan options?",
        //     optionalRequiredChip: OptionalRequiredChip(
        //       showChip: true,
        //       isOptional: true,
        //     ),
        //     originalValue: true,
        //     // initialValue: false,
        //     options: [
        //       ShapeFormOption(
        //         label: 'Yes',
        //         selectedValue: true,
        //       ),
        //       ShapeFormOption(
        //         label: 'No',
        //         selectedValue: false,
        //       )
        //     ],
        //     showConditionalQuestionsCase: (response) {
        //       return (response as bool) == false ? 1 : 0;
        //     },
        //     conditionalQuestions: [
        //       ShapeFormQuestion(
        //           fieldName: 'why_no',
        //           question: "Why no?",
        //           type: ShapeFormQuestionType.text,
        //           isRequired: true,
        //           hintText: "Enter the reason why no")
        //     ]),
        // ShapeFormQuestion(
        //   fieldName: "preffered_lunch_time",
        //   question: "What is your preferred lunch time?",
        //   description: "This is a description",
        //   type: ShapeFormQuestionType.dropdown,
        //   isRequired: true,
        //   hintText: "Select your preferred lunch time",
        //   optionalRequiredChip: displayChips,
        //   options: [
        //     ShapeFormOption(
        //       label: '12:00',
        //       description: "PM",
        //       selectedValue: "12:00",
        //     ),
        //     ShapeFormOption(
        //       label: '13:00',
        //       selectedValue: "13:00",
        //     ),
        //     ShapeFormOption(
        //       label: '14:00',
        //       selectedValue: "14:00",
        //     )
        //   ],
        //   initialValue: ShapeFormOption(
        //     label: '12:00',
        //     selectedValue: "12:00",
        //   ),
        //   originalValue: ShapeFormOption(
        //     label: '12:00',
        //     selectedValue: "12:00",
        //   ),
        //   validator: (newValue) {
        //     if (newValue == null) {
        //       return "Is required";
        //     } else if (newValue != null) {
        //       String selection = (newValue.value as String);

        //       if (selection != "12:00" && selection != "13:00") {
        //         return "Must be 12:00 or 13:00";
        //       } else {
        //         return null;
        //       }
        //     } else {
        //       return null;
        //     }
        //   },
        // ),

        ShapeFormQuestion(
          fieldName: "preferred_lunch_option",
          question: "What are your preferred lunch options?",
          description: "This is a description",
          type: ShapeFormQuestionType.optionList,
          isRequired: true,
          hintText: "Select your preferred lunch options",
          optionalRequiredChip: displayChips,
          options: foodOptions,
          validator: (newValue) {
            if (newValue == null) {
              return "Is required";
            } else if (newValue != null) {
              List<dynamic> selection = (newValue as List<dynamic>);

              if (selection.contains("Italian") == false) {
                return "Must include Italian";
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
          // originalValue: [
          //   ShapeFormOption(
          //     label: 'Italian',
          //     description: "Italian is a delicious food",
          //     selectedValue: "Italian",
          //   ),
          // ],
        ),
        // ShapeFormQuestion(
        //   fieldName: "phone_number",
        //   question: "What is your phone number",
        //   description: "This is a description",
        //   type: ShapeFormQuestionType.phone,
        //   isRequired: true,
        //   optionalRequiredChip: displayChips,
        //   originalValue: PhoneNumber(isoCode: IsoCode.GB, nsn: "7595608102"),
        //   initialValue: PhoneNumber(isoCode: IsoCode.GB, nsn: "7595608102"),
        // ),
        // ShapeFormQuestion(
        //   fieldName: "address",
        //   question:
        //       "What is your address i need this to be a long question so that it wraps and i know it works",
        //   description: "This is a description",
        //   type: ShapeFormQuestionType.address,
        //   isRequired: true,
        //   mapsRepoForAddress: NewMapsRepository(),
        //   optionalRequiredChip: displayChips,
        //   originalValue: Address(
        //     addressLineOne: "123 Main St",
        //     addressLineTwo: "Apt 1",
        //     city: "Anytown",
        //     state: "CA",
        //     zip: "12345",
        //     country: "United States",
        //   ),
        //   initialValue: Address(
        //     addressLineOne: "123 Main St",
        //     addressLineTwo: "Apt 1",
        //     city: "Anytown",
        //     state: "CA",
        //     zip: "12345",
        //     country: "United States",
        //   ),
        // ),
        // ShapeFormQuestion(
        //   fieldName: "image_example",
        //   question: "Image Example",
        //   type: ShapeFormQuestionType.imageUpload,
        //   isRequired: true,
        //   hintText: "Image Example",
        //   optionalRequiredChip: displayChips,
        // ),
      ],
    );
  }
}
