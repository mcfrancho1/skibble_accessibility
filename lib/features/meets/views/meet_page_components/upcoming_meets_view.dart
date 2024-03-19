import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_filter_controller.dart';
import 'package:skibble/features/meets/models/nearby_meets_stream.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import '../components/meet_cards/upcoming_meet_card.dart';
import 'empty_state_meets_view.dart';

class UpcomingMeetsListView extends StatefulWidget {
  const UpcomingMeetsListView({Key? key}) : super(key: key);


  @override
  State<UpcomingMeetsListView> createState() => _UpcomingMeetsListViewState();
}

class _UpcomingMeetsListViewState extends State<UpcomingMeetsListView> with AutomaticKeepAliveClientMixin{


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer2<MeetsController, MeetsFilterController>(
        builder: (context, meetsData, filterData, child) {
          List<UserNearbyMeet> meetsList = [];
          if(filterData.meetFilter != null) {
            meetsList = meetsData.filteredUpcomingMeets;
          }
          else {
            meetsList = meetsData.upcomingMeets;
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
              child: meetsList.isEmpty ? const EmptyStateMeetsView(message: 'No upcoming meets') : ListView.builder(
                  itemCount: meetsList.length,
                  physics: PanelScrollPhysics(
                      controller: meetsData.panelController
                  ),
                  controller: meetsData.scrollController,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: UpcomingMeetCard(meet: meetsList[index].meet,),
                    );
                  }),
            ),

            const SizedBox(height: 50,),

          ],
        );
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
