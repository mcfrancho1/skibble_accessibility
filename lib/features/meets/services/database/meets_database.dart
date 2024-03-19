
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/food_spot.dart';
import 'package:skibble/models/notification_model/notification.dart';
import 'package:skibble/services/change_data_notifiers/food_spots_data/spots_data.dart';
import 'package:skibble/services/firebase/database/fan_outs_helper/user_fan_out.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';
import 'package:skibble/features/meets/models/upcoming_meets_stream.dart';

import '../../../../models/skibble_user.dart';
import '../../../../services/firebase/custom_collections_references.dart';
import '../../../../services/firebase/database/fan_outs_helper/food_spots_fan_out.dart';
import '../../../../services/firebase/skibble_functions_handler.dart';
import '../../models/completed_meets_stream.dart';
import '../../models/created_meets_stream.dart';
import '../../models/meet_filter.dart';
import '../../models/nearby_meets_stream.dart';
import '../../models/ongoing_meets_stream.dart';
import '../../models/pending_meets_stream.dart';


class MeetsDatabase{
  // @override
  Future<String> createMeet(SkibbleMeet meet, {List<SkibbleUser>? privateUsers}) async{
    // TODO: implement createSpot
    try {
      var batch = FirebaseFirestore.instance.batch();
      var time = DateTime.now().toUtc().millisecondsSinceEpoch;

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId), meet.toMap());

      //the meet creator is the first meet pal and is going
      batch.set(FirebaseCollectionReferences.usersCollection.doc(meet.meetCreator.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            'meet':meet.toMap(),
            "meetStatus": 'upcoming',
            "invitedAt": time,
            "askedToJoinAt": time,
            "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.going.name,
          });

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(meet.meetCreator.userId), {
        'user': meet.meetCreator.toPublicProfileMap(),
        'meetStatus': 'invited',
        'writeType': 'meetStatus',
        "invitedAt": time,
        "askedToJoinAt": time,
        "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.going.name,

      }, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetCircleSubCollection).doc(meet.meetCreator.userId), {
        'user': meet.meetCreator.toPublicProfileMap(),
        'meetStatus': 'invited',
        'writeType': 'meetStatus',
        "invitedAt": time,
        "askedToJoinAt": time,
        "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.going.name,
        'messagesCount': "1",


      }, SetOptions(merge: true));

      ///write to the meetpals subcolleciton of meets
      ///The user write
      // if(privateUsers != null) {
      //   for(var pal in (privateUsers)) {
      //     batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(pal.userId), {
      //       'user': pal.toPublicProfileMap(),
      //       'meetStatus': 'invited',
      //       "invitedAt": time,
      //       "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.notGoing,
      //     }, SetOptions(merge: true));
      //
      //     // batch.set(FirebaseCollectionReferences.usersCollection.doc(pal.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
      //     //     {
      //     //       "meetStatus": 'nearby',
      //     //       "invitedAt": time,
      //     //     }, SetOptions(merge: true));
      //   }
      //
      // }

      await batch.commit();
      return 'success';
    }
    catch(e) {debugPrint(e.toString()); return ('error');}
  }

  Future<String> updateMeet(SkibbleMeet meet, {List<SkibbleUser>? privateUsers}) async{
    // TODO: implement createSpot
    try {
      var batch = FirebaseFirestore.instance.batch();
      var time = DateTime.now().toUtc().millisecondsSinceEpoch;

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId), meet.updateToMap(), SetOptions(merge: true));

      if(privateUsers != null) {
        for(var pal in (privateUsers)) {
          batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(pal.userId), {
            'user': pal.toPublicProfileMap(),
            'meetStatus': 'invited',
            "invitedAt": time,

          }, SetOptions(merge: true));
          // batch.set(FirebaseCollectionReferences.usersCollection.doc(pal.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          //     {
          //       "meetStatus": 'nearby',
          //       "invitedAt": time,
          //     }, SetOptions(merge: true));
        }

      }

      await batch.commit();
      return 'success';
    }
    catch(e) {debugPrint(e.toString()); return ('error');}
  }

  Future<bool> deleteMeet(SkibbleMeet meet, int scoreDeducted) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      batch.delete(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId));
      batch.set(FirebaseCollectionReferences.usersCollection.doc(meet.meetCreator.userId), {
        'meetScore': FieldValue.increment(-scoreDeducted)
      }, SetOptions(merge: true));

      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<List<String>> fetchMeetImages() async{
    // TODO: implement createSpot
    try {
     return  await FirebaseCollectionReferences.meetsImagesCollection.get().then((value) => value.docs.map((e) => (e.data() as Map<String, dynamic>)['imageUrl'] as String).toList());

    }
    catch(e) {debugPrint(e.toString()); return [];}
  }

  Future<bool> askToJoinMeet(SkibbleMeet meet, SkibbleUser currentUser) async {
    try {

      var time = DateTime.now().toUtc().millisecondsSinceEpoch;
      var batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId), {
        'user': currentUser.toPublicProfileMap(),
        "askedToJoinAt": time,
        'writeType': 'meetStatus',
        'meetStatus': meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 'invited' : 'interested'
      }, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "meetStatus": meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 'upcoming' : 'pending',
            "askedToJoinAt": time
          },
          SetOptions(merge: true)
      );

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {
            "totalInterestedUsers": FieldValue.increment(1),
          }, SetOptions(merge: true));


      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }


  ///This is called to cancel meet interest
  Future<bool> unJoinMeet(SkibbleMeet meet, SkibbleUser currentUser, int score) async {
    try {

      var batch = FirebaseFirestore.instance.batch();
      batch.delete(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId));
      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "meetStatus": 'nearby',
            "unJoinedAt": DateTime.now().toUtc().millisecondsSinceEpoch
          },
          SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId),
        {
          "meetScore": FieldValue.increment(score),
        },
        SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {
            "totalInterestedUsers": FieldValue.increment(-1),
          }, SetOptions(merge: true));


      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<bool> inviteUserToMeet(SkibbleMeet meet, SkibbleUser currentUser, SkibbleUser userToInvite) async {
    try {

      var time = DateTime.now().toUtc().millisecondsSinceEpoch;
      var batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {'totalInvitedUsers': FieldValue.increment(1),
            // 'totalInterestedUsers': FieldValue.increment(-1)
          }, SetOptions(merge: true));
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(userToInvite.userId), {
        'user': userToInvite.toPublicProfileMap(),
        'meetStatus': 'invited',
        'writeType': 'meetStatus',
        "invitedAt": time,

      }, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetCircleSubCollection).doc(userToInvite.userId), {
        'user': userToInvite.toPublicProfileMap(),
        'meetStatus': 'invited',
        'writeType': 'meetStatus',
        "invitedAt": time,
        'messagesCount': "1",
      }, SetOptions(merge: true));

    batch.set(FirebaseCollectionReferences.usersCollection.doc(userToInvite.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
        {
          "meetStatus": 'upcoming',
          "invitedAt": time,
        }, SetOptions(merge: true));

      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<bool> unInviteUserToMeet(SkibbleMeet meet, SkibbleUser currentUser, SkibbleUser userToInvite) async {
    try {

      var time = DateTime.now().toUtc().millisecondsSinceEpoch;
      var batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {'totalInvitedUsers': FieldValue.increment(-1),
            // 'totalInterestedUsers': FieldValue.increment(1)
          }, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(userToInvite.userId), {
        'user': userToInvite.toPublicProfileMap(),
        'meetStatus': 'interested',
        'writeType': 'meetStatus',
        "unInvitedAt": time,

      }, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(userToInvite.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "meetStatus": 'pending',
            "unInvitedAt": time,
          }, SetOptions(merge: true));

      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }


  Future<bool> startMeet(SkibbleMeet meet, SkibbleUser currentUser ) async {
    try {
      var time = DateTime.now().toUtc().millisecondsSinceEpoch;
      var batch = FirebaseFirestore.instance.batch();
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId), {
        'user': currentUser.toPublicProfileMap(),
        "startedAt": time,
        "meetStatus": 'ongoing',

      });
      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "meetStatus": 'ongoing',
            "startedAt": time
          }, SetOptions(merge: true));


      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  Future<List<SkibbleUser>> getSkibbleMeetPrivateMeetPals(SkibbleMeet meet, SkibbleUser currentUser) async {
    try {
      return await FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).where('meetStatus', isEqualTo: 'invited').get()
          .then((value) => value.docs.map((e) => SkibbleUser.fromMap(e.data()['user'])).where((element) => element.userId != currentUser.userId).toList()
      );
    }
    catch(e) {

      return [];
    }
  }

  Future<bool> completeMeet(SkibbleMeet meet, SkibbleUser currentUser ) async {
    try {

      var batch = FirebaseFirestore.instance.batch();
      var time = DateTime.now().toUtc().millisecondsSinceEpoch;
      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId), {
        'user': currentUser.toPublicProfileMap(),
        "meetStatus": 'completed',
        "completedAt": time
      });
      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.completedMeetsSubCollection).doc(meet.meetId), {
        'meet': meet.toMap(),
        "meetStatus": 'completed',
        "completedAt": time
      },  SetOptions(merge: true));

      batch.delete(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId));

      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  /// Canceling an invite that is public or friends
  Future<bool> leaveInvitedMeet(SkibbleMeet meet, SkibbleUser currentUser, int score ) async {
    try {

      var batch = FirebaseFirestore.instance.batch();
      batch.delete(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId));
      // batch.delete(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.upcomingMeetsSubCollectionName).doc(meet.meetId));
      // batch.delete(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.ongoingMeetsSubCollection).doc(meet.meetId));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {'totalInvitedUsers': FieldValue.increment(-1), 'totalInterestedUsers': FieldValue.increment(-1)}, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "meetStatus": 'nearby',
            "unJoinedAt": DateTime.now().toUtc().millisecondsSinceEpoch
          },
          SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId),
          {'meetScore': FieldValue.increment(score),}, SetOptions(merge: true));
      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }


  /// Confirming an invite that is private
  Future<bool> goingToPrivateMeet(SkibbleMeet meet, SkibbleUser currentUser ) async {
    try {

      var batch = FirebaseFirestore.instance.batch();


      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {'totalAttendingUsers': FieldValue.increment(1)}, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "confirmed_going_at": DateTime.now().toUtc().millisecondsSinceEpoch,
            "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.going.name,
            'writeType': 'privateMeetChoice'
          },
          SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId),
          {
            "confirmed_going_at": DateTime.now().toUtc().millisecondsSinceEpoch,
            "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.going.name,
            'writeType': 'privateMeetChoice'
          },
          SetOptions(merge: true));
      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }

  /// Canceling an invite that is private
  Future<bool> notGoingToPrivateMeet(SkibbleMeet meet, SkibbleUser currentUser ) async {
    try {

      var batch = FirebaseFirestore.instance.batch();


      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId),
          {'totalAttendingUsers': FieldValue.increment(-1)}, SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection).doc(meet.meetId),
          {
            "confirmed_not_going_at": DateTime.now().toUtc().millisecondsSinceEpoch,
            "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.notGoing.name,
            'writeType': 'privateMeetChoice'
          },
          SetOptions(merge: true));

      batch.set(FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).collection(FirebaseCollectionReferences.meetPalsSubCollection).doc(currentUser.userId),
          {
            "confirmed_not_going_at": DateTime.now().toUtc().millisecondsSinceEpoch,
            "privateMeetChoice": SkibbleMeetMeetPalPrivateMeetChoice.notGoing.name,
            'writeType': 'privateMeetChoice'
          },
          SetOptions(merge: true));
      await batch.commit();

      return true;
    }
    catch(e) {
      return false;
    }
  }


  //
  // Future<bool> deleteMeet(SkibbleMeet meet, SkibbleUser currentUser ) async {
  //   try {
  //
  //     await FirebaseCollectionReferences.meetsCollection.doc(meet.meetId).delete();
  //     return true;
  //   }
  //   catch(e) {
  //     return false;
  //   }
  // }

  Future<SkibbleMeet?> getMeetInfo(String meetId) async{
    // TODO: implement createSpot
    try {
      var doc = await FirebaseCollectionReferences.meetsCollection.doc(meetId).get();

      if(doc.exists) {
        return SkibbleMeet.fromMap(doc.data() as Map<String, dynamic>);
      }
      else {
        return null;
      }
    }
    catch(e) {debugPrint(e.toString()); return null;}
  }


  Future<List<SkibbleMeet>> filterMeets(SkibbleMeetsFilter filter, SkibbleUser currentUser) async {
    try {
        var query = FirebaseCollectionReferences.meetsCollection
            .where('isActive', isEqualTo: true)
            .where('meetStatus', whereIn: ['created', 'updated', 'archived']);
            // .orderBy('meetDateTime', descending: true);

        if(filter.filterFromDateTime != null && filter.filterToDateTime != null) {
          query = query.where('meetDateTime', isGreaterThanOrEqualTo: filter.filterFromDateTime!.millisecondsSinceEpoch)
              .where('meetDateTime', isLessThanOrEqualTo: filter.filterToDateTime!.millisecondsSinceEpoch);
        }
        else if(filter.filterFromDateTime != null) {
          query = query.where('meetDateTime', isGreaterThanOrEqualTo: filter.filterFromDateTime!.millisecondsSinceEpoch)
              .where('meetDateTime', isLessThanOrEqualTo: filter.filterFromDateTime!.add(const Duration(hours: 24)).millisecondsSinceEpoch);
        }

        if(filter.maxNumberOfPeopleMeeting != null) {
          query = query.where('maxNumberOfPeopleMeeting', isEqualTo: filter.maxNumberOfPeopleMeeting);

        }

        if(filter.meetBillsType != null) {
          for(var type in filter.meetBillsType!) {
            if(type == SkibbleMeetBillsType.meetPalsTreat) {
              query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.myTreat.name)
                  .where('meetCreator.userId', isNotEqualTo: currentUser.userId);

            }
            else if(type == SkibbleMeetBillsType.split) {
              query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.split.name);

            }

            else if(type == SkibbleMeetBillsType.decideLater) {
              query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.decideLater.name);
            }

            else if(type == SkibbleMeetBillsType.random) {
              query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.random.name);
            }

          }

        }

        return await query.get().then((value) => value.docs.map((e) => SkibbleMeet.fromMap(e.data() as Map<String, dynamic>)).toList());
    }
    catch(e) {
      print(e);
      return [];
    }
  }

  // @override
  Future<List<SkibbleMeet>> getMeets() async{
    // TODO: implement getSpots
    try {
      var query =  FirebaseCollectionReferences.meetsCollection
        .where('isActive', isEqualTo: true)
        .where('meetStatus', whereIn: ['created', 'updated', 'archived'])
        .where('meetDateTime', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
        .orderBy('meetDateTime', descending: true);

        return await query.get().then((value) {
          return value.docs.map((e) => SkibbleMeet.fromMap(e.data() as Map<String, dynamic>)).toList();
        });
    }
    catch(e) {
      print(e);
      return [];
    }
  }

  Stream<List<SkibbleMeet>> streamMeets() {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.meetsCollection
          .where('isActive', isEqualTo: true)
      // .where('foodSpotStatus', isNotEqualTo: 'deleted')
          .where('meetStatus', whereIn: ['created', 'updated', 'archived'])
          .where('meetDateTime', isGreaterThanOrEqualTo: DateTime.now().millisecondsSinceEpoch)
      // .orderBy('foodSpotStatus', descending: true)
          .orderBy('meetDateTime', descending: true)
          .snapshots().map(_meetList);

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  Stream<UpcomingMeetsStream> streamUpcomingMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.upcomingMeetsSubCollectionName)
          .orderBy('meet.meetDateTime', descending: true)
          .snapshots().map((snapshot) => UpcomingMeetsStream(_meetList(snapshot)));

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  Stream<NearbyMeetsStream> streamNearbyMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.nearbyMeetsSubCollection)
        .where('meet.isActive', isEqualTo: true)
        .where('meet.meetStatus', whereIn: ['created', 'updated', 'archived'])
        .where('meet.meetDateTime', isGreaterThanOrEqualTo: DateTime.now().toUtc().millisecondsSinceEpoch)
        .orderBy('meet.meetDateTime', descending: true)
        .snapshots().map((snapshot) => NearbyMeetsStream(_nearbyMeetList(snapshot)));
    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }


  Stream<CreatedMeetsStream> streamCreatedMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.meetsCollection
          .where('meetCreator.userId', isEqualTo: currentUser.userId)
          .orderBy('meetDateTime', descending: true)
          .snapshots().map((snapshot) => CreatedMeetsStream(_meetList(snapshot)));

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  Stream<OngoingMeetsStream> streamOngoingMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.ongoingMeetsSubCollection)
          .orderBy('meet.meetDateTime', descending: true)
          .snapshots().map((snapshot) => OngoingMeetsStream(_meetList(snapshot)));

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  Stream<PendingMeetsStream> streamPendingMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.pendingMeetsSubCollection)
          .orderBy('meet.meetDateTime', descending: true)
          .snapshots().map((snapshot) => PendingMeetsStream(_meetList(snapshot)));

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  Stream<CompletedMeetsStream> streamCompletedMeets(SkibbleUser currentUser) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.usersCollection.doc(currentUser.userId).collection(FirebaseCollectionReferences.completedMeetsSubCollection)
          .orderBy('meet.meetDateTime', descending: true)
          .snapshots().map((snapshot) => CompletedMeetsStream(_meetList(snapshot)));

    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }

  // List<FoodSpot> _foodSpotList(QuerySnapshot snapshot) {
  //   return snapshot.docs
  //       .map((doc) => FoodSpot.fromMap(doc.data() as Map<String, dynamic>))
  //       .toList();
  // }

  List<SkibbleMeet> _meetList(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return SkibbleMeet.fromMap(data);
    }).toList();
  }

  List<UserNearbyMeet> _nearbyMeetList(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) {
      var data = doc.data() as Map<String, dynamic>;

      return UserNearbyMeet.fromMap(data);
    }).toList();
  }

 List<InterestedInvitedUser> _usersList(QuerySnapshot snapshot) {
    var interested = [];
    var invited = [];
    return snapshot.docs
        .map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return InterestedInvitedUser.fromMap(data);
    }).toList();
  }

  Stream<List<InterestedInvitedUser>> streamInterestedUsers(String meetId, BuildContext context) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.meetsCollection.doc(meetId)
          .collection(FirebaseCollectionReferences.meetPalsSubCollection)
          .orderBy('askedToJoinAt', descending: false)
          .snapshots().map(_usersList);
    }
    catch(e) {
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }

  Stream<InterestedInvitedUser> streamMeetCircle(String meetId, String currentUserId, BuildContext context) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.meetsCollection.doc(meetId)
          .collection(FirebaseCollectionReferences.meetCircleSubCollection)
          .doc(currentUserId)
          .snapshots().map((e) {
            print(e.exists);
            return InterestedInvitedUser.fromMap(e.data()!);
      });
    }
    catch(e) {
      debugPrint(e.toString());
      return const Stream.empty();
    }
  }

  Future<bool> deactivateMeetCircleChat(String meetId, String currentUserId) async {
    try {

      return await FirebaseFirestore.instance.runTransaction((transaction)  async{

        var userRef = FirebaseCollectionReferences.meetsCollection.doc(meetId)
            .collection(FirebaseCollectionReferences.meetCircleSubCollection)
            .doc(currentUserId);

        var circleDoc = await transaction.get(userRef);

        var circleData = InterestedInvitedUser.fromMap(circleDoc.data()!);

        if(circleData.messagesCount != "unlimited") {
          transaction.set(userRef, {'messagesCount': "0"}, SetOptions(merge: true));
        }

        return true;

      });
    }
    catch(e) {
      debugPrint(e.toString());
      return false;
    }
  }


  Future<List<SkibbleUser>> getInterestedUsers(SkibbleMeet meet, BuildContext context) async{
    // TODO: implement getSpots
    try {

      var res = await FirebaseCollectionReferences.meetsCollection.doc(meet.meetId)
          .collection(FirebaseCollectionReferences.meetPalsSubCollection)
          .where('meetStatus', isEqualTo: 'interested').orderBy('askedToJoinAt', descending: false)
          .get().then((value) => value.docs.map((e) => SkibbleUser.fromMap(e.data()['user'])).toList());

      return res;

    }
    catch(e) {
      print(e);
      return [];
    }
  }

  Future<List<SkibbleUser>> getInvitedUsers(String spotId, BuildContext context) async{
    // TODO: implement getSpots
    try {
      var res = await FirebaseCollectionReferences.meetsCollection.doc(spotId)
          .collection(FirebaseCollectionReferences.meetPalsSubCollection)
          .where('meetStatus', isEqualTo: 'invited')
          .get().then((value) => value.docs.map((e) => SkibbleUser.fromMap(e.data()['user'])).toList());

      context.read<SpotsData>().updateInvitedUsers(spotId,  res);
      return res;
    }
    catch(e) {
      return [];
    }
  }

  Stream<List<SkibbleMeet>> streamUserMeets(String userId) {
    // TODO: implement getSpots
    try {
      return FirebaseCollectionReferences.meetsCollection
          .where('meetCreator.userId', isEqualTo: userId)
          .where('meetStatus', whereIn: ['created', 'updated', 'archived'])
          .orderBy('meetDateTime', descending: true)
          .snapshots().map(_meetList);
    }
    catch(e) {
      debugPrint(e.toString());
      return Stream.empty();
    }
  }



  @override
  Future<List<FoodSpot>> getSpotsInOtherRegions() {
    // TODO: implement getSpotsInOtherRegions
    throw UnimplementedError();
  }

}