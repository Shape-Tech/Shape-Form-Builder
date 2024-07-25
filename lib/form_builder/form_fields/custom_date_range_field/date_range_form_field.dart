import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';

class DateRangeFormField extends FormField<DateTimeRange> {
  DateRangeFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<DateTimeRange> onSaved,
    required FormFieldValidator<DateTimeRange> validator,
    DateTimeRange? initialValue,
    DateTimeRange? originalValue,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: originalValue,
          builder: (FormFieldState<DateTimeRange> state) {
            if (originalValue != null) {
              if (state.value == null) {
                state.setValue(originalValue);
              }
            }
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(label),
                            const Spacer(),
                          ],
                        ),
                        if (labelDescription != null)
                          Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text(labelDescription)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DateRangeFormFiledPicker(
                                validator: (dateRange) {
                                  validator(dateRange);
                                },
                                onDateSelected: (selectedDateRange) {
                                  state.setValue(selectedDateRange);
                                  onSaved(selectedDateRange);
                                },
                                preSelectedStartDate: originalValue?.start,
                                preSelectedEndDate: originalValue?.end,
                                initialValue: initialValue,
                              ),
                            ),
                            if (originalValue != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                    "Original Value: ${DateFormat('E MMM d, ' 'yy').format(originalValue.start)} - ${DateFormat('E MMM d, ' 'yy').format(originalValue.end)}"),
                              ),
                            if (state.hasError == true)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(state.errorText!,
                                    style: TextStyle(color: Colors.red)),
                              )
                          ],
                        ),
                      ]),
                ),
              ),
            );
          },
        );
}

class DateRangeFormFiledPicker extends StatefulWidget {
  String? Function(DateTimeRange?)? validator;
  String? Function(DateTimeRange?)? onDateSelected;
  DateTime? preSelectedStartDate;
  DateTime? preSelectedEndDate;
  DateTimeRange? initialValue;

  DateRangeFormFiledPicker(
      {this.validator,
      this.onDateSelected,
      this.preSelectedStartDate,
      this.preSelectedEndDate,
      this.initialValue});

  @override
  State<DateRangeFormFiledPicker> createState() =>
      _DateRangeFormFiledPickerState();
}

class _DateRangeFormFiledPickerState extends State<DateRangeFormFiledPicker> {
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  @override
  Widget build(BuildContext context) {
    if (_selectedStartDate == null) {
      if (widget.preSelectedStartDate != null) {
        _selectedStartDate = widget.preSelectedStartDate;
      }
    }

    if (_selectedEndDate == null) {
      if (widget.preSelectedEndDate != null) {
        _selectedEndDate = widget.preSelectedEndDate;
      }
    }

    if (_selectedStartDate != null && _selectedEndDate != null) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.grey, width: 2),
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                    "${DateFormat('E MMM d, ' 'yy').format(_selectedStartDate!)} - ${DateFormat('E MMM d, ' 'yy').format(_selectedEndDate!)}"),
              ),
            ),
          ),
          ElevatedButton(
            child: Text("Select Different Dates"),
            onPressed: () {
              _selectDate(context, _selectedStartDate, _selectedEndDate,
                  widget.initialValue);
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            child: Text("Select Dates"),
            onPressed: () {
              _selectDate(context, _selectedStartDate, _selectedEndDate,
                  widget.initialValue);
            },
          ),
        ],
      );
    }
  }

  _selectDate(BuildContext buildContext, DateTime? startDate, DateTime? endDate,
      DateTimeRange? initialRange) async {
    DateTimeRange _initialRange =
        DateTimeRange(start: DateTime.now(), end: DateTime.now());

    if (startDate != null && endDate != null) {
      _initialRange = DateTimeRange(start: startDate, end: endDate);
    } else if (initialRange != null) {
      _initialRange = initialRange;
    }

    final DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      initialDateRange: _initialRange,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365 * 3)),
      builder: (context, child) {
        return LayoutBuilder(builder: (layoutBuilderContext, constraints) {
          return Theme(
              data: ThemeData().copyWith(
                  colorScheme: ColorScheme.light(
                primary: Colors.grey,
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      constraints: BoxConstraints(
                          maxHeight: _getHeight(constraints),
                          maxWidth: _getWidth(constraints)),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            10.0), // Allows to leave some gap at the top and the bottom when the resizing is extreme
                        child: child!,
                      )),
                ],
              ));
        });
      },
    );

    if (pickedRange != null) {
      if (widget.onDateSelected != null) {
        setState(() {
          widget.onDateSelected!(pickedRange);
          _selectedStartDate = pickedRange.start;
          _selectedEndDate = pickedRange.end;
        });
      }
    }
  }

  double _getHeight(BoxConstraints constraints) {
    // Return either 900 or the current screen height upon resizing
    return min(900.0, constraints.maxHeight);
  }

  double _getWidth(BoxConstraints constraints) {
    // Return either 500 or the current screen width upon resizing
    return min(500.0, constraints.maxWidth);
  }
}
