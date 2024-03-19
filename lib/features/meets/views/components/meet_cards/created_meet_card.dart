import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/custom_image_widget.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';

import '../../../../../custom_icons/skibble_custom_icons_icons.dart';
import '../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../utils/constants.dart';
import '../../../controllers/meets_controller.dart';
import '../../../utils/meets_bottom_sheets.dart';

class CreatedMeetCard extends StatelessWidget {
  const CreatedMeetCard({Key? key, required this.meet}) : super(key: key);
  final SkibbleMeet meet;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return GestureDetector(
      onTap: () async{
        MeetsBottomSheets().showMeetDetailsSheet(context, meet);

      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400, width: 0.5)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: CustomNetworkImageWidget(
                imageUrl: meet.meetImage!,
                height: size.height / 5.5,
                width: double.infinity,

              ),

            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${DateFormat('EEE, dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))} at ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))}',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  const SizedBox(height: 3,),

                  Text(
                    meet.meetTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 3,),

                  Text(
                    '${meet.meetLocation!.address.city}',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight:  FontWeight.w500),
                  ),
                  const SizedBox(height: 3,),


                  Row(
                    children: [
                      Text(
                        '${meet.totalInterestedUsers} ${meet.totalInterestedUsers > 1 ?  'interests': 'interest'}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                      const SizedBox(width: 3,),


                      CircleAvatar(radius: 2, backgroundColor: Colors.grey.shade500,),
                      const SizedBox(width: 3,),
                      Text(
                        '${meet.totalInvitedUsers} ${meet.totalInvitedUsers > 1 ?  'invites': 'invite'}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_alt_rounded, size: 18, color: Colors.grey),
                          const SizedBox(width: 4,),
                          Text('${meet.maxNumberOfPeopleMeeting}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, ),
                          ),

                          const SizedBox(width: 6),
                          const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                          const SizedBox(width: 6),

                          const Icon(Icons.remove_red_eye_rounded, size: 18, color: Colors.grey,),
                          const SizedBox(width: 4,),
                          Text('${meet.meetPrivacyStatus.name.capitalizeFirst}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, ),
                          ),


                          const SizedBox(width: 6),
                          const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                          const SizedBox(width: 6),

                          const Icon(Icons.receipt_rounded, size: 18, color: Colors.grey),
                          const SizedBox(width: 4,),

                          Text(meet.meetBillsType == SkibbleMeetBillsType.myTreat ?
                          'My treat'
                              :
                          meet.meetBillsType == SkibbleMeetBillsType.meetPalsTreat ?
                          'Meet pals treat'
                              :
                          meet.meetBillsType == SkibbleMeetBillsType.split ?
                          'Split bills'
                              :
                          meet.meetBillsType == SkibbleMeetBillsType.random ?
                          'Random'
                              :
                          'On the table',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14,),
                          ),
                        ],
                      ),

                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}