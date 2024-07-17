import 'package:flutter/material.dart';
import 'package:shape_form_builder/form_builder/models/shape_form.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_data.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_field_question_type.dart';
import 'package:shape_form_builder/form_builder/models/shape_form_option.dart';
import 'package:shape_form_builder/form_builder/shape_form_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                formConfig: ShapeForm(
                    formData: ShapeFormData(questions: [
              ShapeFormQuestion(
                  question: "Testing UI",
                  type: ShapeFormQuestionType.text,
                  isRequired: true,
                  hintText: "Testing",
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
                  question: "Testing Secure Password",
                  type: ShapeFormQuestionType.secureText,
                  isRequired: true,
                  hintText: "Testing",
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
                question: "Testing UI",
                type: ShapeFormQuestionType.multiLineText,
                isRequired: true,
                hintText: "Testing Multi Line",
              ),
              ShapeFormQuestion(
                  question: "Testing Date",
                  type: ShapeFormQuestionType.date,
                  isRequired: true,
                  validator: (newValue) {
                    if (newValue == null) {
                      return "Is required";
                    } else if ((newValue as DateTime)
                            .compareTo(DateTime.now()) <
                        0) {
                      return "Must be in the future";
                    } else {
                      return null;
                    }
                  }),
              ShapeFormQuestion(
                  question: "Testing Date Range",
                  type: ShapeFormQuestionType.dateRange,
                  isRequired: true,
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
                  question: "Do you want a checkbox?",
                  type: ShapeFormQuestionType.checkbox,
                  isRequired: true,
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
                  }),
              ShapeFormQuestion(
                  question: "Do you want a true or false fields instead?",
                  type: ShapeFormQuestionType.boolean,
                  isRequired: true,
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
                  validator: (newValue) {
                    if (newValue == null) {
                      return "Is required";
                    } else if (newValue != null) {
                      bool selection = (newValue as bool);

                      if (selection != true) {
                        return "Must be yes";
                      }
                    } else {
                      return null;
                    }
                  }),
              ShapeFormQuestion(
                question: "Drop Down Options are good?",
                type: ShapeFormQuestionType.dropdown,
                isRequired: false,
                options: [
                  ShapeFormOption(
                    label: 'Yes',
                    selectedValue: "Yes",
                  ),
                  ShapeFormOption(
                    label: 'No',
                    selectedValue: "No",
                  ),
                  ShapeFormOption(
                    label: 'AWESOME!',
                    selectedValue: "AWESOME!",
                  )
                ],
                validator: (newValue) {
                  if (newValue == null) {
                    return "Is required";
                  } else if (newValue != null) {
                    String selection = (newValue as String);

                    if (selection != "AWESOME!") {
                      return "Must be AWESOME!";
                    } else {
                      return null;
                    }
                  } else {
                    return null;
                  }
                },
              ),
              ShapeFormQuestion(
                question: "Pop Up Menus are better for multiple selection?",
                type: ShapeFormQuestionType.optionList,
                isRequired: false,
                options: [
                  ShapeFormOption(
                    label: 'Kind Of',
                    selectedValue: 1,
                  ),
                  ShapeFormOption(
                    label: 'Not Really',
                    selectedValue: 2,
                  ),
                  ShapeFormOption(
                    label: "Don't have a opinion",
                    selectedValue: 3,
                  )
                ],
                validator: (newValue) {
                  if (newValue == null) {
                    return "Is required";
                  } else if (newValue != null) {
                    int selection = (newValue as int);

                    if (selection != 1) {
                      return "Must be Kind Of";
                    } else {
                      return null;
                    }
                  } else {
                    return null;
                  }
                },
              ),
              ShapeFormQuestion(
                  question: "What is your phone number",
                  type: ShapeFormQuestionType.phone,
                  isRequired: true),
            ])))),
      ),
    );
  }
}
