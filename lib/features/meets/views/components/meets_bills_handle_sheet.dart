import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../controllers/meets_bills_controller.dart';

class MeetBillsHandleSheet extends StatelessWidget {
  const MeetBillsHandleSheet({Key? key}) : super(key: key);

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
                child: Text('Who handles bills?',
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
              child: Text('Choose how the bills will be handled after the meet',
                style: TextStyle(
                  color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                  fontSize: 14,
                ),
              ),
            ),

            Consumer<MeetsBillsController>(
                builder: (context, data, child) {
                  return Column(
                    children: List.generate(data.billsHandlerPickerList.length, (index) => RadioListTile<int>(
                      // contentPadding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                      controlAffinity: ListTileControlAffinity.trailing,
                      activeColor: kPrimaryColor,
                      secondary:  CircleAvatar(
                        child: Icon(data.billsHandlerPickerListIcons[index], color: kDarkSecondaryColor,),
                        backgroundColor: Colors.grey.shade200,
                      ),
                      title: Text(data.billsHandlerPickerList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: Text(data.billsHandlerPickerListDescription[index]),
                      value: index, groupValue: data.userBillsTypeChoiceIndex,
                      onChanged: (value) {
                        context.read<MeetsBillsController>().userBillsTypeChoiceIndex = value!;
                      },
                    ),
                    ),
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
