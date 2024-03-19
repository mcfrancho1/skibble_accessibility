import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants.dart';
import '../../models/skibble_meet.dart';

class UpcomingMeetConflict extends StatelessWidget {
  const UpcomingMeetConflict({Key? key, required this.meet}) : super(key: key);
  final SkibbleMeet meet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Oops!', style: TextStyle(color: kDarkSecondaryColor, fontSize: 20, fontWeight: FontWeight.w600),),

          const SizedBox(height: 10,),
          const Text('This meet has a conflict with one of your upcoming meets below.',
            style: TextStyle(color: kDarkSecondaryColor, fontSize: 14, ),),

          const SizedBox(height: 10,),

          const Text('Join another meet that is at least 3 hours apart.',
            style: TextStyle(color: kDarkSecondaryColor, fontSize: 14, ),),

          const SizedBox(height: 5,),
          const Divider(),

          const Text('Meet Conflict', style: TextStyle(color: kDarkSecondaryColor, fontSize: 15, fontWeight: FontWeight.w500),),

          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime)).toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          Text(
                            DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime)),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${meet.meetTitle} at ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))}', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                      const SizedBox(height: 4,),
                      Text('By ${meet.meetCreator.fullName}', style: const TextStyle(fontSize: 13, color: Colors.grey),),
                    ],
                  ),
                ],
              ),

              // Icon(Icons.arrow_forward_ios_rounded, color: kPrimaryColor,)
            ],
          ),
          const SizedBox(height: 10,),

        ],
      ),
    );
  }
}
