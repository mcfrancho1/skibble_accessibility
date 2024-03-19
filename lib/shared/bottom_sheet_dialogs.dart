import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/communities/controllers/community_controller.dart';
import 'package:skibble/models/food_spot.dart';

import '../enums/share_type.dart';
import '../features/communities/models/community.dart';
import '../models/share_model.dart';
import '../models/skibble_user.dart';
import '../services/firebase/dynamic_links.dart';
import '../services/share_service.dart';
import '../features/communities/views/create_update_communities/edit_community_view.dart';
import '../features/connect/utils/confirm_interest_view.dart';
import '../utils/constants.dart';
import '../utils/current_theme.dart';
import '../utils/helper_methods.dart';
import 'flag_community_view.dart';

class CustomBottomSheetDialog {

  // final BuildContext context;
  // CustomBottomSheetDialog(this.context);


  static void showSpotConfirmationDialog(FoodSpot spot, context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return ConfirmInterestView(spot: spot,);
        });
  }


  static void showLocationPermissionSheet(String message, context) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Location Permissions',
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 16

                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),


                  Center(
                    child: ElevatedButton(
                      child: const Text('Open Settings', style: TextStyle(color: kLightSecondaryColor),),

                      onPressed: () async{
                        Navigator.pop(context);
                        await openAppSettings();

                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  static Future<bool?> showConfirmationSheet(context, String title, String message, String confirmationString, {required Function() onConfirm}) async{
    return await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 16

                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  ElevatedButton(
                    child: Text(confirmationString, style: const TextStyle(color: kLightSecondaryColor),),

                    onPressed: () => Navigator.of(context).pop(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  static void showProgressSheet(BuildContext context, {String? message, bool isDismissible = false}) async{
    await showModalBottomSheet<bool>(
        context: context,
        isDismissible: isDismissible,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return const SizedBox(
            height: 200,
            child: LoadingSpinner(
              color: kDarkSecondaryColor,
              size: 40,
            ),
          );
        });
  }

  static void showProgressSheetWithMessage(BuildContext context, String title, String message) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        // isDismissible: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),

                const SizedBox(height: 10,),

                Text(message),
                const SizedBox(height: 4,),
                const LoadingSpinner(
                  color: kDarkSecondaryColor,
                  size: 30,
                ),
              ],
            ),
          );;
        });
  }


  static Future<bool?> showSuccessSheet(context, String message, {required Function() onButtonPressed, bool isDismissible = false}) async{
    return await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: isDismissible,
        enableDrag: false,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20,),

                  SvgPicture.asset(
                      'assets/icons/success.svg',
                    height: 100,
                    width: 100,
                  ),



                  const SizedBox(height: 20,),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Success',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18

                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: onButtonPressed,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightSecondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300, width: 1)

                          ),


                        ),
                        child: const Text('Close', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  static void showErrorSheet(BuildContext context, String message, {required Function() onButtonPressed}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: false,
        enableDrag: false,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20,),

                  // SvgPicture.asset(
                  //   'assets/icons/error.svg',
                  //   height: 50,
                  //   width: 50,
                  // ),

                  Icon(Icons.error_rounded, color: kErrorColor, size: 100,),


                  const SizedBox(height: 20,),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Error',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 20

                      ),),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: onButtonPressed,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightSecondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300, width: 1)

                          ),


                        ),
                        child: const Text('Close', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  static void showMessageSheet(context, String message, {required Function() onButtonPressed}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: false,
        enableDrag: false,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20,),

                  const Icon(Icons.info_outline_rounded, size: 100, color: Colors.amber,),

                  const SizedBox(height: 20,),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Success',
                  //     style: TextStyle(fontWeight: FontWeight.bold,
                  //         fontSize: 16
                  //
                  //     ),),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: onButtonPressed,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightSecondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300, width: 1)

                          ),


                        ),
                        child: const Text('Close', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  static void showLoginAgainMessageDuringSignUpSheet(context, String message, {required Function() onButtonPressed}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        enableDrag: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20,),

                  const Icon(Icons.error_rounded, size: 100, color: Colors.amber,),

                  const SizedBox(height: 20,),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Success',
                  //     style: TextStyle(fontWeight: FontWeight.bold,
                  //         fontSize: 16
                  //
                  //     ),),
                  // ),


                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Restart Sign Up Process', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: onButtonPressed,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightSecondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300, width: 1)

                          ),


                        ),
                        child: const Text('Start registration again', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  static void showFeedbackSheet(context, String message, {required Function() onButtonPressed}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        enableDrag: true,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20,),

                  const Icon(Icons.bug_report_rounded, size: 100, color:  kDarkSecondaryColor,),

                  const SizedBox(height: 20,),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Success',
                  //     style: TextStyle(fontWeight: FontWeight.bold,
                  //         fontSize: 16
                  //
                  //     ),),
                  // ),


                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Report a bug', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 10,),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(message, textAlign: TextAlign.center,),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: ElevatedButton(
                        onPressed: onButtonPressed,

                        style: ElevatedButton.styleFrom(
                          backgroundColor: kLightSecondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(color: Colors.grey.shade300, width: 1)

                          ),


                        ),
                        child: const Text('Start bug report', style: TextStyle(color: kDarkSecondaryColor, fontWeight:  FontWeight.bold),),

                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }


  static void showUnfollowUserSheet(context, SkibbleUser user, {required Function() onButtonPressed}) async{
    await showModalBottomSheet<bool>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        enableDrag: false,
        // isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20,),
                   Text('Unfollow ${user.fullName}', style: const TextStyle(color: kDarkSecondaryColor, fontSize: 20, fontWeight: FontWeight.bold),),


                  const SizedBox(height: 8,),

                  Text('Are you sure you want to unfollow ${user.fullName}?', style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 20,),

                  Center(
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0.1
                      ),

                      child: const Text('Yes, unfollow', style: TextStyle(color: kErrorColorDark, fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  static Future<List<File>?> showPhotoMultiSelectionDialog(BuildContext context, RequestType type, String? photoUrl, File? currentPhoto,
      {
        required Function() onCameraSelected,
        required Function() onGallerySelected,
        required Function() onRemoveMedia,
        required Function() onDeleteCurrentPhoto,
        index
      }
  ) async{
    return await showModalBottomSheet<List<File>>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: ListBody(
                children: [

                  const Center(
                    child: Text(
                      'Share',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  ListTile(
                    leading: const Icon(Iconsax.camera, color: kDarkSecondaryColor,),
                      title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w500),),
                      onTap: onCameraSelected
                  ),
                  // ListTile(
                  //     leading: CircleAvatar(
                  //       backgroundColor: kPrimaryColorLight,
                  //         radius: 24,
                  //         child: Icon(Iconsax.camera, color: kPrimaryColor,)),
                  //     title: Text('Camera', style: TextStyle(fontWeight: FontWeight.w600),),
                  //     onTap: onCameraSelected
                  // ),

                  const Divider(),
                  ListTile(
                      leading: const Icon(CupertinoIcons.photo_on_rectangle, color: kDarkSecondaryColor,),
                      // leading: CircleAvatar(
                      //     backgroundColor: kPrimaryColorLight,
                      //     radius: 24,
                      //     child: Icon(CupertinoIcons.photo_on_rectangle, color: kPrimaryColor,)),
                      title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w500)),
                      onTap: onGallerySelected
                  ),

                  currentPhoto == null ? photoUrl != null ?
                  Column(
                    children: [
                      const Divider(),

                      ListTile(
                          leading: const Icon(Iconsax.trash),
                          title: const Text('Delete Photo'),
                          onTap: onDeleteCurrentPhoto
                      ),
                    ],
                  )
                      :
                  Container()
                      :
                  ListTile(
                      leading: const Icon(Iconsax.trash),
                      title: const Text('Remove Media'),
                      onTap: onRemoveMedia
                  ),
                ],
              ),
            ),
          );
        });
  }

  static Future<List<File>?> showMediaSelectionDialog(BuildContext context, {required Function() onCameraSelected, required Function() onGallerySelected,}) async{
    return await showModalBottomSheet<List<File>>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: true,
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
        builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: ListBody(
                children: [

                  const Center(
                    child: Text(
                      'Media',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  ListTile(
                      leading: const Icon(Iconsax.camera, color: kDarkSecondaryColor,),
                      title: const Text('Camera', style: TextStyle(fontWeight: FontWeight.w500),),
                      onTap: () {
                        Navigator.pop(context);
                        onCameraSelected();
                      }
                  ),
                  // ListTile(
                  //     leading: CircleAvatar(
                  //       backgroundColor: kPrimaryColorLight,
                  //         radius: 24,
                  //         child: Icon(Iconsax.camera, color: kPrimaryColor,)),
                  //     title: Text('Camera', style: TextStyle(fontWeight: FontWeight.w600),),
                  //     onTap: onCameraSelected
                  // ),

                  const Divider(),
                  ListTile(
                      leading: const Icon(CupertinoIcons.photo_on_rectangle, color: kDarkSecondaryColor,),
                      // leading: CircleAvatar(
                      //     backgroundColor: kPrimaryColorLight,
                      //     radius: 24,
                      //     child: Icon(CupertinoIcons.photo_on_rectangle, color: kPrimaryColor,)),
                      title: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context);
                        onGallerySelected();
                      }
                  ),

                ],
              ),
            ),
          );
        });
  }

  static Future<String?> showCustomShareSheet(BuildContext context, ShareModel model) async{

    final String header = model.header;
    final String subHeader = model.subHeader;
    final ShareType shareType = model.shareType;
    final String contentId = model.contentId;
    final String? contentTitle = model.contentTitle;
    final String? imageUrl = model.imageUrl;
    final String? authorName = model.authorName;
    final String? previewContent = model.previewContent;
    return await showModalBottomSheet(
      // enableDrag: false,
      // isDismissible: false,

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      context: context,
      builder: (context) => Container(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15,  top: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      header, style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 19
                    ),),
                    const SizedBox(height: 10,),
                    Text(
                      subHeader, style: const TextStyle(

                        fontSize: 13
                    ),),
                  ],
                ),
              ),

              const SizedBox(height: 20,),

              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    //skibbler
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 15.0, right: 10),
                    //   child: GestureDetector(
                    //     onTap:()async  {
                    //
                    //       Navigator.pop(context);
                    //
                    //       var value = await showModalBottomSheet<bool>(
                    //           context: context,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.only(
                    //               topLeft: Radius.circular(20.0),
                    //               topRight: Radius.circular(20.0),
                    //             ),
                    //           ),
                    //           isDismissible: true,
                    //           backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    //           builder: (context) {
                    //             return ShareFriendView(
                    //               shareType: ChatMessageType.skib,
                    //               contentId: contentId,
                    //               // conversationFriendId: skibblePost.postAuthorId,
                    //             );
                    //           });
                    //     },
                    //     child: Column(
                    //       children: [
                    //         CircleAvatar(
                    //           child: Icon(
                    //             Iconsax.people, size: 24,
                    //             color: kLightSecondaryColor,
                    //
                    //             // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    //           ),
                    //           backgroundColor: kPrimaryColor,
                    //           radius: 24,
                    //
                    //         ),
                    //         SizedBox(height: 12,),
                    //         Text('Skibblers', style: TextStyle(fontSize: 15))
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    //link

                    //copy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap:() async{
                          // Navigator.pop(context);

                           showModalBottomSheet(
                            // enableDrag: false,
                            // isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                              ),
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: const CircularProgressIndicator(strokeWidth: 2,)),),
                              )
                          );

                          // var result = await DynamicLinks().createDynamicLink(
                          //     'skib',
                          //     widget.skibblePost.postId!,
                          //     title: 'Skib by ${widget.skibAuthor!.fullName}',
                          //     imageUrl: widget.skibblePost.postContentList![0]!['type'] == 'image' ? widget.skibblePost.postContentList![0]!['content']  : widget.skibblePost.postContentList![0]!['videoThumbnail'],
                          //     description: widget.skibblePost.caption
                          // );

                          // var result = await ShareService.copyToClipBoard(
                          //     'skib',
                          //     widget.skibblePost.postId!,
                          //     title: 'Skib by ${widget.skibAuthor!.fullName}',
                          //     imageUrl: widget.skibblePost.postContentList![0]!['type'] == 'image' ? widget.skibblePost.postContentList![0]!['content']  : widget.skibblePost.postContentList![0]!['videoThumbnail'],
                          //     description: widget.skibblePost.caption
                          // );

                          var result = await ShareService.copyToClipBoard(
                              shareType,
                              contentId,
                              title: contentTitle,
                              imageUrl: imageUrl,
                              description: previewContent
                          );

                          Navigator.of(context).pop();
                          if(result != null) {
                            Navigator.of(context).pop(result);

                            Fluttertoast.showToast(msg: 'Link copied.', backgroundColor: Colors.grey.shade100, textColor: kDarkSecondaryColor);

                          }


                        },
                        child: Column(
                          children: [
                            CircleAvatar(

                              child: Icon(
                                Iconsax.link_1, size: 24, color: Colors.grey.shade500,
                                // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              ),
                              backgroundColor: Colors.grey.shade200,
                              radius: 24,
                            ),
                            const SizedBox(height: 12,),

                            const Text('Copy link', style: TextStyle(fontSize: 15),)
                          ],
                        ),
                      ),
                    ),


                    //sms
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap:()async  {

                          showModalBottomSheet(
                            // enableDrag: false,
                            // isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                              ),
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: const CircularProgressIndicator(strokeWidth: 2,)),),
                              )
                          );

                          var result = await ShareService.shareToSms(
                              shareType,
                              contentId,
                              title: contentTitle,
                              imageUrl: imageUrl,
                              description: previewContent
                          );


                          Navigator.of(context).pop();
                          if(result != null) {
                            //
                            Navigator.of(context).pop(result);

                          }
                        },
                        child: const Column(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                FontAwesome.chat, size: 24,
                                color: kLightSecondaryColor,

                                // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              ),
                              backgroundColor: Colors.greenAccent,
                              radius: 24,

                            ),
                            SizedBox(height: 12,),
                            Text('Messages', style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                    ),

                    //whatsapp
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap:()async  {

                          showModalBottomSheet(
                            // enableDrag: false,
                            // isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                              ),
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: const CircularProgressIndicator(strokeWidth: 2,)),),
                              )
                          );

                          var result = await ShareService.shareToWhatsapp(
                              shareType,
                              contentId,
                              title: contentTitle,
                              imageUrl: imageUrl,
                              description: previewContent
                          );


                          Navigator.of(context).pop();
                          if(result != null) {
                            //
                            Navigator.of(context).pop(result);

                          }
                        },
                        child: const Column(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                FontAwesome.whatsapp, size: 24,
                                color: kLightSecondaryColor,

                                // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              ),
                              backgroundColor: Color(0xFF25D366),
                              radius: 24,

                            ),
                            SizedBox(height: 12,),
                            Text('Whatsapp', style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                    ),

                    //twitter
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap:()async  {
                          showModalBottomSheet(
                            // enableDrag: false,
                            // isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                              ),
                              context: context,
                              builder: (context) => Container(
                                height: 100,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: const CircularProgressIndicator(strokeWidth: 2,)),),
                              )
                          );

                          var result = await ShareService.shareToTwitter(
                              shareType,
                              contentId,
                              title: contentTitle,
                              imageUrl: imageUrl,
                              description: previewContent
                          );


                          Navigator.of(context).pop();
                          if(result != null) {
                            //
                            Navigator.of(context).pop(result);

                          }
                        },
                        child: const Column(
                          children: [
                            CircleAvatar(
                              child: Icon(
                                FontAwesome.twitter, size: 24,
                                color: Color(0xFFFFFFFF),

                                // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              ),
                              backgroundColor: Color(0xFF1DA1F2),
                              radius: 24,

                            ),
                            SizedBox(height: 12,),
                            Text('Twitter', style: TextStyle(fontSize: 15))
                          ],
                        ),
                      ),
                    ),


                    //more
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap:() async{
                          // Navigator.pop(context);

                          showModalBottomSheet(
                            // enableDrag: false,
                            // isDismissible: false,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                              ),
                              context: context,
                              builder: (context) => SizedBox(
                                height: 100,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: 40,
                                      child: const CircularProgressIndicator(strokeWidth: 2,)),),
                              )
                          );

                          // var result = await DynamicLinks().createDynamicLink(
                          //     'skib',
                          //     widget.skibblePost.postId!,
                          //     title: 'Skib by ${widget.skibAuthor!.fullName}',
                          //     imageUrl: widget.skibblePost.postContentList![0]!['type'] == 'image' ? widget.skibblePost.postContentList![0]!['content']  : widget.skibblePost.postContentList![0]!['videoThumbnail'],
                          //     description: widget.skibblePost.caption
                          // );

                          var result = await DynamicLinks().createDynamicLink(
                              shareType,
                              contentId,
                              title: contentTitle,
                              imageUrl: imageUrl,
                              description: previewContent
                          );


                          Navigator.of(context).pop();
                          if(result != null) {
                              HelperMethods().shareData(context,
                              previewContent ?? '',
                              contentTitle ?? 'Share');

                            Navigator.of(context).pop(result);

                          }
                        },
                        child: Column(
                          children: [
                            CircleAvatar(

                              backgroundColor: Colors.grey.shade200,
                              radius: 24,

                              child: Icon(
                                Iconsax.more, size: 24, color: Colors.grey.shade500,
                                // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 12,),

                            const Text('More', style: TextStyle(fontSize: 15),)
                          ],
                        ),
                      ),
                    ),


                    ///facebook
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: GestureDetector(
                    //     onTap:()async  {
                    //
                    //       Navigator.pop(context);
                    //
                    //       var value = await showModalBottomSheet<bool>(
                    //           context: context,
                    //           shape: RoundedRectangleBorder(
                    //             borderRadius: BorderRadius.only(
                    //               topLeft: Radius.circular(20.0),
                    //               topRight: Radius.circular(20.0),
                    //             ),
                    //           ),
                    //           isDismissible: true,
                    //           backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    //           builder: (context) {
                    //             return ShareFriendView(
                    //               shareType: ChatMessageType.skib,
                    //               contentId: widget.skibblePost.postId,
                    //               // conversationFriendId: skibblePost.postAuthorId,
                    //             );
                    //           });
                    //     },
                    //     child: Column(
                    //       children: [
                    //         CircleAvatar(
                    //           child: Icon(
                    //             FontAwesome.facebook, size: 24,
                    //             color: kLightSecondaryColor,
                    //
                    //             // color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    //           ),
                    //           backgroundColor: Color(0xFF1877F2),
                    //           radius: 24,
                    //
                    //         ),
                    //         SizedBox(height: 12,),
                    //         Text('Facebook', style: TextStyle(fontSize: 15))
                    //       ],
                    //     ),
                    //   ),
                    // ),


                  ],
                ),
              ),

            ],
          )
        // Center(
        //   child: CircularProgressIndicator(strokeWidth: 2,)),
      ),
    );
  }


  static void showFullScreenImage(BuildContext context, ImageProvider imageProvider) => showModalBottomSheet(
    context: context,
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(20.0),
    //     topRight: Radius.circular(20.0),
    //   ),
    // ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: false,
    shape: const ContinuousRectangleBorder(),
    builder: (BuildContext context) {
      return
        // CustomPhotoViewer(imageProviders: [imageProvider]);

        Container(
          // height: 250,
          child: PhotoViewGestureDetectorScope(
            axis: Axis.vertical,
            child: PhotoView(
              tightMode: true,
              imageProvider: imageProvider,
              heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
            ),
          ),
        );
    },
  );

}