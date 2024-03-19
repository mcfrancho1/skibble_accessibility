import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/features/meets/controllers/meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_filter_controller.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';
import 'package:skibble/features/meets/services/database/meets_database.dart';
import '../../models/created_meets_stream.dart';
import '../../models/nearby_meets_stream.dart';
import '../components/meet_card.dart';
import '../components/meet_cards/created_meet_card.dart';
import 'empty_state_meets_view.dart';

class CreatedMeetsListView extends StatefulWidget {
  const CreatedMeetsListView({Key? key}) : super(key: key);


  @override
  State<CreatedMeetsListView> createState() => _CreatedMeetsListViewState();
}

class _CreatedMeetsListViewState extends State<CreatedMeetsListView> {
  late final Stream<CreatedMeetsStream> createdMeetsStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    createdMeetsStream = MeetsDatabase().streamCreatedMeets(currentUser);
  }
 
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    return StreamBuilder<CreatedMeetsStream>(
      stream: createdMeetsStream,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Container();
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasData) {
              context.read<MeetsController>().createdMeets = snapshot.data!.meetsList;
              List<SkibbleMeet> meetsList = snapshot.data!.meetsList;

              return Consumer<MeetsFilterController>(
                builder: (context, filterData, child) {
                  if(filterData.meetFilter != null) {
                    var created = meetsList.map((e) => UserNearbyMeet(meet: e, meetStatus: e.meetStatus)).toList();
                    meetsList = context.read<MeetsController>().filterMeets(created, filterData.meetFilter!, currentUser).map((e) => e.meet).toList();

                  }
                  else {
                    meetsList = context.read<MeetsController>().createdMeets;
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
                        child: meetsList.isEmpty ? const EmptyStateMeetsView(message: 'No meets created') : ListView.builder(
                            itemCount: meetsList.length,
                            controller: context.read<MeetsController>().scrollController,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CreatedMeetCard(meet: meetsList[index],),
                              );
                            }),
                      ),

                      const SizedBox(height: 50,),

                    ],
                  );
                }
              );
            }
            else {
              return Container();
            }
        }
      }
    );
  }
}
