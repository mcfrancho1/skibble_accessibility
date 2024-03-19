import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
import 'dart:math' as math;
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/change_data_notifiers/utils/shaking_error_data.dart';
import '../../../services/firebase/custom_collections_references.dart';
import '../../../shared/dialogs.dart';
import '../../../utils/constants.dart';
import '../models/skibble_meet.dart';
import '../services/database/meets_database.dart';
import '../services/storage/meets_local_storage.dart';
import '../utils/meets_bottom_sheets.dart';
import 'meets_bills_controller.dart';
import 'meets_controller.dart';
import 'meets_date_time_controller.dart';
import 'meets_location_controller.dart';
import 'meets_privacy_controller.dart';

class CreateEditMeetsController with ChangeNotifier {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int currentPage = 0;
  bool isEditing = false;
  int totalPageCount = 4;
  List<String> imagesList = [];
  List<String> randomTitles = [
    'Dinner Club',
    'TasteBuds Unite',
    'Munch Mates',
    'Dine & Connect',
    'Foodie Fusion',
    'Feast Society',
    'Savory Circles',
    'Flavorful Connections',
    'GastroGather',
    'Dining Delights',
    'Table Tales',
    'Meet Masters',
    'Nibble Network',
    'Culinary Connections',
    'Tasteful Gatherings',
    'Coffee Gang',
    'Coffee chat',
    'Crave club',
    'Booze squad',
    "Culinary Clan",
    "Gastronomy Gathering",
    "Palate Pioneers",
    "Foodie Fellowship",
    "Taste Troop",
    "Epicurean Ensemble",
    "Flavor Conclave",
    "Savory Soirée",
    "Bistro Brigade",
    "Gourmet Gang",
    "Cuisine Collective",
    "Menu Mavens",
    "Epicure's Assembly",
    "Tasty Troupe",
    "Culinary Clique",
    "Friends' Hangout",
   " Foodie Fiesta",
    "Chow Chow Club",
    "Munch 'n' Meet",
    "Tummy Tango",
    "Hungry Huddle",
    "Grubhub Hubbub",
    "TasteMates",
    "YumYum Yarn",
    "Fork & Friends",
    "Eat & Greetify",
    "NomNom Network",
    "Flavor Flock",
    "Belly Buddies",
    "Cravings Connection",
    "Feast Squad",
    "Supper Syndicate",
    "Bites & Bonds",
    "Gastro Gatherings",
    "Culinary Connections",
    "Savor Synchrony",
    "Feast Friendzy",
    "Social Suppers",
    "Table Talk Tribe",
    "Foodie Fellowship",
    "Flavorful Festivities",
    "Dine & Discover",
    "Epicurean Escapades",
    "Palate Pursuits",
    "Savory Socialites",
    "Meets & Munches",
    "Lunch Shenanigans",
    "Gobble Gang",
    'Munch Madness',
    "Chow Chow Crew",
    "Forked Up Friends",
    'Crave Cave',
    "YumYum Yahoos",
   " Plate Pals",
    "Hungry Hilarity",
    "NomNom Nook",
    "Savory Shenanigans",
    "Chomp Champs",
    "Tummy Troupe",
    "Foodie Fizz",
    "Delicious Diversions",
    "Sipster Social",
    "Libation Nation",
    "Thirsty Tribe",
    "Guzzle Gang",
    "Drinky Doodles",
    "Mix & Mingle",
    "Cheers Comrades",
    "Beverage Brigade",
    "Liquid Lovers",
    "Tipples & Tales",
    "Sip & Socialize",
    "Quench Crew",
    "Boozy Banter",
    "Drinkery Connect",
    "Refreshment Rendezvous",
    "Brew Buds",
    "Java Junction",
    "Caffeine Crew",
    "Espresso Enthusiasts",
    "Cuppa Companions",
    "Bean Banter",
    "Coffee Connect",
    "Mocha Meetups",
    "Roast & Relax",
    "Cappuccino Club",
    "Perk & Sip",
    "Coffeehouse Hangout",
    "Java Jive",
    "Coffee Connoisseurs",
    "Latte Larks",
    "Tea Time Tribe",
    "Steep & Sip",
    "Tea Tasters",
    "Leafy Lunatics",
    "Chai Chums",
    "Tea Talks",
    "Infusion Junction",
    "SereniTEA Squad",
    "Sip & Steep Society",
    "Tea-rrific Together",
    "Herbal Harmony",
    "Tea Totalers",
    "Tea Party People",
    "Tea Temptations",
    "Cup of Tea Club"
  ];
  int? meetImageIndex;

  bool showForwardButton = true;

  SkibbleMeet? editingMeet;
  SkibbleMeet? remixingMeet;

  List<Function>? createMeetsFunctions;

  bool callMeetTypeFunction(BuildContext context) {

    if(context.read<MeetsPrivacyController>().userPrivacyChoiceIndex == 1) {
      if(context.read<MeetsPrivacyController>().selectedPrivateUsers.isEmpty) {
        HapticFeedback.lightImpact();
        Fluttertoast.showToast(msg: 'Choose at least one meet pal', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
        return false;
      }
    }
    return true;
  }

  bool callMeetTitleFunction() {
    if(meetTitle.isEmpty) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Please enter a meet name', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
      return false;

    }
    return true;
  }

  bool callMeetLocationFunction(BuildContext context) {
    if(context.read<CreateEditMeetsController>().foodBusinessForMeetLocation == null) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Please select a meet location', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
      return false;

    }

    if(context.read<CreateEditMeetsController>().meetDateTime == null) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Please select a meet date & time.', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
      return false;
    }
    return true;
  }

  bool callMeetBillsHandleFunction() {return true;}

  bool callMeetPickImageFunction() {

    if(meetImageIndex == null) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Please select an image', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
      return false;
    }
    return true;
  }
  Future<bool> callCreateMeetFunction(BuildContext context) async{
    if(meetDescription.isEmpty) {
      HapticFeedback.lightImpact();
      Fluttertoast.showToast(msg: 'Please enter a short description.', backgroundColor: kPrimaryColor, textColor: kDarkSecondaryColor);
      return false;
    }

    if(editingMeet != null) {
      return await editMeet(context);
    }

    return await createMeet(context);

  }


  FocusNode focusNode = FocusNode();
  String meetTitle = '';
  String meetDescription = '';
  bool showUserLocation = true;


  void initCreateMeet(BuildContext context) {
    createMeetsFunctions = [
      () => callMeetTypeFunction(context),
      () => callMeetTitleFunction(),
      () => callMeetLocationFunction(context),
      () => callMeetPickImageFunction(),
      () => callMeetBillsHandleFunction(),
      () => callCreateMeetFunction(context),
    ];
  }

  Future<bool> initRemixMeet(BuildContext context, SkibbleMeet meet) async{
    remixingMeet = meet;
    var currentUser = context.read<AppData>().skibbleUser!;
    await fetchMeetImages();
    var imgIndex = imagesList.indexWhere((e) => meet.meetImage == e);

    //fetch food business details
    //fetch
    if(imgIndex == -1) {
      meetImageIndex = null;
    }

    else {
      meetImageIndex = imgIndex;
    }
    meetTitle = meet.meetTitle;
    currentPage = 0;

    if(meet.meetLocation != null) {
      foodBusinessForMeetLocation = await context.read<MeetsLocationController>().fetchGoogleDetails(context, context.read<MeetsLocationController>().selectedButtonIndex, googlePlaceId: meet.meetLocation!.address.googlePlaceId);
      context.read<MeetsLocationController>().finalSelectedBusinessId = foodBusinessForMeetLocation!.skibblePlaceId;

    }

    if(meet.meetDateTime != null) {
      var tempMeetDateTime = DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime);
      meetDateTime = DateTime(tempMeetDateTime.year, tempMeetDateTime.month, tempMeetDateTime.day, tempMeetDateTime.hour, tempMeetDateTime.minute);
      context.read<MeetsDateTimeController>().selectedDateTime = DateTime(meetDateTime!.year, meetDateTime!.month, meetDateTime!.day, meetDateTime!.hour, meetDateTime!.minute);
      context.read<MeetsDateTimeController>().tempSelectedDateTime = DateTime(meetDateTime!.year, meetDateTime!.month, meetDateTime!.day, meetDateTime!.hour, meetDateTime!.minute);

    }


    await context.read<MeetsPrivacyController>().initEdit(meet, currentUser);
    context.read<MeetsBillsController>().initEdit(meet);

    meetDescription = meet.meetDescription ?? '';
    maxNumberOfPeopleToMeet = meet.maxNumberOfPeopleMeeting.toDouble() - 1;

    createMeetsFunctions = [
          () => callMeetTypeFunction(context),
          () => callMeetTitleFunction(),
          () => callMeetLocationFunction(context),
          () => callMeetPickImageFunction(),
          () => callMeetBillsHandleFunction(),
          () => callCreateMeetFunction(context),
    ];

    return true;
  }


  Future<bool> initEditMeet(BuildContext context, SkibbleMeet meet) async{
    editingMeet = meet;
    var currentUser = context.read<AppData>().skibbleUser!;

    await fetchMeetImages();
    var imgIndex = imagesList.indexWhere((e) => meet.meetImage == e);

    //fetch food business details
    //fetch
    if(imgIndex == -1) {
      meetImageIndex = null;
    }

    else {
      meetImageIndex = imgIndex;
    }
    meetTitle = meet.meetTitle;
    currentPage = 0;
    foodBusinessForMeetLocation = await context.read<MeetsLocationController>().fetchGoogleDetails(context, context.read<MeetsLocationController>().selectedButtonIndex, googlePlaceId: meet.meetLocation!.address.googlePlaceId);
    context.read<MeetsLocationController>().finalSelectedBusinessId = foodBusinessForMeetLocation!.skibblePlaceId;

    var tempMeetDateTime = DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime);
    meetDateTime = DateTime(tempMeetDateTime.year, tempMeetDateTime.month, tempMeetDateTime.day, tempMeetDateTime.hour, tempMeetDateTime.minute);
    context.read<MeetsDateTimeController>().selectedDateTime = DateTime(meetDateTime!.year, meetDateTime!.month, meetDateTime!.day, meetDateTime!.hour, meetDateTime!.minute);
    context.read<MeetsDateTimeController>().tempSelectedDateTime = DateTime(meetDateTime!.year, meetDateTime!.month, meetDateTime!.day, meetDateTime!.hour, meetDateTime!.minute);

    await context.read<MeetsPrivacyController>().initEdit(meet, currentUser);
    context.read<MeetsBillsController>().initEdit(meet);

    meetDescription = meet.meetDescription ?? '';
    maxNumberOfPeopleToMeet = meet.maxNumberOfPeopleMeeting.toDouble() - 1;

    createMeetsFunctions = [
          () => callMeetTypeFunction(context),
          () => callMeetTitleFunction(),
          () => callMeetLocationFunction(context),
          () => callMeetPickImageFunction(),
          () => callMeetBillsHandleFunction(),
          () => callCreateMeetFunction(context),
    ];

    return true;
  }

  Future<void> fetchMeetImages() async{
    showForwardButton = false;
    imagesList = await MeetsDatabase().fetchMeetImages();
    showForwardButton = true;
    notifyListeners();
  }

  void nextPage() {
    currentPage += 1;
    notifyListeners();
  }

  void reset(BuildContext context) {
    meetImageIndex = null;
    meetTitle = '';
    currentPage = 0;
    context.read<MeetsLocationController>().reset();
    context.read<MeetsDateTimeController>().reset();
    context.read<MeetsPrivacyController>().reset();
    context.read<MeetsBillsController>().reset();
    editingMeet = null;
    meetDescription = '';
    foodBusinessForMeetLocation = null;
    meetDateTime = null;
    maxNumberOfPeopleToMeet = 1;
    resetDraft(context);
  }
  void chooseImage(int index) {
    meetImageIndex  = index;
    notifyListeners();
  }

  void previousPage() {
    if(currentPage != 0) {
      currentPage -= 1;
      notifyListeners();
    }
  }
  // double get maxNumberOfPeople => _maxNumberOfPeople;

  double maxNumberOfPeopleToMeet = 1;

  final ShakingErrorController dateController = ShakingErrorController(initialErrorText: 'Please select a date', hiddenInitially: true);
  final ShakingErrorController locationController = ShakingErrorController(initialErrorText: 'Please select a location', hiddenInitially: true);
// final ShakingErrorController foodOptionsController = ShakingErrorController(initialErrorText: 'Please select a date', hiddenInitially: true);

  SkibbleFoodBusiness? foodBusinessForMeetLocation;
  DateTime? meetDateTime;


  // void set maxNumberOfPeople(double value) {
  //   _maxNumberOfPeople = value;
  //   notifyListeners();
  // }

  String generateRandomTitle() {
    return randomTitles[math.Random().nextInt(randomTitles.length)];
  }

  void setFoodBusiness(SkibbleFoodBusiness business) {
    foodBusinessForMeetLocation = business;
    notifyListeners();
  }

  Future<void> saveMeetToDraft(BuildContext context) async{
    SkibbleMeet meet = SkibbleMeet(
        hideInterestedUsers: false,
        meetTitle: meetTitle,
        isActive: true,
        meetImage: imagesList.isNotEmpty ? imagesList[meetImageIndex ?? 0] : null,
        meetCreator: context.read<AppData>().skibbleUser!,
        meetLocation: foodBusinessForMeetLocation,
        meetDescription: meetDescription.trim(),
        meetStatus: SkibbleMeetStatus.created,
        // foodOptions: context.read<FoodOptionsPickerData>().userChoices,
        // meetPrivacyStatus: context.read<PrivacyPickerData>().spotPrivacyStatus,
        timeOfCreation: DateTime.now().millisecondsSinceEpoch,
        meetDateTime: context.read<MeetsDateTimeController>().selectedDateTime!.millisecondsSinceEpoch,
        lastUpdated: DateTime.now().millisecondsSinceEpoch,
        restrictedDistance: 100,
        maxNumberOfPeopleMeeting: maxNumberOfPeopleToMeet.toInt() + 1,
        meetPrivacyStatus: context.read<MeetsPrivacyController>().meetPrivacyStatus,
        meetBillsType: context.read<MeetsBillsController>().skibbleMeetBillsType,
        latestInterestedUsers: {},
        totalInterestedUsers: 0,
        totalInvitedUsers: context.read<MeetsPrivacyController>().meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? (context.read<MeetsPrivacyController>().selectedPrivateUsers).length : 0,
        totalRejectedUsers: 0,
        totalUsersWhoCancelled: 0,
        totalUsersWhoMet: 0,
        privateUsersIdList: context.read<MeetsPrivacyController>().selectedPrivateUsers.map((e) => e.userId!).toList(),
        automaticallyApproveInterestedUsers: false,
        totalPrivateUsers: (context.read<MeetsPrivacyController>().selectedPrivateUsers).length, meetId: '', meetRef: ''
    );

    await MeetsLocalStorage().setDraftMeet(meet);
  }

  Future<void> resetDraft(BuildContext context) async {
    await MeetsLocalStorage().setDraftMeet(null);
  }


  Future<SkibbleMeet?> getDraftMeet() async {
    var mapMeet = MeetsLocalStorage().getDraftMeet();

    if(mapMeet != null) {
      return SkibbleMeet.fromMap(mapMeet);
    }
    return null;
  }

  Future<bool> createMeet(BuildContext context) async {
    try {
      var upcomingMeets = context.read<MeetsController>().upcomingMeets;
      var ongoingMeets = context.read<MeetsController>().ongoingMeets;

      var time = DateTime.now();

      var docRef = FirebaseCollectionReferences.meetsCollection.doc();

      SkibbleMeet meet = SkibbleMeet(
          hideInterestedUsers: false,
          meetTitle: meetTitle,
          isActive: true,
          meetImage: imagesList[meetImageIndex ?? 0],
          meetCreator: context.read<AppData>().skibbleUser!,
          meetLocation: foodBusinessForMeetLocation,
          meetDescription: meetDescription.trim(),
          meetStatus: SkibbleMeetStatus.created,
          // foodOptions: context.read<FoodOptionsPickerData>().userChoices,
          // meetPrivacyStatus: context.read<PrivacyPickerData>().spotPrivacyStatus,
          timeOfCreation: DateTime.now().millisecondsSinceEpoch,
          meetDateTime: context.read<MeetsDateTimeController>().selectedDateTime!.millisecondsSinceEpoch,
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
          restrictedDistance: 100,
          meetId: docRef.id,
          maxNumberOfPeopleMeeting: maxNumberOfPeopleToMeet.toInt() + 1,
          meetPrivacyStatus: context.read<MeetsPrivacyController>().meetPrivacyStatus,
          meetRef: docRef.path,
          meetBillsType: context.read<MeetsBillsController>().skibbleMeetBillsType,
          latestInterestedUsers: {},
          totalInterestedUsers: 0,
          totalInvitedUsers: context.read<MeetsPrivacyController>().meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ? (context.read<MeetsPrivacyController>().selectedPrivateUsers).length : 0,
          totalRejectedUsers: 0,
          totalUsersWhoCancelled: 0,
          totalUsersWhoMet: 0,
          privateUsersIdList: context.read<MeetsPrivacyController>().selectedPrivateUsers.map((e) => e.userId!).toList(),
          automaticallyApproveInterestedUsers: false,
          totalPrivateUsers: (context.read<MeetsPrivacyController>().selectedPrivateUsers).length
      );


      if(meet.meetDateTime <= time.millisecondsSinceEpoch) {
        CustomBottomSheetDialog.showMessageSheet(context, 'Your meet time is invalid', onButtonPressed: () {Navigator.pop(context);});
        return false;
      }

      //if meet is clashing with an upcoming meet
      var clashingUpcomingMeetIndex = upcomingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingUpcomingMeetIndex != -1) {
        //TODO: Show upcoming meet message
        MeetsBottomSheets().showUpcomingMeetConflictSheet(context, upcomingMeets[clashingUpcomingMeetIndex].meet);
        return false;
      }

      //if meet is clashing with an ongoing meet
      var clashingOngoingMeetIndex = ongoingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingOngoingMeetIndex != -1) {
        //TODO: Show ongoing meet message
        MeetsBottomSheets().showOngoingMeetConflictSheet(context, ongoingMeets[clashingOngoingMeetIndex].meet);

        return false;
      }


      context.read<MeetsLoadingController>().isLoadingThird = true;
      // CustomDialog(context).showProgressDialog('Creating meet...');
      // Navigator.pop(context);


      var res = await MeetsDatabase().createMeet(meet, privateUsers:context.read<MeetsPrivacyController>().selectedPrivateUsers );
      // Navigator.pop(context);

      if(res == 'success') {
        context.read<MeetsLoadingController>().isLoadingThird = false;
        return true;

        // context.read<SpotsData>().resetAll(context);
        // CustomDialog(context).showCustomMessage('Success', 'Your invite has been created successfully');
      }
      else {

        CustomDialog(context).showCustomMessage('Error', 'Unable to create your meet');
        return false;
      }
      // else {
      //   if(location == null) {
      //     locationController.showError();
      //   }
      // }
    }
    catch(e) { return false;}

  }


  Future<bool> editMeet(BuildContext context) async {
    try {
      var upcomingMeets = context.read<MeetsController>().upcomingMeets;
      var ongoingMeets = context.read<MeetsController>().ongoingMeets;

      var time = DateTime.now();

      if(editingMeet!.meetDateTime <= time.millisecondsSinceEpoch) {
        CustomBottomSheetDialog.showMessageSheet(context, 'Your meet time is invalid', onButtonPressed: () {Navigator.pop(context);});
        return false;
      }

      //if meet is clashing with an upcoming meet
      var clashingUpcomingMeetIndex = upcomingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(editingMeet!.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingUpcomingMeetIndex != -1) {
        //TODO: Show upcoming meet message
        MeetsBottomSheets().showUpcomingMeetConflictSheet(context, upcomingMeets[clashingUpcomingMeetIndex].meet);
        return false;
      }

      //if meet is clashing with an ongoing meet
      var clashingOngoingMeetIndex = ongoingMeets.indexWhere((element) {
        var difference = DateTime.fromMillisecondsSinceEpoch(element.meet.meetDateTime).difference(DateTime.fromMillisecondsSinceEpoch(editingMeet!.meetDateTime));

        return difference.inHours >= -2 && difference.inHours <= 2;
      });

      if(clashingOngoingMeetIndex != -1) {
        //TODO: Show ongoing meet message
        MeetsBottomSheets().showOngoingMeetConflictSheet(context, ongoingMeets[clashingOngoingMeetIndex].meet);

        return false;
      }


      context.read<MeetsLoadingController>().isLoadingThird = true;
      // CustomDialog(context).showProgressDialog('Creating meet...');
      // Navigator.pop(context);


      var res = await MeetsDatabase().createMeet(editingMeet!, privateUsers:context.read<MeetsPrivacyController>().selectedPrivateUsers );
      // Navigator.pop(context);

      if(res == 'success') {
        context.read<MeetsLoadingController>().isLoadingThird = false;
        return true;

        // context.read<SpotsData>().resetAll(context);
        // CustomDialog(context).showCustomMessage('Success', 'Your invite has been created successfully');
      }
      else {

        CustomDialog(context).showCustomMessage('Error', 'Unable to create your meet');
        return false;
      }
      // else {
      //   if(location == null) {
      //     locationController.showError();
      //   }
      // }
    }
    catch(e) { return false;}

  }

}