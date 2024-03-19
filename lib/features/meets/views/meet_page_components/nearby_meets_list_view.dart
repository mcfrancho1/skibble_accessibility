import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/models/nearby_meets_stream.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';

import '../../controllers/meets_filter_controller.dart';
import '../components/meet_card.dart';
import '../components/meet_cards/nearby_meet_card.dart';
import 'empty_state_meets_view.dart';

class NearbyMeetsListView extends StatelessWidget {
  const NearbyMeetsListView({Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<MeetsController,  MeetsFilterController>(
      builder: (context, meetsData, filterData, child) {
        List<UserNearbyMeet> meets = [];
        if(filterData.meetFilter != null) {
          meets = meetsData.filteredNearbyMeets;
        }
        else {
          meets = meetsData.nearbyMeets;
        }

        return Column(
          children: [
            // Center(
            //   child: Text(
            //     "${meets.length} meets found",
            //     style: const TextStyle(
            //       fontWeight: FontWeight.w600,
            //       fontSize: 14.0,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20,),
            Expanded(
              child: meets.isEmpty ? const EmptyStateMeetsView(message: 'No nearby meets') : ListView.builder(
                  itemCount: meets.length,
                  physics: PanelScrollPhysics(
                      controller: meetsData.panelController
                  ),
                  controller: meetsData.scrollController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: NearbyMeetCard(meet: meets[index].meet,)

                      // MeetCard(meet: meetsData.nearbyMeets[index].meet,),
                    );
                  }),
            ),

            const SizedBox(height: 50,),

          ],
        );
      }
    );
  }
}
