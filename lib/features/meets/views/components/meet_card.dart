import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';
import 'package:skibble/features/meets/views/meet_details_page.dart';

import '../../../../custom_icons/skibble_custom_icons_icons.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../shared/bottom_sheet_dialogs.dart';
import '../../../../utils/constants.dart';
import '../../../connect/components/connect_face_pile.dart';
import '../../models/skibble_meet.dart';

class MeetCard extends StatelessWidget {
  const MeetCard({Key? key, required this.meet}) : super(key: key);
  final SkibbleMeet meet;


  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return GestureDetector(
      onTap: ()
      {
        MeetsBottomSheets().showMeetDetailsSheet(context, meet);
        // context.read<SpotsData>().currentSpotToView = item;
        // context.read<SpotsData>().showCurrentSpotInfo(context, item: item);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: kContentColorLightTheme,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(meet.meetTitle, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                      SizedBox(height: 4,),
                      Text('By ${meet.meetCreator.fullName}', style: TextStyle(fontSize: 13, color: Colors.blueGrey),),
                    ],
                  ),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            '${DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime)).toUpperCase()}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            '${DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))}',
                            style: TextStyle(fontWeight: FontWeight.bold),

                          ),

                        ],
                      ),
                    ),
                  ),


                ],
              ),

              SizedBox(height: 15,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ConnectViewFacePile(spot: item,),

                  if(meet.meetCreator.userId != currentUser.userId)
                    GestureDetector(
                        onTap: () async{
                          await context.read<MeetsController>().askToJoinMeet(meet, currentUser, context);
                          // MeetsBottomSheets().showUpcomingMeetConflictSheet(context, meet);
                          // CustomBottomSheetDialog.showSpotConfirmationDialog(item, context);
                        },
                        child:
                        // Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryColor,)

                        Container(
                            height: 45,
                            width: 45,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor
                            ),
                            child: const Center(child: Icon(SkibbleCustomIcons.noun_hand_wave, size: 38)),
                            // SvgPicture.asset(
                            //   'assets/icons/wave_hand.svg',
                            //   width: 30,
                            //   height: 30,
                            //   color: kDarkSecondaryColor,
                            // )
                          // SvgPicture.asset(
                          //   'assets/icons/waving_hand.svg',
                          //   width: 25,
                          //   height: 25,
                          //   color: kDarkSecondaryColor,
                          // ),
                        )
                      // Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(text: 'show more', style: TextStyle(color: kPrimaryColor)),
                      //       WidgetSpan(
                      //         child: Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryColor,),
                      //         alignment: PlaceholderAlignment.middle
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    )

                  // Row(
                  //   children: [
                  //     Text('View Details'),
                  //
                  //     Icon(Icons.chevron_right_rounded)
                  //   ],
                  // )
                ],
              )

              // Row(
              //   children: [
              //     UserImage(width: 30, height: 30, user: item.mealHost)
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
