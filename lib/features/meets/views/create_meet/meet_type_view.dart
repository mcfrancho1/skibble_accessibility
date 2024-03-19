import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';

import '../../../../shared/user_image.dart';
import '../../../../utils/constants.dart';
import '../../controllers/meets_privacy_controller.dart';

class MeetTypeView extends StatelessWidget {
  const MeetTypeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'What type of Meet is this?',
              style: TextStyle(
                color: kDarkSecondaryColor,
                fontSize: 26,
                fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 15,),
            Text(
              'Choose who can see and ask to join. You still get to decide who gets to come to the meet.',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13
              ),
            ),

            const SizedBox(height: 15,),

            Consumer<MeetsPrivacyController>(
                builder: (context, data, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: List.generate(data.privacyPickerList.length, (index) {

                          return GestureDetector(
                            onTap: () {
                              data.userPrivacyChoiceIndex = index;

                              if(data.userPrivacyChoiceIndex == 1) {
                                MeetsBottomSheets().showPrivateMeetChooserViewSheet(context);
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  width: 2,
                                    color: data.userPrivacyChoiceIndex  == index ? kPrimaryColor : Colors.grey.shade200)
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(data.privacyListIcons[index], color: kDarkSecondaryColor,),
                                      const SizedBox(width: 10,),
                                      Text(data.privacyPickerList[index],
                                        style: const TextStyle(fontWeight: FontWeight.bold),),

                                    ],
                                  ),


                                  if(data.userPrivacyChoiceIndex  == index)
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
                            text: data.privacyPickerListDescription[data.userPrivacyChoiceIndex],
                            style: TextStyle(color: Colors.grey.shade600),
                          ),

                          if(data.userPrivacyChoiceIndex == 2)
                            TextSpan(
                              text: 'your meet would be visible in ',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),

                         if(data.userPrivacyChoiceIndex == 2)
                           TextSpan(
                             text: '${currentUserLocation?.city!}, ${currentUserLocation?.stateOrProvinceCode}.',
                             style: const TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.w600),
                           ),
                        ]
                      )),

                      const SizedBox(height: 30,),

                      if(data.selectedPrivateUsers.isNotEmpty && data.userPrivacyChoiceIndex == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Potential Meet pals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),

                              GestureDetector(
                                onTap: () {
                                  MeetsBottomSheets().showPrivateMeetChooserViewSheet(context);

                                },
                                child: const Icon(Iconsax.edit))
                            ],
                          ),
                          const Divider(),
                          const SizedBox(height: 10,),

                          Wrap(
                            spacing: 5,
                            runSpacing: 7,
                            children: List.generate(data.selectedPrivateUsers.length, (index) {
                              SkibbleUser selectedUser = data.selectedPrivateUsers[index];

                              return Container(
                                width: 175,
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, left: 5, right: 5),
                                margin: const EdgeInsets.only(
                                  right: 1,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: kPrimaryColor),
                                    color: kLightSecondaryColor),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          UserImage(
                                            width: 20,
                                            height: 20,
                                            user: selectedUser,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              data.selectedPrivateUsers[index]
                                                  .fullName!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      child: const Icon(
                                        Icons.cancel_rounded,
                                        color: kPrimaryColor,
                                      ),
                                      onTap: () {
                                        // if (_isFound) {
                                        data.removePrivateUserFromList(selectedUser);
                                        // }
                                      },
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  );
                }
            )
          ],
        ),
      ),
    );
  }
}
