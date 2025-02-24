import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
      selectedValue: "Italian",
      object: "Italian",
    ),
    ShapeFormOption(
      label: 'Mexican',
      selectedValue: "Mexican",
      object: "Mexican",
    ),
    ShapeFormOption(
      label: "Japanese",
      selectedValue: "Japanese",
      object: "Japanese",
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            child: ShapeFormBuilder(
              styling: styleImplemented,
              formConfig: ShapeForm(
                formData: createFormData(),
                onSubmission: (data) {
                  debugPrint(data.toString());
                  // TODO: Use this validated data in a bloc event
                },
              ),
            )),
      ),
    );
  }

  ShapeFormData createFormData() {
    return ShapeFormData(
      questions: [
        ShapeFormQuestion(
          fieldName: "name",
          question: "What is your name?",
          type: ShapeFormQuestionType.text,
          isRequired: true,
          hintText: "Enter your name",
        ),
        ShapeFormQuestion(
            fieldName: "password",
            question: "Enter your password",
            type: ShapeFormQuestionType.secureText,
            isRequired: true,
            hintText: "Enter your password",
            validator: (newValue) {
              if (newValue == null) {
                return "Is required";
              } else if ((newValue as String).isEmpty) {
                return "Is required";
              } else {
                return null;
              }
            }),
        ShapeFormQuestion(
          fieldName: "lunch_description",
          question: "Describe your lunch",
          type: ShapeFormQuestionType.multiLineText,
          isRequired: true,
          hintText: "Describe your lunch",
        ),
        ShapeFormQuestion(
            fieldName: "lunch_date",
            question: "What is the date of your lunch?",
            type: ShapeFormQuestionType.date,
            isRequired: true,
            validator: (newValue) {
              if (newValue == null) {
                return "Is required";
              } else if ((newValue as DateTime).compareTo(DateTime.now()) < 0) {
                return "Must be in the future";
              } else {
                return null;
              }
            }),
        ShapeFormQuestion(
            fieldName: "next_lunch_availability",
            question: "What is the next lunch availability?",
            type: ShapeFormQuestionType.dateRange,
            isRequired: true,
            hintText: "Select the date range for your next lunch",
            validator: (newValue) {
              if (newValue == null) {
                return "Is required";
              } else if (newValue != null) {
                DateTime start = (newValue as DateTimeRange).start;

                DateTime end = (newValue as DateTimeRange).end;
                int difference = end.difference(start).inDays;
                if (difference < 2) {
                  return "Must be more than 2 days apart";
                }
              } else {
                return null;
              }
            }),
        ShapeFormQuestion(
            fieldName: "invite_friends",
            question: "Tick this box if you want to invite friends",
            type: ShapeFormQuestionType.checkbox,
            isRequired: true,
            hintText: "Tick this box if you want to invite friends",
            validator: (newValue) {
              if (newValue == null) {
                return "Is required";
              } else if (newValue != null) {
                bool selection = (newValue as bool);

                if (selection != true) {
                  return "Must be ticked";
                }
              } else {
                return null;
              }
            },
            conditionalQuestions: [
              ShapeFormQuestion(
                fieldName: 'which_friends',
                question: "Which friends?",
                type: ShapeFormQuestionType.text,
                isRequired: true,
                hintText: "Enter the names of the friends you want to invite",
                showConditionalQuestions: (response) {
                  return (response as String).toLowerCase().contains("anna");
                },
                conditionalQuestions: [
                  ShapeFormQuestion(
                    fieldName: 'why_anna',
                    question: "Why Anna?",
                    type: ShapeFormQuestionType.text,
                    isRequired: true,
                    hintText: "Enter the reason why Anna is invited",
                  )
                ],
              )
            ],
            showConditionalQuestions: (response) {
              return (response as bool);
            }),
        ShapeFormQuestion(
            fieldName: "need_vegan_options",
            question: "Do you need vegan options?",
            type: ShapeFormQuestionType.boolean,
            isRequired: true,
            hintText: "Do you need vegan options?",
            options: [
              ShapeFormOption(
                label: 'Yes',
                selectedValue: true,
              ),
              ShapeFormOption(
                label: 'No',
                selectedValue: false,
              )
            ],
            showConditionalQuestions: (response) {
              return (response as bool) == false;
            },
            conditionalQuestions: [
              ShapeFormQuestion(
                  fieldName: 'why_no',
                  question: "Why no?",
                  type: ShapeFormQuestionType.text,
                  isRequired: true,
                  hintText: "Enter the reason why no")
            ]),
        ShapeFormQuestion(
          fieldName: "preffered_lunch_time",
          question: "What is your preferred lunch time?",
          type: ShapeFormQuestionType.dropdown,
          isRequired: true,
          hintText: "Select your preferred lunch time",
          options: [
            ShapeFormOption(
              label: '12:00',
              selectedValue: "12:00",
            ),
            ShapeFormOption(
              label: '13:00',
              selectedValue: "13:00",
            ),
            ShapeFormOption(
              label: '14:00',
              selectedValue: "14:00",
            )
          ],
          validator: (newValue) {
            if (newValue == null) {
              return "Is required";
            } else if (newValue != null) {
              String selection = (newValue.value as String);

              if (selection != "12:00" && selection != "13:00") {
                return "Must be 12:00 or 13:00";
              } else {
                return null;
              }
            } else {
              return null;
            }
          },
        ),
        ShapeFormQuestion(
          fieldName: "preferred_lunch_option",
          question: "What are your preferred lunch options?",
          type: ShapeFormQuestionType.optionList,
          isRequired: true,
          hintText: "Select your preferred lunch options",
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
        ),
        ShapeFormQuestion(
          fieldName: "phone_number",
          question: "What is your phone number",
          type: ShapeFormQuestionType.phone,
          isRequired: true,
        ),
        ShapeFormQuestion(
          fieldName: "address",
          question: "What is your address",
          type: ShapeFormQuestionType.address,
          isRequired: true,
          mapsRepoForAddress: NewMapsRepository(),
        ),
        ShapeFormQuestion(
          fieldName: "profile_image",
          question: "Upload your profile image",
          type: ShapeFormQuestionType.imageUpload,
          isRequired: true,

          // additionalOnSave: (imageFile) async {
          //   debugPrint(imageFile.toString());
          //   ImageRepoExample imageRepo = ImageRepoExample();
          //   String url = await imageRepo.uploadImage(
          //       bucketId: "example",
          //       imageToUpload: (imageFile as PlatformFile).bytes!,
          //       filePath: (imageFile as PlatformFile).name);
          // }
        ),
      ],
    );
  }
}
