
import 'package:skibble/models/meal_invite.dart';

import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:skibble/models/skibble_user.dart';

import '../../../models/address.dart';
import '../../../models/food_spot.dart';
import '../../../models/skibble_place.dart';

// enum SkibbleMeetType {mealInvite}
enum SkibbleMeetPrivacyStatus {friends, private, public}
enum SkibbleMeetMeetPalPrivateMeetChoice {going, notGoing}

enum SkibbleMeetStatus {nearby, pending, ongoing, upcoming, created, updated, deleted, archived, completed}
enum SkibbleMeetBillsType {myTreat, meetPalsTreat, split, decideLater, random}

// enum MealInviteStatus {isDeleted, }
class SkibbleMeet {
  final String meetTitle;
  final SkibbleFoodBusiness? meetLocation;
  final SkibbleMeetPrivacyStatus meetPrivacyStatus;
  final SkibbleMeetStatus meetStatus;
  final SkibbleMeetBillsType meetBillsType;
  //typically the creator of this invite
  final SkibbleUser meetCreator;
  final String meetId;
  final String meetRef;

  //the radius of the users who can accept this invite
  final double restrictedDistance;
  final int meetDateTime;
  final int timeOfCreation;
  final int lastUpdated;
  final int maxNumberOfPeopleMeeting;
  final int totalInterestedUsers;
  final int totalPrivateUsers;
  final int totalInvitedUsers;

  //for private meet users
  final int totalAttendingUsers;

  final int totalRejectedUsers;
  final String? meetImage;
  //stores count of users who completed the meet
  final int totalUsersWhoCancelled;

  //stores count of users who completed the meet
  final int totalUsersWhoMet;

  //should responders be hidden
  final bool hideInterestedUsers;
  final bool isActive;
  final bool automaticallyApproveInterestedUsers;
  final String? meetDescription;
  Map<String, SkibbleUser>? latestInterestedUsers;
  List<SkibbleUser>? interestedUsers;
  List<SkibbleUser>? invitedUsers;
  List<String>? privateUsersIdList;
  //contains the food options the user should expect
  final List<String>? foodOptions;


  SkibbleMeet( {
    required this.hideInterestedUsers,
    required this.isActive,
    required this.meetTitle,
    required this.meetCreator,
    required this.meetLocation,
    required this.timeOfCreation,
    required this.meetDateTime,
    required this.lastUpdated,
    required this.maxNumberOfPeopleMeeting,
    required this.restrictedDistance,
    required this.meetPrivacyStatus,
    required this.meetStatus,
    required this.meetId,
    required this.meetRef,
    this.interestedUsers,
    this.invitedUsers,
    this.meetDescription,
    required this.meetBillsType,
    this.foodOptions,
    required this.latestInterestedUsers,
    // this.foodSpotType = SkibbleMeetType.mealInvite,
    required this.totalInterestedUsers,
    required this.totalInvitedUsers,
    required this.totalRejectedUsers,
    this.totalAttendingUsers = 0,
    required this.totalUsersWhoCancelled,
    required this.totalUsersWhoMet,
    required this.totalPrivateUsers,
    required this.automaticallyApproveInterestedUsers,
    this.meetImage,
    this.privateUsersIdList
  });


  SkibbleMeet copy() {
    // TODO: implement copyWith
    return SkibbleMeet(
      meetTitle: meetTitle,
      isActive: isActive,
      meetId: meetId,
      meetPrivacyStatus: meetPrivacyStatus,
      meetStatus: meetStatus,
      meetLocation: meetLocation,
      meetDateTime: meetDateTime,
      maxNumberOfPeopleMeeting: maxNumberOfPeopleMeeting,
      restrictedDistance: restrictedDistance,
      meetCreator: meetCreator,
      meetImage: meetImage,

      timeOfCreation: timeOfCreation,
      hideInterestedUsers: hideInterestedUsers,
      lastUpdated: lastUpdated,
      meetDescription: meetDescription,
      // foodSpotType: this.foodSpotType,
      foodOptions: foodOptions,
      latestInterestedUsers: latestInterestedUsers ?? {},
      totalInterestedUsers: totalInterestedUsers ?? 0,
      totalInvitedUsers: totalInvitedUsers ?? 0,
      totalRejectedUsers: totalRejectedUsers ?? 0,
      totalUsersWhoCancelled: totalUsersWhoCancelled ?? 0,
      totalAttendingUsers: totalAttendingUsers ?? 0,
      totalUsersWhoMet: totalUsersWhoMet ?? 0,
      automaticallyApproveInterestedUsers: automaticallyApproveInterestedUsers ?? false,
      meetRef: meetRef,
      totalPrivateUsers: totalPrivateUsers ?? 0,
      privateUsersIdList: privateUsersIdList,
      meetBillsType: meetBillsType,
      // (data['latestInterestedUsersMap'] as List).map((item) => item.entries.map((entry) => SkibbleUser.fromMap(entry.value as Map<String, dynamic>)).toList()).toList().expand((x) => x).toList() : <SkibbleUser>[]
    );
  }


  factory SkibbleMeet.fromMap(Map<String, dynamic> data) {
    return SkibbleMeet(
      meetTitle: data['meetTitle'],
      isActive: data['isActive'],
      meetId: data['meetId'],
      meetPrivacyStatus: data['meetPrivacyStatus'] == null
          ? SkibbleMeetPrivacyStatus.public
          : SkibbleMeetPrivacyStatus.values.firstWhere((e) =>
      e.name == data['meetPrivacyStatus']),
      meetStatus: data['meetStatus'] == null
          ? SkibbleMeetStatus.deleted
          : SkibbleMeetStatus.values.firstWhere((e) =>
      e.name == data['meetStatus']),
      meetLocation: data['meetLocation'] != null ? SkibbleFoodBusiness.fromMap(data['meetLocation'].cast<String, dynamic>()) : null,
      meetDateTime: DateTime.fromMillisecondsSinceEpoch(data['meetDateTime']).toLocal().millisecondsSinceEpoch ,
      meetImage: data['meetImage'],
      maxNumberOfPeopleMeeting: data['maxNumberOfPeopleMeeting'],
      restrictedDistance: data['restrictedDistance'] != null ? (data['restrictedDistance']).toDouble() : 100,
      meetCreator:data['meetCreator'] != null ?  SkibbleUser.fromMap(data['meetCreator'].cast<String, dynamic>()) : SkibbleUser(),
      timeOfCreation: data['timeOfCreation'],
      lastUpdated: data['lastUpdated'],
      meetDescription: data['meetDescription'],
      foodOptions: List<String>.from(data['foodOptions'] ?? []),
      latestInterestedUsers: data['latestInterestedUsers'] != null ? Map<String, SkibbleUser>.fromEntries(((data['latestInterestedUsers'].cast<String, dynamic>()) as Map<String, dynamic>).entries.map((entry) => MapEntry(entry.key, SkibbleUser.fromMap(entry.value)))) : {},
      totalInterestedUsers: (data['totalInterestedUsers'] as int) ?? 0,
      // latestInterestedUsersList: data['latestInterestedUsersMap'] != null ? (data['latestInterestedUsersMap'] as Map<String, dynamic>).entries.map((entry) => SkibbleUser.fromMap(entry.value as Map<String, dynamic>)).toList() : [],
      hideInterestedUsers: data['hideInterestedUsers'],
      totalInvitedUsers: data['totalInvitedUsers'] ?? 0,
      totalRejectedUsers: data['totalRejectedUsers'] ?? 0,
      totalUsersWhoCancelled: data['totalUsersWhoCancelled'] ?? 0,
      totalAttendingUsers: data['totalAttendingUsers'] ?? 0,
      totalPrivateUsers: data['totalPrivateUsers'] ?? 0,
      totalUsersWhoMet: data['totalUsersWhoMet'] ?? 0,
      automaticallyApproveInterestedUsers: data['automaticallyApproveInterestedUsers'],
      meetRef: data['meetRef'],
      privateUsersIdList: data['privateUsersIdList'] != null ? List<String>.from(data['privateUsersIdList']) : null,
      meetBillsType: data['meetBillsType'] == null
          ? SkibbleMeetBillsType.split
          : SkibbleMeetBillsType.values.firstWhere((e) =>
      e.name == data['meetBillsType']),
      // (data['latestInterestedUsersMap'] as List).map((item) => item.entries.map((entry) => SkibbleUser.fromMap(entry.value as Map<String, dynamic>)).toList()).toList().expand((x) => x).toList() : <SkibbleUser>[]
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'meetTitle': meetTitle,
      'meetLocation': meetLocation?.toMap(),
      'meetDateTime':  DateTime
          .fromMillisecondsSinceEpoch(meetDateTime)
          .toUtc()
          .millisecondsSinceEpoch,
      'maxNumberOfPeopleMeeting': maxNumberOfPeopleMeeting,
      'restrictedDistance': restrictedDistance,
      'meetCreator': meetCreator.toPublicProfileMap(),
      'timeOfCreation': timeOfCreation,
      'meetImage': meetImage,
      'lastUpdated': lastUpdated,
      'meetDescription':  meetDescription,
      'foodOptions': foodOptions ?? [],
      'isActive': isActive,
      'meetPrivacyStatus': meetPrivacyStatus.name,
      'meetStatus': meetStatus.name,
      'meetId': meetId,
      'meetRef': meetRef,
      'totalInterestedUsers': totalInterestedUsers ?? 0,
      'hideInterestedUsers': hideInterestedUsers,
      'totalInvitedUsers': totalInvitedUsers,
      'totalRejectedUsers': totalRejectedUsers,
      'totalPrivateUsers': totalPrivateUsers,
      'totalUsersWhoCancelled': totalUsersWhoCancelled,
      'totalAttendingUsers': totalAttendingUsers,
      'totalUsersWhoMet': totalUsersWhoMet,
      'meetBillsType': meetBillsType.name,
      'automaticallyApproveInterestedUsers': automaticallyApproveInterestedUsers,
      'latestInterestedUsers': {},
      'privateUsersIdList': privateUsersIdList,
    };
  }

  Map<String, dynamic> updateToMap() {
    return {
      'meetTitle': meetTitle,
      'meetLocation': meetLocation?.toMap(),
      'meetDateTime': DateTime
          .fromMillisecondsSinceEpoch(meetDateTime)
          .toUtc()
          .millisecondsSinceEpoch,
      'maxNumberOfPeopleMeeting': maxNumberOfPeopleMeeting,
      'restrictedDistance': restrictedDistance,
      'meetCreator': meetCreator.toPublicProfileMap(),
      'meetImage': meetImage,
      'lastUpdated': lastUpdated,
      'meetDescription':  meetDescription,
      // 'foodSpotType': this.foodSpotType.name,
      'foodOptions': foodOptions ?? [],
      'isActive': isActive,
      'meetPrivacyStatus': meetPrivacyStatus.name,
      'meetStatus': meetStatus.name,
      'meetBillsType': meetBillsType.name,
      'automaticallyApproveInterestedUsers': automaticallyApproveInterestedUsers,
      'hideInterestedUsers': hideInterestedUsers,
      'privateUsersIdList': privateUsersIdList
    };
  }
// @override
// void updatePointAnnotation() {
//   // TODO: implement updatePointAnnotation
//
// }
}

// class SkibbleMeet {
//   // void updatePointAnnotation();
//   final String id;
//
//    SkibbleMeet({required this.id});
//
//   factory SkibbleMeet.fromMap(Map<String, dynamic> data) {
//     switch(data['foodSpotType'] as String) {
//       case 'mealInvite':
//         return MealInvite.fromMap(data);
//
//       default:
//         return SkibbleMeet(id: '');
//     }
//   }
//
//   // Map<String, dynamic> toMap() {
//   //   return invite.toMap();
//   // }
// }