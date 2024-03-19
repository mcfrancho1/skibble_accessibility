import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/models/nearby_meets_stream.dart';

import '../../controllers/meets_filter_controller.dart';
import '../components/meet_cards/pending_meet_card.dart';
import 'empty_state_meets_view.dart';



class PendingMeetsListView extends StatefulWidget {
  const PendingMeetsListView({Key? key}) : super(key: key);


  @override
  State<PendingMeetsListView> createState() => _PendingMeetsListViewState();
}

class _PendingMeetsListViewState extends State<PendingMeetsListView> {

  @override
  Widget build(BuildContext context) {
    return Consumer2<MeetsController, MeetsFilterController>(
        builder: (context, meetsData, filterData, child) {
          List<UserNearbyMeet> meetsList = [];
          if(filterData.meetFilter != null) {
            meetsList = meetsData.filteredPendingMeets;
          }
          else {
            meetsList = meetsData.pendingMeets;
          }
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
                child: meetsList.isEmpty ? const EmptyStateMeetsView(message: 'No pending meets') : ListView.builder(
                    itemCount: meetsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PendingMeetCard(meet: meetsList[index].meet,),
                      );
                    }),
              ),

              const SizedBox(height: 50,),

            ],
          );
        });
  }
}
