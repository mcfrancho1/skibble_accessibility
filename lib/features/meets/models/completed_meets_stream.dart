import 'package:skibble/features/meets/models/skibble_meet.dart';

class CompletedMeetsStream {
  final List<SkibbleMeet> meetsList;

  CompletedMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meetId).toList();

}