import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/utils/constants.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../models/skibble_meet.dart';


class MeetCreatorCancelMeetView extends StatefulWidget {
  const MeetCreatorCancelMeetView({Key? key, required this.meet,  required this.scoreToDeduct, required this.message}) : super(key: key);
  final SkibbleMeet meet;
  final int scoreToDeduct;
  final String message;

  @override
  State<MeetCreatorCancelMeetView> createState() => _MeetCreatorCancelMeetViewState();
}

class _MeetCreatorCancelMeetViewState extends State<MeetCreatorCancelMeetView> {
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Consumer<MeetsController>(
        builder: (context, data, child) {
          // int scoreToDeduct = 0;
          // var header = 'Delete Meet';
          // var buttonText = '';
          // var message = 'Are you sure you want to delete this meet?';
          //
          //
          // ///Meet Creator Penalties
          // //if you cancel/delete a meet after at least 1 person has shown interest, -1
          // //if you cancel/delete a meet after inviting at least 1 person, -2
          // // if you cancel/delete a meet that is ongoing, -3
          //
          // //a meet starts 1 hour before the actual meet time
          //  if(DateTime.fromMillisecondsSinceEpoch(widget.meet.meetDateTime).toLocal().difference(DateTime.now()).inHours < 1) {
          //    scoreToDeduct = 3;
          //    message = 'Are you sure you want to delete this meet? Your meet score will be affected';
          //  }
          //
          //   else if((widget.meet.invitedUsers ?? []).isNotEmpty) {
          //     scoreToDeduct = 2;
          //     message = 'Are you sure you want to delete this meet? Your meet score will be affected';
          //
          //   }
          //
          //   else if((widget.meet.interestedUsers ?? []).isNotEmpty) {
          //     scoreToDeduct = 1;
          //     message = 'Are you sure you want to delete this meet? Your meet score will be affected';
          //   }


          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Delete Meet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                const SizedBox(height: 6,),
                Text(widget.message, style: const TextStyle(fontSize: 14, color: Colors.grey),),
                const SizedBox(height: 20,),

                if(widget.scoreToDeduct != 0)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Your meet score will be deducted by', style: TextStyle(fontSize: 14, color: kDarkSecondaryColor,),),
                            const SizedBox(height: 8,),

                            Center(
                              child: Container(

                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(0xFF7C0F04)),
                                  color: const Color(0xFFF6EBEA)
                                ),
                                child: Text('${widget.scoreToDeduct} ${widget.scoreToDeduct > 1 ? 'points' : 'point'}', style: const TextStyle(color: Color(0xFF7C0F04), fontSize: 16, ),),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15,),
                    ],
                  ),

                Center(
                  child: ElevatedButton(
                    onPressed: () async{
                      Navigator.of(context).pop(true);
                      // await data.deleteMeet( _navigator.context,  widget.meet, scoreToDeduct);

                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30))
                        ),
                      backgroundColor: kDarkSecondaryColor,
                      elevation: 0
                    ),
                    child: const Text(
                      'Yes, delete this meet',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}



class CancelMeetView extends StatefulWidget {
  const CancelMeetView({Key? key, required this.meet, required this.scoreToDeduct, required this.message}) : super(key: key);
  final SkibbleMeet meet;
  final int scoreToDeduct;
  final String message;

  @override
  State<CancelMeetView> createState() => _CancelMeetViewState();
}

class _CancelMeetViewState extends State<CancelMeetView> {
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Consumer<MeetsController>(
      builder: (context, data, child) {
        // int scoreToDeduct = 0;
        // var header = '';
        // var buttonText = '';
        // var message = '';

        ///Meet pal penalties
        //if you leave a meet after showing interest, 0 will de deducted if you have not been invited.
        //if you leave a meet after showing interest, 2 will be deducted if you have been invited
        //if you leave a meet that is ongoing, 3 will be deducted

        //a meet starts 1 hour before the actual meet time

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Leave Meet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              const SizedBox(height: 6,),
              Text(widget.message, style: const TextStyle(fontSize: 14, color: Colors.grey),),
              const SizedBox(height: 20,),


              if(widget.scoreToDeduct != 0)
                Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text('Your meet score will be deducted by', style: TextStyle(fontSize: 14, color: kDarkSecondaryColor,),),
                          const SizedBox(height: 8,),

                          Center(
                            child: Container(

                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: const Color(0xFF7C0F04)),
                                  color: const Color(0xFFF6EBEA)
                              ),
                              child: Text('${widget.scoreToDeduct} ${widget.scoreToDeduct > 1 ? 'points' : 'point'}', style: const TextStyle(color: Color(0xFF7C0F04), fontSize: 16, ),),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),
                  ],
                ),


              Center(
                child: ElevatedButton(
                  onPressed: () async{
                    Navigator.of(context).pop(true);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    backgroundColor: kDarkSecondaryColor
                  ),
                  child: const Text(
                    'Yes, leave this meet',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
