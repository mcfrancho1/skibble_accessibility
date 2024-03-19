import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';
import 'package:skibble/utils/constants.dart';



class MaxNumberOfPeopleSlider extends StatefulWidget {
  const MaxNumberOfPeopleSlider({Key? key, this.maxValue = 9, this.minValue = 1, this.initialValue = 1, required this.onChanged}) : super(key: key);

  final Function(double) onChanged;
  final double initialValue;
  final double minValue;
  final double maxValue;
  @override
  State<MaxNumberOfPeopleSlider> createState() => _MaxNumberOfPeopleSliderState();
}

class _MaxNumberOfPeopleSliderState extends State<MaxNumberOfPeopleSlider> {
  double maxNumberOfPeople = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    maxNumberOfPeople = widget.initialValue;
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Align(
            alignment: Alignment.topRight,
            child: Text(
              '${maxNumberOfPeople.toInt()} ${maxNumberOfPeople.toInt() > 1 ? 'meet pals': 'meet pal'}',
              style: TextStyle(fontSize: 15, color: kDarkSecondaryColor),
            )),

        Slider.adaptive(
            value: maxNumberOfPeople,
            max: widget.maxValue,
            min: widget.minValue,
            inactiveColor: Colors.grey,
            divisions: (widget.maxValue - widget.minValue).toInt(),
            label: '$maxNumberOfPeople',
            onChanged: (value) {
              setState(() {
                maxNumberOfPeople = value;
              });
              widget.onChanged(value);
            }),
      ],
    );
  }
}
