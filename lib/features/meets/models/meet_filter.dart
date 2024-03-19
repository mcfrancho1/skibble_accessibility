import 'skibble_meet.dart';

class SkibbleMeetsFilter {
  DateTime? filterFromDateTime;
  DateTime? filterToDateTime;

  int? maxNumberOfPeopleMeeting;
  List<SkibbleMeetBillsType>? meetBillsType;

  SkibbleMeetsFilter({
    this.filterFromDateTime,
    this.filterToDateTime,
    this.meetBillsType,
    this.maxNumberOfPeopleMeeting
  });
}