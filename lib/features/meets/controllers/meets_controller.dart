
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/services/location_service_controller.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/identity_verification/views/verification_bottom_sheet.dart';
import 'package:skibble/features/meets/controllers/meets_filter_controller.dart';
import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
import 'package:skibble/features/meets/controllers/meets_map_controller.dart';
import 'package:skibble/features/meets/controllers/meets_privacy_controller.dart';
import 'package:skibble/features/meets/models/ongoing_meets_stream.dart';
import 'package:skibble/features/meets/models/skibble_meet.dart';
import 'package:skibble/features/meets/models/upcoming_meets_stream.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../../models/address.dart';
import '../../../models/skibble_place.dart';
import '../../../models/skibble_user.dart';
import '../../../services/maps_services/geo_locator_service.dart';
import '../../identity_verification/controllers/verification_controller.dart';
import '../models/meet_filter.dart';
import '../models/nearby_meets_stream.dart';
import '../services/database/meets_database.dart';
import '../views/meet_locations_views/meet_navigation_view.dart';
import '../views/test_navigation.dart';
import 'meets_navigation_controller.dart';

class MeetsController with ChangeNotifier {
  List<String> meetsHeaderTexts = ['Nearby', 'Upcoming', 'Ongoing', 'Pending', 'Created', 'Completed'];
  List<IconData> meetsHeaderIcons = [Icons.location_on_rounded, Icons.calendar_month_rounded, Icons.timelapse_rounded, Icons.pending_rounded, Icons.create_rounded, Icons.check_circle_rounded ];

  int _selectedHeader = 0;

  StreamController<NearbyMeetsStream> nearbyMeetsController = StreamController.broadcast();

  // StreamController<List<InterestedInvitedUser>>? meetInterestedUsersStreamController;
  StreamSubscription<List<InterestedInvitedUser>>? meetInterestedUsersStreamController;
  StreamSubscription<InterestedInvitedUser>? meetCircleStreamController;

  int get selectedHeader => _selectedHeader;

  SkibbleMeet? selectedMeetOnMap;
  SkibbleMeet? selectedMeetForDetails;

  final ScrollController scrollController = ScrollController();
   final PanelController panelController = PanelController();

  List<SkibbleMeet> allMeets = [];
  List<UserNearbyMeet> nearbyMeets = [];
  List<UserNearbyMeet> upcomingMeets = [];
  List<UserNearbyMeet> ongoingMeets = [];
  List<UserNearbyMeet> pendingMeets = [];
  List<UserNearbyMeet> completedMeets = [];
  List<SkibbleMeet> createdMeets = [];



  List<UserNearbyMeet> filteredNearbyMeets = [];
  List<UserNearbyMeet> filteredUpcomingMeets = [];
  List<UserNearbyMeet> filteredOngoingMeets = [];
  List<UserNearbyMeet> filteredPendingMeets = [];
  List<UserNearbyMeet> filteredCompletedMeets = [];

  bool _isBottomSheetVisible = true;
  bool get isBottomSheetVisible =>  _isBottomSheetVisible;
  String isMeetCircleMessagingValue = "0";


  initMeetDetails(SkibbleMeet meet, BuildContext context,) {
    selectedMeetForDetails = meet;
    var choice = getPrivateMeetChoice(meet);
    context.read<MeetsPrivacyController>().initMeetChoice(choice);
    meetInterestedUsersStreamController = MeetsDatabase().streamInterestedUsers(selectedMeetForDetails!.meetId, context).listen((event) {
      selectedMeetForDetails?.interestedUsers = [];
      selectedMeetForDetails?.invitedUsers = [];

      selectedMeetForDetails?.interestedUsers = event.where((element) => element.meetStatus == 'interested').map((e) => e.user).toList();
      selectedMeetForDetails?.invitedUsers = event.where((element) => element.meetStatus == 'invited').map((e) => e.user).toList();

      if(selectedMeetForDetails!.invitedUsers!.isEmpty) {
        selectedMeetForDetails?.invitedUsers = event.where((element) => element.meetStatus == 'ongoing').map((e) => e.user).toList();

      }
      notifyListeners();

    });
    // meetInterestedUsersStreamController!.addStream();
    //
    // meetInterestedUsersStreamController!.stream.listen((event) {
    //
    // });
  }

  reset() {
    disposeInterestedUsersInvitedStream();
    disposeMeetCircleStream();
  }


  initMeetCircle(Channel channel, String currentUserId, BuildContext context,) {

    //this is a dummy data - never use the meet details
    selectedMeetForDetails = SkibbleMeet(hideInterestedUsers: false, isActive: true, meetTitle: channel.name!, meetCreator: SkibbleUser(), meetLocation: SkibbleFoodBusiness(address: Address(), skibbleBusinessType: SkibbleBusinessType.google), timeOfCreation: DateTime.now().millisecondsSinceEpoch, meetDateTime: DateTime.now().millisecondsSinceEpoch, lastUpdated: DateTime.now().millisecondsSinceEpoch, maxNumberOfPeopleMeeting: 1, restrictedDistance: 1, meetPrivacyStatus: SkibbleMeetPrivacyStatus.private, meetStatus: SkibbleMeetStatus.created, meetId: channel.id!.replaceAll("meet-circle-", ""), meetRef: '', meetBillsType: SkibbleMeetBillsType.split, latestInterestedUsers: {}, totalInterestedUsers: 0, totalInvitedUsers: 0, totalRejectedUsers: 0, totalUsersWhoCancelled: 0, totalUsersWhoMet: 0, totalPrivateUsers: 0, automaticallyApproveInterestedUsers: true);

    meetCircleStreamController = MeetsDatabase().streamMeetCircle(selectedMeetForDetails!.meetId, currentUserId, context).listen((event) {


      if(event.messagesCount == 'unlimited') {
        isMeetCircleMessagingValue = 'unlimited';

      }
      else if(event.messagesCount == '1') {
        isMeetCircleMessagingValue = '1';
      }
      else {
        isMeetCircleMessagingValue = '0';
      }

      notifyListeners();
      // selectedMeetForDetails?.invitedUsers = event.where((element) => element.meetStatus == 'invited').map((e) => e.user).toList();

    }, onError: (e) {
      print(e);
    });


    meetInterestedUsersStreamController = MeetsDatabase().streamInterestedUsers(selectedMeetForDetails!.meetId, context).listen((event) {
      selectedMeetForDetails?.interestedUsers = [];
      selectedMeetForDetails?.invitedUsers = [];

      selectedMeetForDetails?.interestedUsers = event.where((element) => element.meetStatus == 'interested').map((e) => e.user).toList();
      selectedMeetForDetails?.invitedUsers = event.where((element) => element.meetStatus == 'invited').map((e) => e.user).toList();
      notifyListeners();

    });
  }


  deactivateMeetCircle(Channel channel, String currentUserId) async {
    var res = await MeetsDatabase().deactivateMeetCircleChat(channel.id!.replaceAll("meet-circle-", ""), currentUserId);
  }
  disposeInterestedUsersInvitedStream() async{
    await meetInterestedUsersStreamController?.cancel();
    selectedMeetForDetails = null;
  }

  disposeMeetCircleStream() async{
    await meetCircleStreamController?.cancel();
  }

  listenForNearbyMeets(BuildContext context, SkibbleUser currentUser) {
    nearbyMeetsController.addStream(MeetsDatabase().streamNearbyMeets(currentUser));
    nearbyMeetsController.stream.listen((event) {
      processNearbyMeets(context, event, currentUser);

      if(context.read<MeetsFilterController>().meetFilter != null) {
        filterAllMeets(context.read<MeetsFilterController>().meetFilter!, currentUser);
      }
    });
  }

  initMeets(BuildContext context) {
    // scrollController = ScrollController();

    // scrollController.addListener(() {
    //   final direction = scrollController.position.userScrollDirection;
    // });

    // getNearByMeets(context);
    // panelController = PanelController();
  }

  filterAllMeets(SkibbleMeetsFilter filter, SkibbleUser currentUser) {
    filteredNearbyMeets = filterMeets(nearbyMeets, filter, currentUser);
    filteredUpcomingMeets = filterMeets(upcomingMeets, filter, currentUser);
    filteredPendingMeets = filterMeets(pendingMeets, filter, currentUser);
    filteredOngoingMeets = filterMeets(ongoingMeets, filter, currentUser);
    filteredCompletedMeets = filterMeets(completedMeets, filter, currentUser);
  }

  List<UserNearbyMeet> filterMeets(List<UserNearbyMeet> meetList, SkibbleMeetsFilter filter, SkibbleUser currentUser) {
    // nearbyMeets.where((element) => element.meet.)
    List<UserNearbyMeet> newList = [...meetList];

    if(filter.filterFromDateTime != null && filter.filterToDateTime != null) {
      newList = newList.where((element) =>  element.meet.meetDateTime >= filter.filterFromDateTime!.millisecondsSinceEpoch && element.meet.meetDateTime <= filter.filterToDateTime!.add(const Duration(days: 24)).millisecondsSinceEpoch).toList();

    }
    else if(filter.filterFromDateTime != null) {
      newList = newList.where((element) => element.meet.meetDateTime >= filter.filterFromDateTime!.millisecondsSinceEpoch).toList();

    }

    if(filter.maxNumberOfPeopleMeeting != null) {
      newList = newList.where((element) => element.meet.maxNumberOfPeopleMeeting == filter.maxNumberOfPeopleMeeting).toList();

    }

    if(filter.meetBillsType != null) {
      for(var type in filter.meetBillsType!) {
        if(type == SkibbleMeetBillsType.meetPalsTreat) {
          newList = newList.where((element) => element.meet.meetCreator.userId != currentUser.userId && element.meet.meetBillsType == SkibbleMeetBillsType.myTreat).toList();

          // newList = newList.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.myTreat.name)
          //     .where('meetCreator.userId', isNotEqualTo: currentUser.userId);

        }
        else if(type == SkibbleMeetBillsType.split) {
          newList = newList.where((element) => element.meet.meetBillsType == SkibbleMeetBillsType.split).toList();

          // query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.split.name);

        }

        else if(type == SkibbleMeetBillsType.decideLater) {
          newList = newList.where((element) => element.meet.meetBillsType == SkibbleMeetBillsType.decideLater).toList();

          // query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.decideLater.name);
        }

        else if(type == SkibbleMeetBillsType.random) {
          newList = newList.where((element) => element.meet.meetBillsType == SkibbleMeetBillsType.random).toList();

          // query = query.where('meetBillsType', isEqualTo: SkibbleMeetBillsType.random.name);
        }

      }
    }

    return newList;
  }

  set selectedHeader(int value) {
    _selectedHeader = value;
    notifyListeners();
  }

  set isBottomSheetVisible(bool value) {
    _isBottomSheetVisible = value;
    notifyListeners();
  }

  SkibbleMeetStatus getMeetStatus(SkibbleMeet meet) {
   var found  =  nearbyMeets.firstWhereOrNull((element) => element.meet.meetId == meet.meetId);
    if(found != null) {
      return SkibbleMeetStatus.nearby;
    }

    found  =  pendingMeets.firstWhereOrNull((element) => element.meet.meetId == meet.meetId);
   if(found != null) {
     return SkibbleMeetStatus.pending;
   }

   found  =  upcomingMeets.firstWhereOrNull((element) => element.meet.meetId == meet.meetId);
   if(found != null) {
     return SkibbleMeetStatus.upcoming;
   }

   found  =  ongoingMeets.firstWhereOrNull((element) => element.meet.meetId == meet.meetId);
   if(found != null) {
     return SkibbleMeetStatus.ongoing;
   }

   return SkibbleMeetStatus.completed;

  }


  SkibbleMeetMeetPalPrivateMeetChoice getPrivateMeetChoice(SkibbleMeet meet) {

    var found = upcomingMeets.firstWhereOrNull((element) => element.meet.meetId == meet.meetId);
    if(found != null) {
      return found.privateMeetChoice ?? SkibbleMeetMeetPalPrivateMeetChoice.notGoing;
    }


    return SkibbleMeetMeetPalPrivateMeetChoice.notGoing;

  }


  handleMeetDelete(BuildContext context, SkibbleMeet meet, SkibbleUser currentUser) async{
    //close that confirmation sheet
    // Navigator.pop(context);

    int scoreDeducted = 0;
    var header = 'Delete Meet';
    var buttonText = '';
    var message = 'Are you sure you want to delete this meet?';

    ///Meet Creator Penalties
    //if you cancel/delete a meet after at least 1 person has shown interest, -1
    //if you cancel/delete a meet after inviting at least 1 person, -2
    // if you cancel/delete a meet that is ongoing, -3

    //a meet starts 1 hour before the actual meet time
    if(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime).toLocal().difference(DateTime.now()).inHours < 1 && (meet.invitedUsers ?? []).length > 1) {
      scoreDeducted = -3;
      scoreDeducted = meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 0 : scoreDeducted;

      message = 'Are you sure you want to delete this meet? Your meet score will be affected';

      var res = await MeetsBottomSheets().showCancelMeetSheet(context, meet, currentUser, scoreDeducted, message);

      if(res != null && res) {
        await _deleteMeet(context, meet, scoreDeducted);
      }
    }

    else if((meet.invitedUsers ?? []).length > 1) {
      scoreDeducted = -2;
      message = 'Are you sure you want to delete this meet? Your meet score will be affected';
      scoreDeducted = meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 0 : scoreDeducted;
      message = meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 'Are you sure you want to delete this meet?' : message;
      var res = await MeetsBottomSheets().showCancelMeetSheet(context, meet, currentUser, scoreDeducted, message);

      if(res != null && res) {
        await _deleteMeet(context, meet, scoreDeducted);
      }
    }

    else if((meet.interestedUsers ?? []).isNotEmpty) {
      scoreDeducted = -1;
      message = 'Are you sure you want to delete this meet? Your meet score will be affected';
      scoreDeducted = meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? 0 : scoreDeducted;

      var res = await MeetsBottomSheets().showCancelMeetSheet(context, meet, currentUser, scoreDeducted, message);

      if(res != null && res) {
        await _deleteMeet(context, meet, scoreDeducted);
      }
    }

    else {
      await _deleteMeet(context, meet, 0);
    }

  }

  _deleteMeet(BuildContext context, SkibbleMeet meet, int scoreDeducted) async {
    CustomBottomSheetDialog.showProgressSheet(context);
    var res = await MeetsDatabase().deleteMeet(meet, scoreDeducted);
    // var res = await Future.delayed(Duration(seconds: 2), () => true);

    Navigator.pop(context);

    if(res) {
      context.read<AppData>().skibbleUser!.meetScore = context.read<AppData>().skibbleUser!.meetScore - scoreDeducted;
      CustomBottomSheetDialog.showSuccessSheet(context, 'Your meet has been deleted!.', onButtonPressed: () {
        Navigator.pop(context);

        if(Navigator.canPop(context))
          Navigator.pop(context);
      });

    }
    else {
      CustomBottomSheetDialog.showErrorSheet(context, 'Oops! Unable to delete this meet at the moment.', onButtonPressed: () { Navigator.pop(context); });
    }

  }

  processNearbyMeets(BuildContext context, NearbyMeetsStream nearby, SkibbleUser currentUser) async {

    pendingMeets = [];
    upcomingMeets = [];
    ongoingMeets = [];
    nearbyMeets = [];

    for(var meet in nearby.meetsList) {
      if(meet.meetStatus == SkibbleMeetStatus.nearby && meet.meet.meetCreator.userId != currentUser.userId) {
        nearbyMeets.add(meet);

      }
      else if(meet.meetStatus == SkibbleMeetStatus.pending) {
        pendingMeets.add(meet);
      }

      else if(meet.meetStatus == SkibbleMeetStatus.upcoming) {
        upcomingMeets.add(meet);
      }

      else if(meet.meetStatus == SkibbleMeetStatus.ongoing) {
        ongoingMeets.add(meet);
      }

    }

    // context.read<MeetsMapController>().setMeetsOnMap(nearbyMeets);

    notifyListeners();
  }

  askToJoinMeet(SkibbleMeet meet, SkibbleUser currentUser, BuildContext context) async {
    // var ongoingMeets = context.read<OngoingMeetsStream>().meetsList;
    // var upcomingMeets = context.read<UpcomingMeetsStream>().meetsList;
    //if meet is clashing with an upcoming meet

    if(!currentUser.isUserVerified) {
      await VerificationController().startVerificationFlow(context, currentUser);
    }

    else {
      var clashingUpcomingMeetIndex = upcomingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingUpcomingMeetIndex != -1) {
        //TODO: Show upcoming meet message
        MeetsBottomSheets().showUpcomingMeetConflictSheet(context, upcomingMeets[clashingUpcomingMeetIndex].meet);
        return;
      }

      //if meet is clashing with an ongoing meet
      var clashingOngoingMeetIndex = ongoingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingOngoingMeetIndex != -1) {
        //TODO: Show ongoing meet message
        MeetsBottomSheets().showOngoingMeetConflictSheet(context, ongoingMeets[clashingOngoingMeetIndex].meet);

        return;
      }

      var currentUserLocation = context.read<AppData>().userCurrentLocation;
      if(currentUserLocation?.country != meet.meetLocation?.address.country && currentUserLocation?.stateOrProvince != meet.meetLocation?.address.stateOrProvince) {
        //TODO: show country & province problem message

        CustomBottomSheetDialog.showMessageSheet(context, 'This meet is not available for your current location.', onButtonPressed: () => Navigator.pop(context));
      }
      else {
        var distance = GeoLocatorService().getDistance(
            currentUserLocation!.latitude!,
            currentUserLocation.longitude!,
            meet.meetLocation!.address.latitude!, meet.meetLocation!.address.longitude!);

        if(distance >= 60000) {
          //TODO: show distance problem message
          CustomBottomSheetDialog.showMessageSheet(context, 'This meet is more than a 60km away from you. Join a nearby meet.', onButtonPressed: () => Navigator.pop(context));

        }

        else {
          var result = await MeetsDatabase().askToJoinMeet(meet, currentUser);

          // if(result) {
          //
          // }
        }
      }
    }
  }


  ///This function is called if a meet pal decides to leave a meet
  ///Does not handle the case for the meet creator
  ///Check _deleteMeet() for the meet creator
  handleLeaveMeet(SkibbleMeet meet, SkibbleUser currentUser, BuildContext context) async {

    if(meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private) {
      // await _leaveMeet(meet, currentUser, context, 0);
      var choice = getPrivateMeetChoice(meet);
      var res = await MeetsBottomSheets().showPrivateMeetChoiceSheet(context, choice, currentUser);

      var newChoice = context.read<MeetsPrivacyController>().meetPalPrivateMeetChoice;
      if(choice != newChoice ) {
        if(newChoice == SkibbleMeetMeetPalPrivateMeetChoice.going) {
          MeetsDatabase().goingToPrivateMeet(meet, currentUser);
        }
        else {
          MeetsDatabase().notGoingToPrivateMeet(meet, currentUser);

        }
      }
    }

    else {
      var foundOngoing = ongoingMeets.firstWhereOrNull((res) => meet.meetId == res.meet.meetId);
      var foundUpcoming = upcomingMeets.firstWhereOrNull((res) => meet.meetId == res.meet.meetId);
      var foundPending = pendingMeets.firstWhereOrNull((res) => meet.meetId == res.meet.meetId);
      var message = 'Are you sure you want to leave this meet? Your meet score will be affected';


      if(foundOngoing != null) {
        var res = await MeetsBottomSheets().showCancelMeetSheet(context, meet, currentUser, 3, message);
        if(res != null && res) {
          await _leaveMeet(meet, currentUser, context, -3);
        }
      }

      else if(foundUpcoming != null) {
        var res = await MeetsBottomSheets().showCancelMeetSheet(context, meet, currentUser, 2, message);
        if(res != null && res) {
          await _leaveMeet(meet, currentUser, context, -2);
        }
      }

      else {
        await _leaveMeet(meet, currentUser, context, 0);
      }
    }
  }

  _leaveMeet(SkibbleMeet meet, SkibbleUser currentUser, BuildContext context, int score) async {
    CustomBottomSheetDialog.showProgressSheet(context);


    //read the data again. Possible that data may have changed
    var foundOngoing = ongoingMeets.firstWhereOrNull((res) => meet.meetId == res.meet.meetId);
    var foundUpcoming = upcomingMeets.firstWhereOrNull((res) => meet.meetId == res.meet.meetId);

    bool value = false;
    if(foundOngoing != null) {
      value = await MeetsDatabase().leaveInvitedMeet(meet, currentUser, score);
    }

    else if(foundUpcoming != null) {
      value = await MeetsDatabase().leaveInvitedMeet(meet, currentUser, score);

    }

    else {
      value = await MeetsDatabase().unJoinMeet(meet, currentUser, score);
    }


    Navigator.pop(context);

    if(value) {
      context.read<AppData>().skibbleUser!.meetScore = context.read<AppData>().skibbleUser!.meetScore + score;
      CustomBottomSheetDialog.showSuccessSheet(context, 'You have successfully left this meet!.', onButtonPressed: () {
        Navigator.pop(context);

        if(Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

    }
    else {
      CustomBottomSheetDialog.showErrorSheet(context, 'Oops! Unable to delete this meet at the moment.', onButtonPressed: () { Navigator.pop(context); });
    }
  }


  inviteToMeet(SkibbleUser currentUser, SkibbleUser userToInvite, BuildContext context) async {
    var time = DateTime.now();

    if(time.isAfter(DateTime.fromMillisecondsSinceEpoch(selectedMeetForDetails!.meetDateTime))) {
      CustomBottomSheetDialog.showMessageSheet(context, 'This meet has ended. Create a new one.', onButtonPressed: () => Navigator.pop(context));
    }

    else if(DateTime.fromMillisecondsSinceEpoch(selectedMeetForDetails!.meetDateTime).difference(time).inHours < 1) {
      CustomBottomSheetDialog.showMessageSheet(context, 'Invite time limit is too short!', onButtonPressed: () => Navigator.pop(context));
    }

    else if(selectedMeetForDetails!.invitedUsers!.length + 1 > selectedMeetForDetails!.maxNumberOfPeopleMeeting) {

      CustomBottomSheetDialog.showMessageSheet(context, 'Maximum number of invites reached!', onButtonPressed: () => Navigator.pop(context));
    }

    else {
      var result = await MeetsDatabase().inviteUserToMeet(selectedMeetForDetails!, currentUser, userToInvite);

    }
  }

  unInviteToMeet(SkibbleUser currentUser, SkibbleUser userToInvite, BuildContext context) async {
    var time = DateTime.now();

    if(time.isAfter(DateTime.fromMillisecondsSinceEpoch(selectedMeetForDetails!.meetDateTime))) {
      CustomBottomSheetDialog.showMessageSheet(context, 'This meet has ended. You cannot cancel invite.', onButtonPressed: () => Navigator.pop(context));
    }

    else if(DateTime.fromMillisecondsSinceEpoch(selectedMeetForDetails!.meetDateTime).difference(time).inHours < 1) {
      CustomBottomSheetDialog.showMessageSheet(context, 'We are sorry. We cannot cancel the invite! The meet is almost about to start.', onButtonPressed: () => Navigator.pop(context));
    }
    //
    // else if(selectedMeetForDetails!.invitedUsers!.length + 1 > selectedMeetForDetails!.maxNumberOfPeopleMeeting) {
    //
    //   CustomBottomSheetDialog.showMessageSheet(context, 'Maximum number of invites reached!', onButtonPressed: () => Navigator.pop(context));
    // }

    else {
      var result = await MeetsDatabase().unInviteUserToMeet(selectedMeetForDetails!, currentUser, userToInvite);

    }
  }

  startMeet(BuildContext context, SkibbleMeet meet, SkibbleUser currentUser) async{
    // LocationServiceController().location.onLocationChanged.listen((event) {
    //
    // });
    try{
      var currentUserAddress = await GeoLocatorService().getCurrentPositionAddress(context);
      if(currentUserAddress != null) {
        await context.read<MeetsNavigationController>().initMeetNavigationView(currentUserAddress, meet.meetLocation!.address);

        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SampleNavigationApp()));

        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MeetNavigationView()));
      }
    }

    catch(e) {}
  }


}