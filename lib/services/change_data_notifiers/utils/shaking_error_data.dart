import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_animations/simple_animations.dart';

class ShakingErrorController extends ChangeNotifier {
  String _errorText;
  bool _isVisible = true;
  bool _isMounted = true;

  Control _controlSignal = Control.play;

  ShakingErrorController(
      {String initialErrorText = 'Error', bool revealWithAnimation = true, bool hiddenInitially = true})
      : _errorText = initialErrorText ?? '',
        _isVisible = !hiddenInitially,
        _controlSignal = (revealWithAnimation ?? true) ? Control.play : Control.stop;

  set errorText(String errorText) {
    _errorText = errorText;
    notifyListeners();
  }

  void onAnimationStarted() {
    _controlSignal = Control.play;
  }

  void shakeErrorText() {
    _controlSignal = Control.playFromStart;
    notifyListeners();
  }

  ///fully [unmount] and remove the error text
  void unMountError() {
    _isMounted = false;
    notifyListeners();
  }

  ///[remount] error text. will not be effective if its already mounted
  void mountError() {
    _isMounted = true;
    notifyListeners();
  }

  ///hide the error. but it will still be taking its space.
  void hideError() {
    _isVisible = false;
    notifyListeners();
  }

  ///just shows error without any animation
  void showError() {
    _isVisible = true;
    notifyListeners();
  }

  bool get isMounted => _isMounted;

  ///shows error with the reveal [animation]
  void revealError() {
    showError();
    shakeErrorText();
  }

  bool get isVisible => _isVisible;

  String get errorText => _errorText;

  Control get controlSignal => _controlSignal;
}