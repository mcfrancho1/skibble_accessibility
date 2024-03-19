import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_bills_controller.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/constants.dart';
import '../../controllers/meets_privacy_controller.dart';

class MeetBillsHandleView extends StatelessWidget {
  const MeetBillsHandleView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'How will bills be handled?',
            style: TextStyle(
                color: kDarkSecondaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold
            ),
          ),

          const SizedBox(height: 15,),
          Text(
            'Choose how the bills will be handled after the meet.',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13
            ),


          ),

          const SizedBox(height: 15,),

          Consumer<MeetsBillsController>(
              builder: (context, data, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: List.generate(data.billsHandlerPickerList.length, (index) {

                        return GestureDetector(
                          onTap: () {
                            data.userBillsTypeChoiceIndex = index;
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 2,
                                    color: data.userBillsTypeChoiceIndex  == index ? kPrimaryColor : Colors.grey.shade200)
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(data.billsHandlerPickerListIcons[index], color: kDarkSecondaryColor,),
                                    const SizedBox(width: 10,),
                                    Text(data.billsHandlerPickerList[index],
                                      style: const TextStyle(fontWeight: FontWeight.bold),),

                                  ],
                                ),


                                if(data.userBillsTypeChoiceIndex  == index)
                                  const Icon(Icons.check_circle_rounded, color: kPrimaryColor,)
                              ],
                            ),
                          ),
                        );
                      }
                      ),
                    ),
                    const SizedBox(height: 10,),

                    RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: data.billsHandlerPickerListDescription[data.userBillsTypeChoiceIndex],
                            style: TextStyle(color: Colors.grey.shade600),
                          ),

                        ]
                    ))
                  ],
                );
              }
          )
        ],
      ),
    );
  }
}
