import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants.dart';
import '../../models/skibble_meet.dart';

class OngoingMeetConflict extends StatelessWidget {
  const OngoingMeetConflict({Key? key, required this.meet}) : super(key: key);
  final SkibbleMeet meet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Oopsies!', style: TextStyle(color: kDarkSecondaryColor, fontSize: 20, fontWeight: FontWeight.w600),),

          SizedBox(height: 10,),
          Text('This meet has a conflict with your ongoing meet below.',
            style: TextStyle(color: kDarkSecondaryColor, fontSize: 14, ),),

          SizedBox(height: 10,),

          Text('Join another meet that is at least 2 hours apart.',
            style: TextStyle(color: kDarkSecondaryColor, fontSize: 14, ),),

          SizedBox(height: 5,),
          Divider(),

          Text('Meet Conflict', style: TextStyle(color: kDarkSecondaryColor, fontSize: 15, fontWeight: FontWeight.w500),),

          SizedBox(height: 10,),
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

                  SizedBox(width: 10,),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${meet.meetTitle} at ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))}', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
                      SizedBox(height: 4,),
                      Text('By ${meet.meetCreator.fullName}', style: TextStyle(fontSize: 13, color: Colors.grey),),
                    ],
                  ),
                ],
              ),

              // Icon(Icons.arrow_forward_ios_rounded, color: kPrimaryColor,)
            ],
          ),
          SizedBox(height: 10,),

        ],
      ),
    );
  }
}
