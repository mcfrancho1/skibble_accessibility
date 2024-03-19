import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../../../services/change_data_notifiers/picker_data/privacy_picker_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/custom_pickers/food_options_picker_view.dart';
import '../../controllers/meets_privacy_controller.dart';

class MeetsPrivacyPickerView extends StatelessWidget {
  const MeetsPrivacyPickerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                child: Text('Meets privacy',
                  style: TextStyle(
                      color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10, bottom: 10 ),
              child: Text('Choose who can see and accept this invite. You still get to decide who gets to come to the invite.',
                style: TextStyle(
                  color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ),

            Consumer<MeetsPrivacyController>(
              builder: (context, data, child) {
                return Column(
                  children: List.generate(data.privacyPickerList.length, (index) => RadioListTile<int>(
                    // contentPadding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: kPrimaryColor,
                    secondary:  CircleAvatar(
                      child: Icon(data.privacyListIcons[index], color: kDarkSecondaryColor,),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    title: Text(data.privacyPickerList[index],
                    style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(data.privacyPickerListDescription[index]),
                    value: index, groupValue: data.userPrivacyChoiceIndex,
                    onChanged: (value) {
                    context.read<MeetsPrivacyController>().userPrivacyChoiceIndex = value!;
                  },
                  ),),
                );
              }
            )
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: InkWell(
            //     customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            //     onTap: () async{
            //       Navigator.pop(new_context);
            //       // _navigator.restorablePush(_dialogBuilder);
            //       // _navigator.push(MaterialPageRoute(builder: (context) {
            //       //   return CreateMealInvite();
            //       // }));
            //     },
            //     child: Container(
            //       padding: EdgeInsets.symmetric(vertical: 10),
            //       width: double.infinity,
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Text('Meal Invite'),
            //         ],
            //       ),
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           border: Border.all(color: kDarkSecondaryColor)
            //       ),
            //     ),
            //   ),
            // )
          ],
        )
    );
  }
}
