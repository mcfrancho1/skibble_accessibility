import 'package:skibble/features/meets/models/skibble_meet.dart';

class PendingMeetsStream {
  final List<SkibbleMeet> meetsList;

  PendingMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meetId).toList();

}