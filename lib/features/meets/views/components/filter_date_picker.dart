import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class MeetFilterDateTime extends StatelessWidget {
  const MeetFilterDateTime({Key? key, required this.dates, required this.onDatesChanged}) : super(key: key);
  final List<DateTime?> dates;
  final ValueChanged<List<DateTime?>> onDatesChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Text(
              'Select Dates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          CalendarDatePicker2WithActionButtons(
            config:  CalendarDatePicker2WithActionButtonsConfig(
              calendarType: CalendarDatePicker2Type.range,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 90))
            ),
            value: dates,
            onValueChanged: onDatesChanged,
            onCancelTapped: () => Navigator.pop(context),
            onOkTapped: () => Navigator.pop(context),
          ),

          SizedBox(height: 30,)
        ],
      ),
    );
  }
}
