import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skibble/models/google_place_details.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/utils/custom_date_picker/controllers/date_picker_controller.dart';
import 'package:skibble/utils/time_slot/models/time_slot_interval.dart';

class MeetsDateTimeController with ChangeNotifier {
  DateTime? _selectedDateTime;
  DateTime? get selectedDateTime => _selectedDateTime;

  int selectedTime = 0;

  DateTime? _tempSelectedDateTime;
  DateTime? get tempSelectedDateTime => _tempSelectedDateTime;

  List<DateTime> openingHours = [];
  SkibbleFoodBusiness? business;
  TimeSlotInterval? timeSlotInterval;


  DatePickerController? datePickerController;

  void reset() {
    _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
    openingHours = [];
    business = null;
    timeSlotInterval = null;
    _tempSelectedDateTime = null;
    selectedTime = 0;
    notifyListeners();
  }

  initEditDateTime(DateTime dateTime) {

  }


  void selectTime(int index) {
    selectedTime = index;
    _tempSelectedDateTime = DateTime(_tempSelectedDateTime!.year, _tempSelectedDateTime!.month, _tempSelectedDateTime!.day, openingHours[index].hour, openingHours[index].minute);
    notifyListeners();
  }

  void setOpeningHours(List<DateTime> dateTime) {
    openingHours = dateTime;
    notifyListeners();
  }
  void set selectedDateTime(DateTime? dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

  void set tempSelectedDateTime(DateTime? dateTime) {
    _tempSelectedDateTime = dateTime;
    notifyListeners();
  }

  void onDateValueChanged(DateTime dateTime) {
    // openingHours = generateTimeAvailable(business!, dateTime);
    // var openTime = getOpenTime(business!, dateTime);
    // var closeTime = getCloseTime(business!, dateTime);

    var times = openingAndClosingTime(business!, dateTime);


    // timeSlotInterval = TimeSlotInterval(
    //     start: openTime != null ? TimeOfDay(
    //         hour: openTime.hour, minute: openTime.minute) : null,
    //     end: closeTime != null ? TimeOfDay(
    //         hour: closeTime.hour, minute: closeTime.minute) : null,
    //     interval: const Duration(minutes: 15),
    //     selectedDateTime: dateTime
    // );


    if(times[0] != null ) {
      _tempSelectedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day, times[0]!.hour, times[0]!.minute);
      //this is just to trigger the "Done" button
      openingHours = [DateTime.now()];
    }
    else {
      _tempSelectedDateTime =
          DateTime(dateTime.year, dateTime.month, dateTime.day, _tempSelectedDateTime!.hour, _tempSelectedDateTime!.minute);

      //this is just to trigger the "Done" button
      openingHours = [];
    }


    timeSlotInterval = TimeSlotInterval(
        start: times[0] != null ? TimeOfDay(hour: times[0]!.hour, minute: times[0]!.minute) : null,
        end: times[1] != null ? TimeOfDay(hour: times[1]!.hour, minute: times[1]!.minute) : null,
        startDateTime: times[0] != null ? DateTime(dateTime.year, dateTime.month, dateTime.day, times[0]!.hour, times[0]!.minute): null,
        endDateTime: times[1] != null ? DateTime(dateTime.year, dateTime.month, dateTime.day, times[1]!.hour, times[1]!.minute): null,

        interval: const Duration(minutes: 15),
        selectedDateTime: _tempSelectedDateTime
    );


    notifyListeners();
  }

  initDateTimePicker(SkibbleFoodBusiness foodBusiness) {
    var now = DateTime.now();
    business = foodBusiness;
    datePickerController = DatePickerController();
    if(_selectedDateTime != null ) {
      if(_selectedDateTime!.isAfter(now)) {
        datePickerController!.selectedDate = _selectedDateTime;
        _tempSelectedDateTime = _selectedDateTime;
        // openingHours = generateTimeAvailable(business!, datePickerController!.selectedDate!);
      }
      else {
        _selectedDateTime = null;
        _tempSelectedDateTime = now;
        datePickerController!.selectedDate = _tempSelectedDateTime;
      }

    }

    else {
      _tempSelectedDateTime = now;
      datePickerController!.selectedDate = _tempSelectedDateTime;

      // openingHours = generateTimeAvailable(business!, datePickerController!.selectedDate!);
      // if(openingHours.isNotEmpty) {
      //  _tempSelectedDateTime = DateTime(
      //       datePickerController!.selectedDate!.year,
      //       datePickerController!.selectedDate!.month,
      //       datePickerController!.selectedDate!.day,
      //       openingHours[0].hour,
      //       openingHours[0].minute
      //   );
      // }
    }

    //
    // var openTime = getOpenTime(business!, tempSelectedDateTime!);
    // var closeTime = getCloseTime(business!, tempSelectedDateTime!);

    // if (closeTime.isBefore(openTime)) {
    //   endDateTime = endDateTime.add(const Duration(days: 1)); // Restaurant spans across midnight
    // }



    var times = openingAndClosingTime(business!, _tempSelectedDateTime!);

    timeSlotInterval = TimeSlotInterval(
      start: times[0] != null ? TimeOfDay(hour: times[0]!.hour, minute: times[0]!.minute) : null,
      end: times[1] != null ? TimeOfDay(hour: times[1]!.hour, minute: times[1]!.minute) : null,
      startDateTime: times[0] != null ? DateTime(_tempSelectedDateTime!.year, _tempSelectedDateTime!.month, _tempSelectedDateTime!.day, times[0]!.hour, times[0]!.minute): null,
      endDateTime: times[1] != null ? DateTime(_tempSelectedDateTime!.year, _tempSelectedDateTime!.month, _tempSelectedDateTime!.day, times[1]!.hour, times[1]!.minute): null,
      interval: const Duration(minutes: 15),
      selectedDateTime: _tempSelectedDateTime
    );

  }

  List<DateTime?> openingAndClosingTime(SkibbleFoodBusiness business, DateTime dateTime) {
    var openTime = getOpenTime(business, dateTime);
    var closeTime = getCloseTime(business, dateTime);

    if(openTime != null && closeTime != null) {
      if (closeTime.isBefore(openTime)) {
        closeTime = openTime.add(const Duration(days: 1));
        return [openTime, closeTime]; // Restaurant spans across midnight
      }
    }

    return [openTime, closeTime];

  }


  double convertTimeOfDayToDouble(TimeOfDay timeOfDay) {
    return double.parse("${timeOfDay.hour}.${timeOfDay.minute}");
  }



  List<DateTime>? preProcessTime(DateTime openTime, DateTime closeTime) {
    var now = DateTime.now();



    var closeDouble = convertTimeOfDayToDouble(TimeOfDay(hour: closeTime.hour, minute: closeTime.minute));
    var openDouble = convertTimeOfDayToDouble(TimeOfDay(hour: openTime.hour, minute: openTime.minute));

    if(openDouble == closeDouble) {
      return [openTime, closeTime];
    }

    var isSelectedDateTimeToday = now.year == closeTime.year && now.month == closeTime.month && now.day == closeTime.day;

    var nowDouble = convertTimeOfDayToDouble(TimeOfDay(hour: now.hour, minute: now.minute));


    if(isSelectedDateTimeToday) {
      if(closeDouble <= nowDouble) {
        //if now is 30 mins > than max time(end time)
        if(nowDouble - closeDouble <= 0.5){
          return null;
        }
      }

      if(openDouble <= nowDouble) {
        openTime = DateTime(now.year, now.month, now.day, now.hour + 1, 0);

        if(openDouble + 1 >= closeDouble) {
          return null;
        }
      }
    }
    return [openTime, closeTime];

  }

  DateTime? getOpenTime(SkibbleFoodBusiness business, DateTime dateTime) {
    var now = DateTime.now();
    PlaceOpeningHoursPeriod timeOfDay;
    // String openFormattedString = start.substring(0, 2) + ':' + start.substring(2, 4);
    // String closeFormattedString = end.substring(0, 2) + ':' + end.substring(2, 4);
    if(business.googlePlaceDetails!.openingHours!.periods?.length == 1) {
      timeOfDay = PlaceOpeningHoursPeriod(open: PlaceOpeningHoursPeriodDetail(day: 0, time: '0000'));
    }

    else {
      timeOfDay = business.googlePlaceDetails!.openingHours!.periods!.firstWhere((element) => element.open!.day == (dateTime.weekday == 7 ? 0 : dateTime.weekday), orElse: () => PlaceOpeningHoursPeriod(open: PlaceOpeningHoursPeriodDetail(day: -1, time: '')));

    }


    if(timeOfDay.open!.day != -1) {
      String openFormattedString = '${timeOfDay.open!.time!.substring(0, 2)}:${timeOfDay.open!.time!.substring(2, 4)}';
      // String closeFormattedString = timeOfDay.close!.time!.substring(0, 2) + ':' + timeOfDay.close!.time!.substring(2, 4);

      var openTime = DateFormat("HH:mm").parse(openFormattedString);
      // var closeTime = DateFormat("HH:mm").parse(closeFormattedString);

      //I only need the hour and minutes
      openTime = DateTime(dateTime.year, dateTime.month, dateTime.day, openTime.hour, openTime.minute);
      // closeTime = DateTime(dateTime.year, dateTime.month, dateTime.day, closeTime.hour, closeTime.minute);

      return openTime;

    }

    return null;
  }

  DateTime? getCloseTime(SkibbleFoodBusiness business, DateTime dateTime) {

    // String openFormattedString = start.substring(0, 2) + ':' + start.substring(2, 4);
    // String closeFormattedString = end.substring(0, 2) + ':' + end.substring(2, 4);
    var timeOfDay;

    if(business.googlePlaceDetails!.openingHours!.periods?.length == 1) {
      timeOfDay = PlaceOpeningHoursPeriod(open: PlaceOpeningHoursPeriodDetail(day: 0, time: '2359'));
    }

    else {
      timeOfDay = business.googlePlaceDetails!.openingHours!.periods!.firstWhere((element) => element.open!.day == (dateTime.weekday == 7 ? 0 : dateTime.weekday), orElse: () => PlaceOpeningHoursPeriod(open: PlaceOpeningHoursPeriodDetail(day: -1, time: '')));
    }


    if(timeOfDay.open!.day != -1) {

      DateTime closeTime;
      if(timeOfDay.close != null) {
        String closeFormattedString = '${timeOfDay.close!.time!.substring(0, 2)}:${timeOfDay.close!.time!.substring(2, 4)}';
        closeTime = DateFormat("HH:mm").parse(closeFormattedString);
      }

      //there is no close time but 24hr service
      else {
        String closeFormattedString = '${timeOfDay.open!.time!.substring(0, 2)}:${timeOfDay.open!.time!.substring(2, 4)}';
        closeTime = DateFormat("HH:mm").parse(closeFormattedString);
      }

      //I only need the hour and minutes
      closeTime = DateTime(dateTime.year, dateTime.month, dateTime.day, closeTime.hour, closeTime.minute);

      closeTime = closeTime.subtract(const Duration(hours: 2));

      return closeTime;

    }
    return null;
  }


  List<DateTime> generateTimeAvailable(SkibbleFoodBusiness business, DateTime dateTime) {
    int step = 15;
    var nowTime = DateTime.now();

    // String openFormattedString = start.substring(0, 2) + ':' + start.substring(2, 4);
    // String closeFormattedString = end.substring(0, 2) + ':' + end.substring(2, 4);
    var timeOfDay = business.googlePlaceDetails!.openingHours!.periods!.firstWhere((element) => element.open!.day == (dateTime.weekday == 7 ? 0 : dateTime.weekday), orElse: () => PlaceOpeningHoursPeriod(open: PlaceOpeningHoursPeriodDetail(day: -1, time: '')));

    if(timeOfDay.open!.day != -1) {
      String openFormattedString = '${timeOfDay.open!.time!.substring(0, 2)}:${timeOfDay.open!.time!.substring(2, 4)}';
      String closeFormattedString = '${timeOfDay.close!.time!.substring(0, 2)}:${timeOfDay.close!.time!.substring(2, 4)}';

      var openTime = DateFormat("HH:mm").parse(openFormattedString);
      var closeTime = DateFormat("HH:mm").parse(closeFormattedString);

      //I only need the hour and minutes
      openTime = DateTime(dateTime.year, dateTime.month, dateTime.day, openTime.hour, openTime.minute);
      closeTime = DateTime(dateTime.year, dateTime.month, dateTime.day, closeTime.hour, closeTime.minute);


      if(closeTime.isBefore(openTime) || closeTime.isAtSameMomentAs(openTime)) {
        // int hrs = closeTime.hour - 0;
        // int mins = closeTime.minute;
        // // String end = '2300';
        // // String closeFormattedString = end.substring(0, 2) + ':' + end.substring(2, 4);
        // closeTime = DateFormat("HH:mm").parse('23:00');
        // closeTime = DateTime(dateTime.year, dateTime.month, dateTime.day, closeTime.hour, closeTime.minute);
        // closeTime = closeTime.add(Duration(hours: hrs + 1, minutes: mins));

        closeTime = closeTime.add(Duration(hours: 24));

      }

      if(openTime.isBefore(nowTime)) {
          openTime = openTime.add(Duration(hours: nowTime.hour - openTime.hour + 1));

          if((openTime.hour * 60 + openTime.minute) >= (closeTime.hour * 60 + closeTime.minute)) {
            return [];
          }
      }


      //we subtract 2 hrs from the close time to prevent you from meeting just before the restaurant closes
      if(closeTime.difference(openTime).inMinutes > 120) {
        closeTime = closeTime.subtract(const Duration(hours: 2));
      }

      var difference = closeTime.difference(openTime);


      return List.generate(difference.inMinutes ~/ step + 1, (index) => openTime.add(Duration(minutes: index * step)));

    }
    else {
      return [];
    }
  }
}