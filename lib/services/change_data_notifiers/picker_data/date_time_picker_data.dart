import 'package:flutter/cupertino.dart';

class DateTimePickerData with ChangeNotifier {
  DateTime _selectedDateTime = DateTime.now().add(Duration(hours: 1));


  DateTime get selectedDateTime => _selectedDateTime;


  void reset() {
    _selectedDateTime = DateTime.now().add(Duration(hours: 1));
    notifyListeners();
  }

  void set selectedDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    notifyListeners();
  }

}