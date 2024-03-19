import 'package:flutter/material.dart';

class LoadingController with ChangeNotifier {

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingSecond = false;

  bool get isLoadingSecond => _isLoadingSecond;

  bool _isLoadingThird = false;

  bool get isLoadingThird => _isLoadingThird;

  void set isLoading(bool isLoggingIn) {
    _isLoading = isLoggingIn;
    notifyListeners();
  }

  void set isLoadingSecond(bool value) {
    _isLoadingSecond = value;
    notifyListeners();
  }

  void set isLoadingThird(bool value) {
    _isLoadingThird = value;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    notifyListeners();
  }
}