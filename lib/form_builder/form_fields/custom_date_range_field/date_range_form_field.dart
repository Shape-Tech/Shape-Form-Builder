import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shape_form_builder/extensions/widget_extensions.dart';
import 'package:shape_form_builder/form_builder/constants.dart';
import 'package:shape_form_builder/form_builder/shape_form_styling.dart';

class DateRangeFormField extends FormField<DateTimeRange> {
  DateRangeFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<DateTimeRange> onSaved,
    required FormFieldValidator<DateTimeRange> validator,
    DateTimeRange? initialValue,
    DateTimeRange? originalValue,
    ShapeFormStyling? styling,
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
              decoration: styling?.containerDecoration ??
                  BoxDecoration(
                      color: styling?.background ?? Colors.white,
                      border: Border.all(
                          color: styling?.border ?? Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(
                          styling?.borderRadiusMedium ?? 8)),
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
                        const Spacer(),
                      ],
                    ),
                    if (labelDescription != null) ...[
                      Gap(spacing),
                      Text(labelDescription),
                    ],
                    Gap(spacing),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DateRangeFormFiledPicker(
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
                          styling: styling,
                        ),
                        if (originalValue != null) ...[
                          Gap(spacing),
                          Text(
                            "Original Value: ${DateFormat('E MMM d, ' 'yy').format(originalValue.start)} - ${DateFormat('E MMM d, ' 'yy').format(originalValue.end)}",
                          ),
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

class DateRangeFormFiledPicker extends StatefulWidget {
  String? Function(DateTimeRange?)? validator;
  String? Function(DateTimeRange?)? onDateSelected;
  DateTime? preSelectedStartDate;
  DateTime? preSelectedEndDate;
  DateTimeRange? initialValue;
  ShapeFormStyling? styling;
  DateRangeFormFiledPicker(
      {this.validator,
      this.onDateSelected,
      this.preSelectedStartDate,
      this.preSelectedEndDate,
      this.initialValue,
      this.styling});

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
                        widget.styling?.borderRadiusMedium ?? 8))),
            child: Text(
                    "${DateFormat('E MMM d, ' 'yy').format(_selectedStartDate!)} - ${DateFormat('E MMM d, ' 'yy').format(_selectedEndDate!)}")
                .allPadding(padding / 2),
          ),
          Gap(spacing),
          ElevatedButton(
            style: widget.styling?.secondaryButtonStyle ??
                FormButtonStyles.secondaryButton,
            child: Container(
                width: double.infinity,
                child: Center(child: Text("Select Different Dates"))),
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
            style: widget.styling?.secondaryButtonStyle ??
                FormButtonStyles.secondaryButton,
            child: Container(
                width: double.infinity,
                child: Center(child: Text("Select Dates"))),
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
                primary: widget.styling?.secondary ?? FormColors.secondary,
                secondary:
                    widget.styling?.secondaryLight ?? FormColors.secondaryLight,
                surface: widget.styling?.background ?? Colors.white,
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
