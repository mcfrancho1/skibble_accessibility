import 'package:skibble/features/meets/models/skibble_meet.dart';

class OngoingMeetsStream {
  final List<SkibbleMeet> meetsList;

  OngoingMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meetId).toList();

}