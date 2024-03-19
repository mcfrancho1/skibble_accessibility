import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_privacy_controller.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';

import '../../../../custom_icons/skibble_custom_icons_icons.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../shared/bottom_sheet_dialogs.dart';
import '../../../../utils/constants.dart';
import '../../controllers/create_edit_meets_controller.dart';
import '../../controllers/meets_controller.dart';
import '../../models/skibble_meet.dart';
import 'interested_invited_meet_pals.dart';

class MeetMenuOptionsView extends StatelessWidget {
  const MeetMenuOptionsView({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Consumer<MeetsController>(
      builder: (context, data, child) {
        var meet = data.selectedMeetForDetails;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              // if(meet!.meetCreator.userId == currentUser.userId && (meet.interestedUsers ?? []).isEmpty &&  (meet.invitedUsers ?? []).length < 2)
              //   ListTile(
              //   title: const Text('Edit'),
              //   leading: const Icon(Iconsax.edit),
              //   onTap: () async{
              //     CustomBottomSheetDialog.showProgressSheet(context);
              //     var res = await context.read<CreateEditMeetsController>().initEditMeet(context, meet);
              //     Navigator.pop(context);
              //
              //     if(res) {
              //       // if(Navigator.canPop(context))
              //       //   Navigator.pop(context);
              //
              //
              //       MeetsBottomSheets().showCreateMeetSheet(context);
              //     }
              //   },
              // ),

              ListTile(
                title: const Text('Remix'),
                leading: const Icon(CupertinoIcons.wand_stars),
                onTap: () async{
                  CustomBottomSheetDialog.showProgressSheet(context);
                  var res = await context.read<CreateEditMeetsController>().initRemixMeet(context, meet!);
                  Navigator.pop(context);

                  if(res) {
                    // if(Navigator.canPop(context))
                    //   Navigator.pop(context);

                    MeetsBottomSheets().showCreateMeetSheet(context);

                  }
                },
              ),

              ListTile(
                title: const Text('View meet pals'),
                leading: const Icon(Iconsax.people),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InterestedInvitedMeetPals(index: 0,)));

                },
              ),

              Builder(builder: (context) {

                if(meet!.meetCreator.userId == currentUser.userId) {
                  return ListTile(
                    title: const Text('Delete meet', style: TextStyle(color: kErrorColor),),
                    leading: const Icon(Iconsax.trash, color: kErrorColor),
                    onTap: () async{
                      context.read<MeetsController>().handleMeetDelete(context, meet, currentUser);

                    },
                  );
                }

                else if(meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private) {
                  return Consumer<MeetsPrivacyController>(
                    builder: (context, data, child) {
                      return ListTile(
                        title: const Text('Make a decision',),
                        leading: const Icon(CupertinoIcons.sparkles, ),
                        onTap: () async{
                          await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                        },
                      );
                    }
                  );
                }
                else {
                  if(data.getMeetStatus(meet) == SkibbleMeetStatus.nearby) {
                    return ListTile(
                      title: const Text('Ask to Join'),
                      leading: const Icon(SkibbleCustomIcons.noun_hand_wave, size: 30,),
                      onTap: () async{
                        // await context.read<MeetsController>().startMeet(context, meet, currentUser);
                        await context.read<MeetsController>().askToJoinMeet(meet, currentUser, context);

                      },
                    );
                  }


                  else if(data.getMeetStatus(meet) == SkibbleMeetStatus.pending) {
                    return ListTile(
                      title: const Text('Not interested'),
                      leading: const Icon(CupertinoIcons.hand_thumbsdown_fill),
                      onTap: () async{
                        await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                      },
                    );
                  }


                  else if(data.getMeetStatus(meet) == SkibbleMeetStatus.upcoming) {
                    return ListTile(
                      title: const Text('Leave meet', style: TextStyle(color: kErrorColor),),
                      leading: const Icon(Icons.logout, color: kErrorColor),
                      onTap: () async{
                        await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                      },
                    );
                  }


                  // else if(data.getMeetStatus(meet) == SkibbleMeetStatus.ongoing) {
                  //   return ListTile(
                  //     title: const Text('Start meet'),
                  //     leading: const Icon(SkibbleCustomIcons.noun_hand_wave),
                  //     onTap: () async{
                  //       // await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);
                  //
                  //     },
                  //   );
                  // }

                  else {
                    return Container();
                  }
                }
              })
            ],
          ),
        );
      }
    );
  }
}
