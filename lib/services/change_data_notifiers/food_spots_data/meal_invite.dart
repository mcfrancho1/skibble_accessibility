import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class MealInviteData with ChangeNotifier {
  String _createInviteTitle = '';
  DateTime _createInviteDateTime = DateTime.now().add(Duration(hours: 1));
  Address? _createHostLocation;
  bool _isLocationPrivate = false;


  DateTime get createInviteDateTime => _createInviteDateTime;
  String get createInviteTitle => _createInviteTitle;
  bool get isLocationPrivate => _isLocationPrivate;
  Address? get createHostLocation => _createHostLocation;


  void resetAll() {
    _createInviteTitle = '';
    _createInviteDateTime = DateTime.now().add(Duration(hours: 1));
    _createHostLocation;
    _isLocationPrivate = false;
    notifyListeners();
  }

  void set createInviteDateTime(DateTime dateTime) {
    _createInviteDateTime = dateTime;
    notifyListeners();
  }

  void set isLocationPrivate(bool isLocationPrivate) {
    _isLocationPrivate = isLocationPrivate;
    notifyListeners();
  }

  void set title(String title) {
    _createInviteTitle = title;
    notifyListeners();
  }

  void set createInviteAddress(Address address) {
    _createHostLocation = address;
    notifyListeners();
  }

  void createMealInvite() {

  }
}