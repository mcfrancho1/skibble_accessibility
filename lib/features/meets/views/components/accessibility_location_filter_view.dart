import 'package:flutter/material.dart';

import '../../../../utils/custom_pickers/food_options_picker_view.dart';


class AccessibilityLocationFilterView extends StatelessWidget {
  const AccessibilityLocationFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    const maxChoice = 10;

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.keyboard_arrow_down_rounded, size: 24,),

                Column(
                  children: [
                    Text('Filter by', style: TextStyle(color: Colors.grey.shade400, fontSize: 15),),
                    Text('Accessibility options', style: TextStyle(fontSize: 16),)
                  ],
                ),

                Opacity(
                  opacity: 0,
                  child: Icon(Icons.accessibility_sharp))
              ],
            ),
          ),

          Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),

                //cuisines
                Text(
                  'Parking',
                  style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                SizedBox(height: 10,),

                WrappedAccessibilityOptions(optionString: 'parking', limit: maxChoice,),



                SizedBox(height: 30),

                //meal specific
                Text(
                  'Entrance',
                  style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                SizedBox(height: 10,),

                WrappedAccessibilityOptions(optionString: 'entrance', limit: maxChoice),


                SizedBox(height: 30),

                //cooking style
                Text(
                  'Seating',
                  style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                SizedBox(height: 10,),

                WrappedAccessibilityOptions(optionString: 'seating', limit: maxChoice),

                SizedBox(height: 30),

                //diet prescriptions
                Text(
                  'Restrooms',
                  style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                SizedBox(height: 10,),

                WrappedAccessibilityOptions(optionString: 'restroom', limit: maxChoice),


                SizedBox(height: 30),
                //custom
                Text(
                  'Menus',
                  style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                SizedBox(height: 10,),

                WrappedAccessibilityOptions(optionString: 'menu', limit: maxChoice)

              ],
            ),
          ),
        ],
      ),
    );
  }
}
