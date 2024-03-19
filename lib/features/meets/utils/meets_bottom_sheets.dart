import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/features/meets/controllers/meets_date_time_controller.dart';
import 'package:skibble/features/meets/controllers/meets_privacy_controller.dart';
import 'package:skibble/features/meets/views/components/meets_date_time_picker_view.dart';
import 'package:skibble/features/meets/views/components/meets_privacy_picker_view.dart';
import 'package:skibble/features/meets/views/create_meet/create_meet_scaffold.dart';
import 'package:skibble/features/meets/views/create_meet/private_meet_chooser_view.dart';
import '../../../models/skibble_user.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../controllers/meets_controller.dart';
import '../controllers/meets_filter_controller.dart';
import '../controllers/meets_location_controller.dart';
import '../models/skibble_meet.dart';
import '../views/components/accessibility_location_filter_view.dart';
import '../views/components/cancel_meet_view.dart';
import '../views/components/filter_date_picker.dart';
import '../views/components/food_business_details_view.dart';
import '../views/components/meet_menu_options_view.dart';
import '../views/components/meet_save_delete_draft.dart';
import '../views/components/meets_bills_handle_sheet.dart';
import '../views/components/meets_filter_view.dart';
import '../views/components/meets_location_picker_view.dart';
import '../views/components/private_meet_choice_view.dart';
import '../views/create_meet/create_meet.dart';
import '../views/meet_details_page.dart';
import '../views/meet_message_views/ongoing_meet_conflict_view.dart';
import '../views/meet_message_views/upcoming_meet_conflict_view.dart';

class MeetsBottomSheets {


  showCreateMeetSheet(BuildContext context) async {

    await cu.showCupertinoModalPopup(
        context: context, builder: (c) => CreateMeetScaffold()

    );

  }
  // showCreateMeetSheet(BuildContext context) async{
  //   await showModalBottomSheet<bool>(
  //       context: context,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(20.0),
  //           topRight: Radius.circular(20.0),
  //         ),
  //       ),
  //       isDismissible: true,
  //       backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
  //       builder: (new_context) {
  //         return SafeArea(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //
  //                 Container(
  //                   width: 90,
  //                   margin: const EdgeInsets.only(top: 8),
  //                   height: 5,
  //                   decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(10),
  //                       color: Colors.grey.shade300
  //                   ),
  //                 ),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 15.0, bottom: 30),
  //                   child: Text('Create a meet',
  //                     style: TextStyle(
  //                         color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.bold
  //                     ),
  //                   ),
  //                 ),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   child: Card(
  //                     elevation: 0.5,
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(6),
  //                       // side: BorderSide(color: Colors.green.shade200)
  //                     ),
  //                     color: const Color(0xFFF8FDF8),
  //                     child: InkWell(
  //                       customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //                       onTap: () async{
  //                         Navigator.pop(new_context);
  //                         await cu.showCupertinoModalPopup(
  //                           context: context, builder: (c) => const CreateMeetScaffold()
  //                             // CreateMeet()
  //                         );
  //                         // _navigator.restorablePush(_dialogBuilder);
  //                         // _navigator.push(MaterialPageRoute(builder: (context) {
  //                         //   return CreateMealInvite();
  //                         // }));
  //                       },
  //                       child: Container(
  //                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
  //                         width: double.infinity,
  //                         decoration: const BoxDecoration(
  //                           // borderRadius: BorderRadius.circular(10),
  //                           // border: Border.all(color: Colors.blueGrey)
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             CircleAvatar(
  //                               child: Icon(Icons.waving_hand_rounded, color: kPrimaryColor.withOpacity(0.7), size: 19,),
  //                               backgroundColor: Colors.green.shade50,
  //                               radius: 18,
  //                             ),
  //
  //                             const SizedBox(width: 8,),
  //                             const Column(
  //                               // mainAxisAlignment: MainAxisAlignment.center,
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Text('Meal Invite', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
  //                                 SizedBox(height: 4,),
  //                                 Text('Invite someone for a meal today', style: TextStyle(fontSize: 12, color: Colors.blueGrey),),
  //
  //                               ],
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 )
  //               ],
  //             )
  //         );
  //       });
  // }


  void showMeetsPrivacySheet(BuildContext context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const MeetsPrivacyPickerView();
        });
  }


  void showMeetsBillsHandlingSheet(BuildContext context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const MeetBillsHandleSheet();
        });
  }

  Future<void> showMeetsLocationPickerSheet(BuildContext context,) async{
    Provider.of<MeetsLocationController>(context, listen: false).init();

    await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
      builder: (context) {
        return const MeetsLocationPickerView();
      });
  }

  Future<void> showMeetsSaveToDraftSheet(BuildContext context,) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const MeetSaveDeleteDraftView();
        });
  }

  Future<void> showMeetMenuOptionsSheet(BuildContext context, SkibbleMeet meet) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return MeetMenuOptionsView();
        });
  }

  Future<void> showPrivateMeetChooserViewSheet(BuildContext context,) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        showDragHandle: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const PrivateMeetChooserView();
        });
  }

  Future<bool?> showMeetsDateTimePickerSheet(BuildContext context, SkibbleFoodBusiness business, bool isFromLocationPicker) async{
   if(business.googlePlaceDetails!.openingHours != null) {
     context.read<MeetsDateTimeController>().initDateTimePicker(business);
     return await showModalBottomSheet<bool?>(
         context: context,
         shape: const RoundedRectangleBorder(
           borderRadius: BorderRadius.only(
             topLeft: Radius.circular(20.0),
             topRight: Radius.circular(20.0),
           ),
         ),
         isDismissible: true,
         isScrollControlled: true,
         backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
         builder: (context) {
           return MeetsDateTimePickerView(business: business, isFromLocationPicker: isFromLocationPicker);
         }
         );
   }
   else {
     return await showModalBottomSheet<bool?>(
       context: context,
       shape: const RoundedRectangleBorder(
         borderRadius: BorderRadius.only(
           topLeft: Radius.circular(20.0),
           topRight: Radius.circular(20.0),
         ),
       ),
       isDismissible: true,
       isScrollControlled: false,
       backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
       builder: (context) {
         return Container(
           margin: const EdgeInsets.symmetric(vertical: 40),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Text(
                 'Oops! We can\'t find the opening hours!',
                 style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
               ),

               const SizedBox(height: 10,),
               Text(
                 'We are unable to find the opening hours for this place.',
                 style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
               ),
             ],
           ),
         );
       });
   }
  }


  Future<bool?> showMeetsBusinessDetailsSheet(BuildContext context, SkibbleFoodBusiness business, bool allowCreateMeet) async{
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return FoodBusinessDetailsView(business: business, allowCreateMeet: allowCreateMeet,);
        });
  }

  Future<bool?> showMeetDetailsSheet(BuildContext context, SkibbleMeet meet,) async{
    context.read<MeetsController>().initMeetDetails(meet, context,);
    return Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return const MeetDetailsPage();
        },
      ),
    );


    // return await showModalBottomSheet<bool?>(
    //     context: context,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(20.0),
    //         topRight: Radius.circular(20.0),
    //       ),
    //     ),
    //     isDismissible: true,
    //     isScrollControlled: true,
    //     backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
    //     builder: (context) {
    //       return MeetDetailsPage(meet: meet);
    //     });
  }

  Future<bool?> showMeetDetailsFutureSheet(BuildContext context, String meetId,) async {
    return Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation, Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return MeetDetailsPageFuture(meetId: meetId);
        },
      ),
    );
  }

  Future<bool?> showMeetsFilterSheet(BuildContext context,) async{

    context.read<MeetsFilterController>().initMeetFilter();
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const MeetsFilterView();
        });
  }

  Future<bool?> showMeetsLocationAccessibilityFilterSheet(BuildContext context,) async{

    context.read<MeetsFilterController>().initMeetFilter();
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const AccessibilityLocationFilterView();
        });
  }

  Future<bool?> showUpcomingMeetConflictSheet(BuildContext context, SkibbleMeet meet) async{

    context.read<MeetsFilterController>().initMeetFilter();
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return UpcomingMeetConflict(meet: meet,);
        });
  }


  Future<bool?> showCancelMeetSheet(BuildContext context, SkibbleMeet meet, SkibbleUser currentUser, int scoreToDeduct, String message) async{

    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return currentUser.userId == meet.meetCreator.userId ? MeetCreatorCancelMeetView(meet: meet, scoreToDeduct: scoreToDeduct, message: message,) : CancelMeetView(meet: meet, scoreToDeduct: scoreToDeduct, message: message,);
        });
  }


  Future<bool?> showPrivateMeetChoiceSheet(BuildContext context, SkibbleMeetMeetPalPrivateMeetChoice choice, SkibbleUser currentUser,) async{
    context.read<MeetsPrivacyController>().initMeetChoice(choice);

    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const PrivateMeetChoiceView();
        });
  }


  Future<bool?> showOngoingMeetConflictSheet(BuildContext context, SkibbleMeet meet) async{

    context.read<MeetsFilterController>().initMeetFilter();
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: false,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return OngoingMeetConflict(meet: meet,);
        }
    );
  }


  Future<bool?> showMeetsDatePickerFilterSheet(BuildContext context, List<DateTime?> dates) async{
    return await showModalBottomSheet<bool?>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return MeetFilterDateTime(
            dates: dates,
            onDatesChanged: (value) async{
              // print(value);
              context.read<MeetsFilterController>().chooseDates(value);

            },
          );
        });
  }

}