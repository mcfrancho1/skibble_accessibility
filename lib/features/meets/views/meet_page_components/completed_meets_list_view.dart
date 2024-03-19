import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';

import '../../models/completed_meets_stream.dart';

class CompletedMeetsListView extends StatelessWidget {
  const CompletedMeetsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CompletedMeetsStream>(
      builder: (context, data, child) {
        List<SkibbleMeet> meetsList = data.meetsList;
        return ListView.builder(
            itemCount: meetsList.length,
            itemBuilder: (context, index) {
              return Container(
                height: 300,
                color: Colors.grey,
              );
            });
      }
    );
  }
}
