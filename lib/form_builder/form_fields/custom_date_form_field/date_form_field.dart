import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<DateTime> onSaved,
    required FormFieldValidator<DateTime> validator,
    DateTime? initialValue,
    DateTime? originalValue,
    ShapeFormStyling? styling,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: originalValue,
          builder: (FormFieldState<DateTime> state) {
            return Container(
              decoration: styling?.containerDecoration ??
                  BoxDecoration(
                    color: styling?.background ?? Colors.white,
                    border: Border.all(
                        color: styling?.border ?? FormColors.border, width: 1),
                    borderRadius:
                        BorderRadius.circular(styling?.borderRadiusMedium ?? 8),
                  ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label),
                        Spacer(),
                      ],
                    ),
                    if (labelDescription != null) ...[
                      Gap(spacing),
                      Text(labelDescription),
                    ],
                    Gap(spacing),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        DateFormFieldPicker(
                          validator: (date) {
                            validator(date);
                          },
                          onDateSelected: (selectedDate) {
                            state.setValue(selectedDate);
                            onSaved(selectedDate);
                          },
                          preSelectedDate: state.value,
                          initialValue: initialValue,
                          styling: styling,
                        ),
                        if (originalValue != null) ...[
                          Gap(spacing),
                          Text("Original Value: " +
                              DateFormat('E MMM d, ' 'yy')
                                  .format(originalValue)),
                        ],
                        if (state.hasError == true) ...[
                          Gap(spacing),
                          Text(state.errorText!,
                              style: TextStyle(
                                  color: styling?.error ?? Colors.red)),
                        ],
                      ],
                    ),
                  ]).allPadding(padding),
            );
          },
        );
}

class DateFormFieldPicker extends StatefulWidget {
  String? Function(DateTime?)? validator;
  String? Function(DateTime?)? onDateSelected;
  DateTime? preSelectedDate;
  DateTime? initialValue;
  ShapeFormStyling? styling;
  DateFormFieldPicker(
      {this.validator,
      this.onDateSelected,
      this.preSelectedDate,
      this.initialValue,
      this.styling});

  @override
  State<DateFormFieldPicker> createState() => _DateFormFieldPickerState();
}

class _DateFormFieldPickerState extends State<DateFormFieldPicker> {
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    if (_selectedDate == null) {
      if (widget.preSelectedDate != null) {
        _selectedDate = widget.preSelectedDate;
      }
    }

    if (_selectedDate != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: widget.styling?.spacingMedium ?? 10,
        children: [
          Container(
            width: double.infinity,
            decoration: widget.styling?.containerDecoration ??
                BoxDecoration(
                    border: Border.all(
                        style: BorderStyle.solid,
                        color: widget.styling?.border ?? Colors.grey,
                        width: 2),
                    color: widget.styling?.background ?? Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(
                        widget.styling?.borderRadiusMedium ?? 10))),
            child: Padding(
              padding: EdgeInsets.all(widget.styling?.spacingMedium ?? 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                        DateFormat('E MMM d, ' 'yy').format(_selectedDate!)),
                  ),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        if (widget.onDateSelected != null) {
                          widget.onDateSelected!(null);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            child: Container(
                width: double.infinity,
                child: Center(child: Text("Select Different Date"))),
            onPressed: () {
              _selectDate(context, _selectedDate, widget.initialValue);
            },
            style: widget.styling?.secondaryButtonStyle ??
                FormButtonStyles.secondaryButton,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            child: Container(
                width: double.infinity,
                child: Center(child: Text("Select Date"))),
            onPressed: () {
              _selectDate(context, _selectedDate, widget.initialValue);
            },
            style: widget.styling?.secondaryButtonStyle ??
                FormButtonStyles.secondaryButton,
          ),
        ],
      );
    }
  }

  _selectDate(BuildContext context, DateTime? selectedDate,
      DateTime? initialDate) async {
    DateTime _initalDate = DateTime.now();

    if (selectedDate != null) {
      _initalDate = selectedDate;
    } else if (initialDate != null) {
      _initalDate = initialDate;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _initalDate, // Refer step 1
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 3)),
      builder: (context, child) {
        return Theme(
            data: ThemeData().copyWith(
                colorScheme: ColorScheme.light(
                    primary:
                        widget.styling?.secondary ?? FormColors.secondary)),
            child: child!);
      },
    );

    if (picked != null) {
      if (widget.onDateSelected != null) {
        setState(() {
          widget.onDateSelected!(picked);
          _selectedDate = picked;
        });
      }
    }
  }
}
