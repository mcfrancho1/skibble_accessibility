import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';
import 'package:skibble/features/meets/views/components/meet_cards/ongoing_meet_card.dart';

import '../../controllers/meets_controller.dart';
import '../../models/nearby_meets_stream.dart';
import '../components/meet_card.dart';
import 'empty_state_meets_view.dart';

class OngoingMeetsListView extends StatefulWidget {
  const OngoingMeetsListView({Key? key}) : super(key: key);


  @override
  State<OngoingMeetsListView> createState() => _OngoingMeetsListViewState();
}

class _OngoingMeetsListViewState extends State<OngoingMeetsListView> {

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetsController>(
        builder: (context, data, child) {
          List<UserNearbyMeet> meetsList = data.ongoingMeets;
          return Column(
            children: [
              // Center(
              //   child: Text(
              //     "${meetsList.length} meets found",
              //     style: const TextStyle(
              //       fontWeight: FontWeight.w100,
              //       fontSize: 14.0,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 20,),


              Expanded(
                child: meetsList.isEmpty ? const EmptyStateMeetsView(message: 'No ongoing meets') : ListView.builder(
                    itemCount: meetsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OngoingMeetCard(meet: meetsList[index].meet,),
                      );
                    }),
              ),

              const SizedBox(height: 50,),

            ],
          );
        });
  }
}
