import 'package:flutter/material.dart';
import 'package:skibble/utils/constants.dart';

class RatingRod extends StatelessWidget {
  final String ratingNumber;
  final int totalNumberOfRatings;
  final int totalGroupRating;
  const RatingRod({
    Key? key,
    required this.totalNumberOfRatings,
    required this.ratingNumber,
    required this.totalGroupRating
  }) : super(key: key);

  final rodWidth = 180.0;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text(ratingNumber, style: TextStyle(fontSize: 15),),
        SizedBox(width: 5,),
        Container(
          width: rodWidth,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

              color: Colors.grey.withOpacity(0.3)
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: (rodWidth * totalGroupRating) / totalNumberOfRatings,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kPrimaryColor
              ),
            ),
          ),
        )
      ],
    );
  }
}