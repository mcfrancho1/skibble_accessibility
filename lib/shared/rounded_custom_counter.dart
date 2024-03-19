import 'package:flutter/material.dart';

import 'package:skibble/utils/constants.dart';

typedef void CounterChangeCallback(num value);

class RoundedCustomCounter extends StatelessWidget {

  final CounterChangeCallback? onChanged;

  RoundedCustomCounter({
    Key? key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.decimalPlaces,
    this.color,
    this.margin,
    this.padding,
    this.externalPadding,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 20,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;


  ///max value user can pick
  final num maxValue;

  /// decimal places required by the counter
  final int decimalPlaces;

  ///Currently selected integer value
  num selectedValue;

  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final num step;

  /// indicates the color of fab used for increment and decrement
  final Color? color;

  /// text style
  final TextStyle? textStyle;

  final double buttonSize;

  final EdgeInsets? padding;

  final EdgeInsets? externalPadding;

  final EdgeInsets? margin;

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged!((selectedValue + step));
      // selectedValue = minValue;
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged!((selectedValue - step));
      // selectedValue = minValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      padding: externalPadding ?? EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: onChanged == null ? Colors.grey : kPrimaryColor,
        boxShadow: kElevationToShadow[2],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(30),
                // radius: 25,
              onTap: _decrementCounter,
              child: Container(
                  width: 34,
                  height: 34,
                  margin: margin ?? EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 8),
                  child: Icon(Icons.remove, color: kLightSecondaryColor,))),
          ),
          Container(
            padding: padding ?? EdgeInsets.only(top: 4.0, left: 8, right: 8, bottom: 4),
            child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle ?? TextStyle(
                  fontSize: 20.0,
                  color: kLightSecondaryColor
                )
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            child: InkWell(
                borderRadius: BorderRadius.circular(30),
                // radius: 25,
                onTap: _incrementCounter,
                child: Container(
                    width: 34,
                    height: 34,
                    margin: EdgeInsets.only(top: 8.0, left: 8, right: 8, bottom: 8),
                    child: Icon(Icons.add, color: kLightSecondaryColor,))),
          ),
        ],
      ),
    );
  }
}