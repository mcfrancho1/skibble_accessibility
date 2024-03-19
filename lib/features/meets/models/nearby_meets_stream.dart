import 'package:skibble/features/meets/models/skibble_meet.dart';

import '../../../models/skibble_user.dart';

class NearbyMeetsStream {
  final List<UserNearbyMeet> meetsList;

  NearbyMeetsStream(this.meetsList);

  List<String> getIds() => this.meetsList.map((e) => e.meet.meetId).toList();
}


///This model tracks a meet for a user
class UserNearbyMeet {
  final SkibbleMeet meet;
  final SkibbleMeetStatus meetStatus;
  final SkibbleMeetMeetPalPrivateMeetChoice? privateMeetChoice;

  final int? askedToJoinAt;
  final int? invitedAt;
  final int? startedAt;

  UserNearbyMeet({required this.meet, required this.meetStatus, this.privateMeetChoice, this.askedToJoinAt, this.invitedAt, this.startedAt});

  factory UserNearbyMeet.fromMap(Map<String, dynamic> data) {
    return UserNearbyMeet(
      meet:  SkibbleMeet.fromMap(data['meet']),
      meetStatus: data['meetStatus'] == null ? SkibbleMeetStatus.nearby : (SkibbleMeetStatus.values).firstWhere((e) => e.name == data['meetStatus']),
      privateMeetChoice: data['privateMeetChoice'] == null ? SkibbleMeetMeetPalPrivateMeetChoice.notGoing : (SkibbleMeetMeetPalPrivateMeetChoice.values).firstWhere((e) => e.name == data['privateMeetChoice']),
      askedToJoinAt: data['askedToJoinAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['askedToJoinAt']).toLocal().millisecondsSinceEpoch : null,
      invitedAt: data['invitedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['invitedAt']).toLocal().millisecondsSinceEpoch : null,
      startedAt: data['startedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['startedAt']).toLocal().millisecondsSinceEpoch : null
    );
  }
}


///This model tracks a meet for a user
class InterestedInvitedUser {
  final SkibbleUser user;
  final String meetStatus;
  final SkibbleMeetMeetPalPrivateMeetChoice? privateMeetChoice;
  final int? askedToJoinAt;
  final int? invitedAt;
  final int? startedAt;
  final String? messagesCount;

  InterestedInvitedUser({required this.user, required this.meetStatus, this.messagesCount = "1", this.privateMeetChoice, this.askedToJoinAt, this.invitedAt, this.startedAt});

  factory InterestedInvitedUser.fromMap(Map<String, dynamic> data) {
    return InterestedInvitedUser(
        user:  SkibbleUser.fromMap(data['user']),
        meetStatus: data['meetStatus'],
        messagesCount: data['messagesCount'] ?? "1",
        privateMeetChoice: data['privateMeetChoice'] == null ? SkibbleMeetMeetPalPrivateMeetChoice.going : (SkibbleMeetMeetPalPrivateMeetChoice.values).firstWhere((e) => e.name == data['privateMeetChoice']),
        askedToJoinAt: data['askedToJoinAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['askedToJoinAt']).toLocal().millisecondsSinceEpoch : null,
        invitedAt: data['invitedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['invitedAt']).toLocal().millisecondsSinceEpoch : null,
        startedAt: data['startedAt'] != null ? DateTime.fromMillisecondsSinceEpoch(data['startedAt']).toLocal().millisecondsSinceEpoch : null
    );
  }
}