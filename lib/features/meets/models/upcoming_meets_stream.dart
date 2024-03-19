import 'package:skibble/features/meets/models/skibble_meet.dart';

class UpcomingMeetsStream {
  final List<SkibbleMeet> meetsList;

  UpcomingMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meetId).toList();

}