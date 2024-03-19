import 'package:skibble/features/meets/models/skibble_meet.dart';

class CreatedMeetsStream {
  final List<SkibbleMeet> meetsList;

  CreatedMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meetId).toList();

}