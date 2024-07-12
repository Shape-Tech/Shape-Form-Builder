import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateFormField extends FormField<DateTime> {
  DateFormField({
    required String label,
    String? labelDescription,
    required FormFieldSetter<DateTime> onSaved,
    required FormFieldValidator<DateTime> validator,
    DateTime? initialValue,
    DateTime? originalValue,
  }) : super(
          onSaved: onSaved,
          validator: validator,
          initialValue: originalValue,
          builder: (FormFieldState<DateTime> state) {
            if (originalValue != null) {
              if (state.value == null) {
                state.setValue(originalValue);
              }
            }
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x4D1E1E1E),
                          offset: Offset.zero,
                          blurRadius: 5,
                          spreadRadius: 0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
                              Spacer(),
                            ],
                          ),
                          if (labelDescription != null)
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Text(labelDescription)),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: DateFormFieldPicker(
                                  validator: (date) {
                                    validator(date);
                                  },
                                  onDateSelected: (selectedDate) {
                                    state.setValue(selectedDate);
                                    onSaved(selectedDate);
                                  },
                                  preSelectedDate: originalValue,
                                  initialValue: initialValue,
                                ),
                              ),
                              if (originalValue != null)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text("Original Value: " +
                                      DateFormat('E MMM d, ' 'yy')
                                          .format(originalValue)),
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
              ),
            );
          },
        );
}

class DateFormFieldPicker extends StatefulWidget {
  String? Function(DateTime?)? validator;
  String? Function(DateTime?)? onDateSelected;
  DateTime? preSelectedDate;
  DateTime? initialValue;
  DateFormFieldPicker(
      {this.validator,
      this.onDateSelected,
      this.preSelectedDate,
      this.initialValue});

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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                      style: BorderStyle.solid, color: Colors.grey, width: 2),
                  color: Colors.white,
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(10))),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child:
                    Text(DateFormat('E MMM d, ' 'yy').format(_selectedDate!)),
              ),
            ),
          ),
          ElevatedButton(
            child: Text("Select Different Date"),
            onPressed: () {
              _selectDate(context, _selectedDate, widget.initialValue);
            },
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            child: Text("Select Date"),
            onPressed: () {
              _selectDate(context, _selectedDate, widget.initialValue);
            },
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
            data: ThemeData()
                .copyWith(colorScheme: ColorScheme.light(primary: Colors.grey)),
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
