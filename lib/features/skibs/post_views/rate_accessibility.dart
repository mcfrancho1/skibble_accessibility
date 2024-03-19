import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:skibble/shared/custom_app_bar.dart';

import '../../../utils/constants.dart';
import '../../meets/views/create_meet/accessibility_ratings_view.dart';


class RateAccessibilityView extends StatelessWidget {
  const RateAccessibilityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Rate Accessibility',
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
              SizedBox(height: 30,),



              Column(
                // shrinkWrap: true,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Based on your preferences', style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 16),),

                  SizedBox(height: 10,),
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
                        AccessibilityOptionsRatings(optionString: "parking", showRatingCount: false,)
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
                        AccessibilityOptionsRatings(optionString: "entrance", showRatingCount: false,)
                      ],
                    ),
                  ),

                  SizedBox(height: 20,),

                  Text('Other Ratings', style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 16),),
                  SizedBox(height: 8,),

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
                        AccessibilityOptionsRatings(optionString: "seating", showRatingCount: false,)
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
