import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../utils/constants.dart';
import '../../controllers/meets_privacy_controller.dart';


class PrivateMeetChoiceView extends StatelessWidget {
  const PrivateMeetChoiceView({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: Consumer<MeetsPrivacyController>(
          builder: (context, data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Are you going to this private meet?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),

                const SizedBox(height: 5,),

                const Text('Let the meet creator know if you are coming for this meet.', style: TextStyle(fontSize: 13, color: Colors.grey),),

                const SizedBox(height: 10,),

                Column(
                  mainAxisSize: MainAxisSize.min,

                  children: List.generate(data.meetPalPrivateMeetChoiceList.length, (index) {

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        data.meetPalPrivateMeetChoiceIndex = index;

                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 2,
                                color: data.meetPalPrivateMeetChoiceIndex  == index ? kPrimaryColor : Colors.grey.shade200)
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(data.meetPalPrivateMeetChoiceIndex  == index ? data.meetPalPrivateMeetChoiceListSelectedIcons[index]
                                    :
                                data.meetPalPrivateMeetChoiceListUnSelectedIcons[index],
                                  color: data.meetPalPrivateMeetChoiceIndex  == index ? kPrimaryColor : kDarkSecondaryColor,
                                ),
                                const SizedBox(width: 10,),
                                Text(data.meetPalPrivateMeetChoiceList[index],
                                  style: const TextStyle(fontWeight: FontWeight.bold),),

                              ],
                            ),


                            if(data.meetPalPrivateMeetChoiceIndex  == index)
                              const Icon(Icons.check_circle_rounded, color: kPrimaryColor,)
                          ],
                        ),
                      ),
                    );

                  }
                  ),
                ),
                const SizedBox(height: 10,),

              ],
            );
          }
      ),
    );
  }

}
