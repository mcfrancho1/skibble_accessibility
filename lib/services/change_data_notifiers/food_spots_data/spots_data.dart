
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:provider/provider.dart';
import 'package:skibble/models/food_spot.dart';
import 'package:skibble/models/place_suggestion.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';

import '../../../features/connect/spot_info/interested_attending_users_view.dart';
import '../../../features/connect/spot_info/meal_invite_info_view.dart';
import '../../../features/connect/utils/create_meal_invite.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../firebase/database/food_spots_database/meal_invites_database.dart';
import '../app_data.dart';
import '../picker_data/date_time_picker_data.dart';
import '../picker_data/food_options_picker_data.dart';
import '../picker_data/location_picker_data.dart';
import '../picker_data/privacy_picker_data.dart';


class SpotsData with ChangeNotifier {

  FocusNode focusNode = FocusNode();

  //This are used when creating a new spot - meal invite
  String inviteTitle = '';
  String specialNotes = '';
  bool _showUserLocation = true;

  bool _isDoneButtonPressed = true;

  String spotId = '';
  double restrictedDistance = 100;
  int numberOfExpectedGuests = 10;
  DateTime timeOfCreation = DateTime.now();

  List<FoodSpot> _currentUserSpots = [];

  ///key:string - spotId; value- list of users
  Map<String, List<SkibbleUser>> _interestedUsers = {};

  ///key:string - spotId; value- list of users
  Map<String, List<SkibbleUser>> _invitedUsers = {};

  ///Used to keep track of the invited users page to make sure data has been fetched for the first time
  bool _isInvitedUsersFetched = false;


  ///Used to keep track of the invite buttons that were tapped in the Interested users view
  Map<String, List<bool>> _isInviteButtonTapped = {};
  Map<String, List<bool>> _isUnInviteButtonTapped = {};


  FoodSpot? _currentSpotToView;
  FoodSpot? _currentSpotToEdit;
  FoodSpot? _currentSpotToCreate;


  Map<String, List<bool>> get isInviteButtonTapped => _isInviteButtonTapped;
  Map<String, List<bool>> get isUnInviteButtonTapped => _isUnInviteButtonTapped;

  List<FoodSpot> get currentUserSpots => _currentUserSpots;
  FoodSpot? get currentSpotToView => _currentSpotToView;
  FoodSpot? get currentSpotToEdit => _currentSpotToEdit;
  FoodSpot? get currentSpotToCreate => _currentSpotToCreate;
  bool get spotShowUserLocation => _showUserLocation;
  bool get isDoneButtonPressed => _isDoneButtonPressed;
  bool get isInvitedUsersFetched => _isInvitedUsersFetched;


  void set isDoneButtonPressed(bool value) {
    _isDoneButtonPressed = value;
    notifyListeners();
  }

  void set isInvitedUsersFetched(bool value) {
    _isInvitedUsersFetched = value;
    notifyListeners();
  }

  Map<String, List<SkibbleUser>> get interestedUsers => _interestedUsers;
  Map<String, List<SkibbleUser>> get invitedUsers => _invitedUsers;


  void updateIsInviteButtonTapped(String spotId, int index, bool value) {
    _isInviteButtonTapped[spotId]![index] = value;
    notifyListeners();
  }

  void setSpotTitle(String value) {
    inviteTitle = value;
  }

  void set spotShowUserLocation(bool value) {
    _showUserLocation = value;
  }


  void initSpotToEdit(BuildContext context, FoodSpot spotToEdit) {
    inviteTitle = spotToEdit.title;
    spotShowUserLocation = spotToEdit.isHostLocationPublic;
    specialNotes = spotToEdit.specialNotes ?? '';
    numberOfExpectedGuests = spotToEdit.numberOfExpectedGuests;
    restrictedDistance = spotToEdit.restrictedDistance;
    spotId = spotToEdit.spotId;
    timeOfCreation = DateTime.fromMillisecondsSinceEpoch(spotToEdit.timeOfCreation);
    context.read<LocationPickerData>().selectedSuggestion = PlaceSuggestion(secondaryText: spotToEdit.location.formattedAddress ?? '', mainText: spotToEdit.location.placeName!, placeId: spotToEdit.location.googlePlaceId!);
    context.read<FoodOptionsPickerData>().userChoices = spotToEdit.foodOptions!;
    context.read<PrivacyPickerData>().spotPrivacyStatus = spotToEdit.foodSpotPrivacyStatus;
    context.read<DateTimePickerData>().selectedDateTime = DateTime.fromMillisecondsSinceEpoch(spotToEdit.spotDateTime);

  }


  void resetAll(BuildContext context) {
    try {
      inviteTitle = '';
      specialNotes = '';
      _showUserLocation = true;
      _isDoneButtonPressed = true;
      spotId = '';
      restrictedDistance = 100;
      numberOfExpectedGuests = 10;
      timeOfCreation = DateTime.now();
      context.read<LocationPickerData>().reset();
      context.read<FoodOptionsPickerData>().reset();
      context.read<PrivacyPickerData>().reset();
      context.read<DateTimePickerData>().reset();
    }

    catch(e) {
      print(e);
    }
  }

  void updateIsUnInviteButtonTapped(String spotId, int index, bool value) {
    _isUnInviteButtonTapped[spotId]![index] = value;
    notifyListeners();
  }

  void set currentUserSpots(List<FoodSpot> spots) {
    currentUserSpots = spots;
    notifyListeners();
  }

  void set currentSpotToView(FoodSpot? spot) {
    _currentSpotToView = spot;
    notifyListeners();
  }

  void updateInterestedUsers(String spotId, List<SkibbleUser> users) {
    _interestedUsers[spotId] = users;
    _isInviteButtonTapped[spotId] = List.generate(users.length, (index) => false);
    _isUnInviteButtonTapped[spotId] = List.generate(users.length, (index) => false);

    notifyListeners();
  }

  void updateInvitedUsers(String spotId, List<SkibbleUser> users) {
    _invitedUsers[spotId] = users;
    notifyListeners();
  }

  //invite a user and remove from the list
  void inviteInterestedUser(String spotId, int index) {
    _interestedUsers[spotId]?.removeAt(index);
    _isInviteButtonTapped[spotId]?.removeAt(index);
    _isUnInviteButtonTapped[spotId]?.removeAt(index);
    notifyListeners();
  }


  deleteCurrentUserSpots(int index) {
    _currentUserSpots.removeAt(index);
    notifyListeners();
  }

  updateCurrentUserSpots(FoodSpot spot, int index) {
    _currentUserSpots.removeAt(index);
    notifyListeners();
  }

  showCurrentSpotInfo(context, {FoodSpot? item, String? spotId}) async{
    if(item == null) {
      CustomBottomSheetDialog.showProgressSheet(context);
      var spot = await MealInviteDatabase().getSpotInfo(spotId!);
      Navigator.pop(context);
      currentSpotToView = spot;
      _showSpotInfo(context);
    }
    else {
      currentSpotToView = item;
      _showSpotInfo(context);
    }

  }

  _showSpotInfo(context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return MealInviteInfoView();
        });
  }


  showSkibblersInterestedAndAttending(context, FoodSpot spot) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return InterestedAttendingView(spot: spot,);
      });
  }


  showSkibblersInterested(context, FoodSpot spot) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return InterestedView(spot: spot,);
        });
  }

  showCreateSpotSheet(BuildContext context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (new_context) {
          return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    width: 90,
                    margin: EdgeInsets.only(top: 8),
                    height: 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade300
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                    child: Text('Create a spot',
                      style: TextStyle(
                          color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        // side: BorderSide(color: Colors.green.shade200)
                      ),
                      color: Color(0xFFF8FDF8),
                      child: InkWell(
                        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        onTap: () async{
                          Navigator.pop(new_context);
                          await cu.showCupertinoModalPopup(context: context, builder: (c) => CreateMealInvite());
                          // _navigator.restorablePush(_dialogBuilder);
                          // _navigator.push(MaterialPageRoute(builder: (context) {
                          //   return CreateMealInvite();
                          // }));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          width: double.infinity,
                          child: Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.waving_hand_rounded, color: kPrimaryColor.withOpacity(0.7), size: 19,),
                                backgroundColor: Colors.green.shade50,
                                radius: 18,
                              ),

                              SizedBox(width: 8,),
                              Column(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Meal Invite', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                                  SizedBox(height: 4,),
                                  Text('Invite someone for a meal today', style: TextStyle(fontSize: 12, color: Colors.blueGrey),),

                                ],
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              // border: Border.all(color: Colors.blueGrey)
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          );
        });
  }
}