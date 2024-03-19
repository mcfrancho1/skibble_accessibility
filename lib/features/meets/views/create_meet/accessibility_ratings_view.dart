import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/custom_app_bar.dart';

import '../../../../services/change_data_notifiers/picker_data/accessibility_options_picker_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/rating_utils.dart';


class AccessibilityRatingView extends StatelessWidget {
  const AccessibilityRatingView({super.key});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: CustomAppBar(title: 'Accessibility Ratings',
        // actions: [TextButton(onPressed: () {}, child: Text('Cancel', style: TextStyle(color: kDarkColor),))],

      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [

              SizedBox(height: 30,),
              Center(child: Text('Average Ratings', style: TextStyle(fontSize: 20),)),


              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPrimaryColor),

                ),
                margin: EdgeInsets.symmetric(vertical: 10),

                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.star, size: 20, color: kDarkColor,),
                      SizedBox(width: 4,),
                      Text('4.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),



              Column(
                // shrinkWrap: true,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: ExpansionTile(
                      title: Text("Parking"),
                      textColor: kDarkColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade400)),
                      children: [
                        AccessibilityOptionsRatings(optionString: "parking")
                      ],
                    ),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ExpansionTile(
                      title: Text("Entrance"),
                      textColor: kDarkColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade400)),
                      children: [
                        AccessibilityOptionsRatings(optionString: "entrance")
                      ],
                    ),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: ExpansionTile(
                      title: Text("Seating"),
                      textColor: kDarkColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.grey.shade400)),
                      children: [
                        AccessibilityOptionsRatings(optionString: "seating")
                      ],
                    ),
                  ),


                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


class AccessibilityOptionsRatings extends StatelessWidget {
  const AccessibilityOptionsRatings({Key? key, this.showRatingCount = true, required this.optionString, this.limit = 10}) : super(key: key);
  final String optionString;
  final int? limit;
  final bool showRatingCount;
  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityOptionsPickerData>(
        builder: (context, data, child) {
          List<String> foodList = [];
          switch(optionString) {
            case 'parking':
              foodList = data.parking;
              break;
            case 'seating':
              foodList = data.seating;
              break;
            case 'entrance':
              foodList = data.entrance;
              break;

            case 'restroom':
              foodList = data.restroom;
              break;

            case 'menu':
              foodList = data.menu;
              break;

          // case 'restroom':
          //   foodList = data.re;
          //   break;

          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: List.generate(foodList.length, (index) =>
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(foodList[index].capitalizeFirst!, style: TextStyle(fontSize: 15),),
                              SizedBox(height: 8,),
                              RatingBarIndicator(
                                rating: 4,
                                itemBuilder: (context, index) =>
                                // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                  child: Container(
                                    // height: 0,
                                    // width: 20,
                                    decoration: BoxDecoration(
                                        color: RatingUtils.generateRatingColor(index),
                                        // borderRadius: BorderRadius.circular(8),
                                        shape: BoxShape.circle
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.star_rounded,
                                        size: 15,
                                        color: kLightSecondaryColor,),
                                    ),
                                  ),
                                ),
                                itemCount: 5,
                                unratedColor: Colors.grey.shade300,
                                itemSize: 18.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),

                          if(showRatingCount)
                            Text('(${Random().nextInt(30) + 1})', style: TextStyle(color: kTextGreyColor),)

                        ],
                      ),

                      if( index < foodList.length - 1)
                        Divider(color: Colors.grey.shade300,)
                    ],
                  ),
                )
            ),
          );
        }
    );
  }
}

