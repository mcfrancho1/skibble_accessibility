// library counter;

import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

typedef void CounterChangeCallback(num value);
typedef void CounterValueDeleteCallback();


class CustomCounter extends StatelessWidget {

  final CounterChangeCallback onChanged;
  final CounterValueDeleteCallback onDelete;

  CustomCounter({
    Key? key,
    required num initialValue,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    required this.onDelete,
    required this.decimalPlaces,
    required this.uniqueHeroTag,
    this.color,
    this.textStyle,
    this.step = 1,
    this.buttonSize = 35,
  })  : assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedValue = initialValue,
        super(key: key);

  ///min value user can pick
  final num minValue;

  final String uniqueHeroTag;

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

  void _incrementCounter() {
    if (selectedValue + step <= maxValue) {
      onChanged((selectedValue + step));
      // selectedValue = minValue;
    }
  }

  void _decrementCounter() {
    if (selectedValue - step >= minValue) {
      onChanged((selectedValue - step));
      // selectedValue = minValue;
    }
    else if (selectedValue - step == 0) {
      onDelete();
      // selectedValue = minValue;
    }
  }

  void _delete() {

  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [



          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child:

            FloatingActionButton(
              onPressed: _decrementCounter,
              heroTag: 'decrement$uniqueHeroTag',
              elevation: 2,

              tooltip: 'Decrement',
              child: Icon( Icons.remove,
                color :  selectedValue <= minValue ? Colors.grey : CurrentTheme(context).isDarkMode ?  kLightSecondaryColor: kPrimaryColor,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              backgroundColor: color != null ? color : CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor
            ),
          ),

          // InkWell(
          //   // onTap: _decrementCounter,
          //     child: Container(
          //       padding: EdgeInsets.all(8.0),
          //       child: Icon(Icons.remove),
          //       decoration: BoxDecoration(
          //           borderRadius: BorderRadius.circular(10),
          //           color: selectedValue <= minValue ? Colors.grey.shade300 : color != null ? color : CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kLightSecondaryColor
          //       ),
          //     )),

          Container(
            padding: EdgeInsets.only(top: 4.0, left: 8, right: 8, bottom: 4),
            child: Text(
                '${num.parse((selectedValue).toStringAsFixed(decimalPlaces))}',
                style: textStyle ?? TextStyle(
                  fontSize: 20.0,
                )
            ),
          ),
          SizedBox(
            width: buttonSize,
            height: buttonSize,
            child: FloatingActionButton(
              onPressed: _incrementCounter,
              heroTag: 'increment$uniqueHeroTag',
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              tooltip: 'Increment',
              child: Icon(
                Icons.add,
                color : CurrentTheme(context).isDarkMode ?  kLightSecondaryColor: kPrimaryColor,
              ),
              backgroundColor: color != null ? color : CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}