import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/controllers/skib_data_controller.dart';
import 'package:skibble/features/skibs/post_views/rate_accessibility.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import 'package:skibble/shared/custom_file_picker/lib/drishya_picker.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/skibs/post_views/user_recipe_selection_view.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../../controllers/file_controller.dart';
import '../../../controllers/skib_controller.dart';
import '../../../models/recipe.dart';
import '../../../models/skibble_file.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/change_data_notifiers/picker_data/location_picker_data.dart';
import '../../../shared/bottom_sheet_dialogs.dart';
import '../../../shared/custom_image_widget.dart';
import '../../../shared/custom_video_player.dart';
import '../../../utils/camera_views/camera_screen.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/custom_pickers/custom_pickers.dart';
import '../../../utils/rating_utils.dart';

class CreateSkibView extends StatefulWidget {
  const CreateSkibView({Key? key}) : super(key: key);

  @override
  State<CreateSkibView> createState() => _CreateSkibViewState();
}

class _CreateSkibViewState extends State<CreateSkibView> {

  // The reference to the navigator
  late NavigatorState _navigator;

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SkibController>().initCreateSkib(context);

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _navigator.context.read<SkibController>().disposeCreateSkibControllers();
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Consumer<SkibController>(
      builder: (context, data, child) {
        var skibMediaFiles = data.currentSkibMediaFiles;
        return Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const SizedBox(height: 50,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    onPressed: () {
                      data.cancelSkibEditOrCreate(_navigator.context);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                    icon: const Icon(Icons.close_rounded),
                  ),

                  const Center(
                      child: Text(
                        'Create Skib',
                        style: TextStyle(
                          color: kDarkSecondaryColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold
                        ),

                      )
                  ),

                  TextButton(
                    onPressed: () async{
                      if(data.currentSkibMediaFiles.isNotEmpty) {
                        CustomDialog(context).showProgressDialog(context, 'Creating skib...', isDissimissible: false);
                        var res = await data.createNewSkib(_navigator.context, currentUser);

                        Navigator.pop(context);
                        if(res != null) {
                          CustomBottomSheetDialog.showSuccessSheet(context, 'Your skib was uploaded successfully!', onButtonPressed: () {
                            Navigator.pop(context);
                            data.clearSkibMediaFiles();
                            if(Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          });
                        }

                      }
                    },
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: skibMediaFiles.isEmpty ? Colors.grey : kPrimaryColor,
                      ),
                    )
                  ),
                ],
              ),

              const SizedBox(height: 20,),

             Expanded(
               child: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                   child: Column(
                     mainAxisSize: MainAxisSize.min,

                     children: [

                       Consumer<LoadingController>(
                         builder: (context, loading, child) {
                           return skibMediaFiles.isNotEmpty ?
                           loading.isLoading ?
                           SizedBox(
                             height: 300,
                             child: DottedBorder(
                               borderType: BorderType.RRect,
                               radius: const Radius.circular(20),
                               dashPattern : const <double>[5, 4],
                               color: Colors.grey,
                               child: const Column(
                                 mainAxisAlignment: MainAxisAlignment.center,

                                 children: [
                                   Text('Verifying contents...', style: TextStyle(color: Colors.grey),),
                                   SizedBox(height: 5,),
                                   LoadingFallingDot(size: 30, color: kDarkSecondaryColor,),
                                 ],
                               ),
                             ),
                           )
                               :
                           SizedBox(
                             height: 300,
                             child: Swiper(
                               loop: false,

                               itemBuilder: (BuildContext context, int index) {
                                 return Stack(
                                   children:  [
                                     skibMediaFiles[index].isContentSafetyVerified ?
                                     skibMediaFiles[index].fileType == SkibbleFileType.image ?
                                     SizedBox(
                                         height: 300,
                                         width: size.width,
                                         child: Container(
                                             child: ClipRRect(
                                               borderRadius: BorderRadius.circular(15),
                                               child:
                                               CustomFileImageWidget(
                                                 imageFile: skibMediaFiles[index].file!,
                                                 isCircleShaped: false,
                                               ),
                                             )
                                           // decoration: BoxDecoration(
                                           //   // color: Colors.red,
                                           //
                                           // ),
                                         )

                                     )
                                         :
                                     CustomVideoMultiPlayerList(
                                       videoUrl: skibMediaFiles[index].file?.path,
                                       image: skibMediaFiles[index].videoThumbnailFile?.path,
                                       isNetworkImage: false
                                      )
                                         :
                                     //unsafe content message
                                     Container(
                                       height: 300,
                                       width: double.infinity,
                                       margin: const EdgeInsets.only(bottom: 5),
                                       decoration: BoxDecoration(
                                         color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : Colors.grey.shade300,
                                         borderRadius: BorderRadius.circular(10),
                                       ),
                                       child:
                                       const Column(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           Icon(Icons.info_outline_rounded, color: kErrorColor,),
                                           SizedBox(height: 5,),
                                           Text(
                                             'Your content was found to be sensitive',
                                             style: TextStyle(color: Colors.grey),
                                           )
                                         ],
                                       ),

                                     ),

                                     skibMediaFiles[index].fileType == SkibbleFileType.image ?
                                     Positioned(
                                       top: 8,
                                       left: 10,
                                       right: 10,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           GestureDetector(
                                             onTap: () async{
                                               await data.selectSkibFilesFromGallery(context);
                                             },
                                             child: Container(
                                                 padding: const EdgeInsets.all(8),
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(8),
                                                     color: Colors.black.withOpacity(0.5)
                                                 ),
                                                 child: Text(
                                                   skibMediaFiles[index].isContentSafetyVerified  ? 'Add more' : 'Change',
                                                   style: const TextStyle(color: kLightSecondaryColor),
                                                 )
                                             ),
                                           ),

                                           Row(
                                             children: [

                                                 if(skibMediaFiles[index].isContentSafetyVerified)
                                                   Container(
                                                       decoration: BoxDecoration(
                                                           borderRadius: BorderRadius.circular(8),
                                                           color: Colors.black.withOpacity(0.5)

                                                       ),
                                                       child: IconButton(
                                                           onPressed: ()async{
                                                             await data.editImage(index);
                                                           },
                                                           icon: const Icon(CupertinoIcons.sparkles, color: kLightSecondaryColor,)
                                                       )
                                                   ),

                                               const SizedBox(width: 10,),
                                               Container(
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(8),
                                                       color: Colors.black.withOpacity(0.5)
                                                   ),
                                                   child: IconButton(
                                                       onPressed: (){
                                                         data.removeSkibMediaFileAtIndex(index);
                                                       },
                                                       icon: const Icon(
                                                         Iconsax.trash,
                                                         color: kLightSecondaryColor,
                                                       )
                                                   )
                                               )
                                             ],
                                           )

                                         ],
                                       ),
                                     )
                                         :
                                     Positioned(
                                       top: 8,
                                       left: 10,
                                       right: 70,
                                       child: Row(
                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                         children: [
                                           GestureDetector(
                                             onTap: () async{
                                               await data.selectSkibFilesFromGallery(context);
                                             },
                                             child: Container(
                                                 padding: const EdgeInsets.all(8),
                                                 decoration: BoxDecoration(
                                                     borderRadius: BorderRadius.circular(8),
                                                     color: Colors.black.withOpacity(0.5)
                                                 ),
                                                 child: Text(
                                                   skibMediaFiles[index].isContentSafetyVerified  ? 'Add more' : 'Change',
                                                   style: const TextStyle(color: kLightSecondaryColor),
                                                 )
                                             ),
                                           ),

                                           Row(
                                             children: [

                                               Container(
                                                   decoration: BoxDecoration(
                                                       borderRadius: BorderRadius.circular(8),
                                                       color: Colors.black.withOpacity(0.5)
                                                   ),
                                                   child: IconButton(
                                                       onPressed: (){
                                                         data.removeSkibMediaFileAtIndex(index);
                                                       },
                                                       icon: const Icon(
                                                         Iconsax.trash,
                                                         color: kLightSecondaryColor,
                                                       )
                                                   )
                                               ),
                                               const SizedBox(width: 10,),

                                               Opacity(

                                                 opacity: 1,
                                                 child: Container(
                                                     decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(8),
                                                         color: Colors.black.withOpacity(0.5)

                                                     ),
                                                     child: IconButton(
                                                         onPressed: ()async {
                                                           await data.editVideo(index);

                                                         },
                                                         icon: const Icon(CupertinoIcons.sparkles, color: kLightSecondaryColor,)
                                                     )
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ],
                                       ),
                                     )
                                   ],
                                 );
                               },
                               itemCount: skibMediaFiles.length,
                               viewportFraction: 1.0,
                               scale: 0.9,
                               outer: true,
                               // layout: SwiperLayout.STACK,
                               pagination: SwiperPagination(
                                   margin: new EdgeInsets.only(top: 10),
                                   builder: DotSwiperPaginationBuilder(
                                       activeColor: kPrimaryColor,
                                       color: Colors.grey.shade400,
                                       activeSize: 8,
                                       size: 4
                                   )
                               ),
                             ),
                           )
                               :
                           SizedBox(
                             height: 300,
                             child: DottedBorder(
                               borderType: BorderType.RRect,
                               radius: const Radius.circular(20),
                               dashPattern : const <double>[5, 4],
                               color: Colors.grey,
                               child: loading.isLoading ?
                               const Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Text('Verifying contents...', style: TextStyle(color: Colors.grey),),
                                   SizedBox(height: 5,),
                                   LoadingFallingDot(size: 30, color: kDarkSecondaryColor,),
                                 ],
                               )
                                   :
                               Column(
                                 children: [
                                   Container(
                                     height: 210,
                                     decoration: const BoxDecoration(
                                         image: DecorationImage(
                                             image: AssetImage('assets/images/food_bg.png'),
                                           fit: BoxFit.cover
                                         )
                                     ),
                                   ),

                                   const SizedBox(height: 8,),
                                   const Text(
                                       'Share those delicious food experiences!',
                                     style: TextStyle(color: Colors.blueGrey),
                                   ),
                                   const SizedBox(height: 4,),

                                   Center(
                                     child: ElevatedButton(
                                       onPressed: ()async{
                                         await CustomBottomSheetDialog.showMediaSelectionDialog(
                                             context,
                                             onCameraSelected: () async {
                                               await data.selectSkibFilesFromCamera(context, );
                                             },
                                             onGallerySelected: () async{
                                               await data.selectSkibFilesFromGallery(context);
                                             }
                                         );
                                         // await showModalBottomSheet<bool>(
                                         //     context: context,
                                         //     shape: RoundedRectangleBorder(
                                         //       borderRadius: BorderRadius.only(
                                         //         topLeft: Radius.circular(20.0),
                                         //         topRight: Radius.circular(20.0),
                                         //       ),
                                         //     ),
                                         //     isDismissible: true,
                                         //     backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                                         //     builder: (new_context) {
                                         //       return SafeArea(
                                         //           child: Column(
                                         //             mainAxisSize: MainAxisSize.min,
                                         //             children: [
                                         //
                                         //               Container(
                                         //                 width: 90,
                                         //                 margin: EdgeInsets.only(top: 8),
                                         //                 height: 5,
                                         //                 decoration: BoxDecoration(
                                         //                     borderRadius: BorderRadius.circular(10),
                                         //                     color: Colors.grey.shade300
                                         //                 ),
                                         //               ),
                                         //
                                         //               Padding(
                                         //                 padding: const EdgeInsets.only(top: 15.0, bottom: 5),
                                         //                 child: Text('Media',
                                         //                   style: TextStyle(
                                         //                       color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                         //                       fontSize: 16,
                                         //                       fontWeight: FontWeight.bold
                                         //                   ),
                                         //                 ),
                                         //               ),
                                         //               ListView(
                                         //                   shrinkWrap: true,
                                         //                   // mainAxisSize: MainAxisSize.min,
                                         //                   // crossAxisAlignment: CrossAxisAlignment.start,
                                         //                   // separatorBuilder: (BuildContext context, int index) {  },
                                         //                   // itemCount: 5,
                                         //                   // itemBuilder: (BuildContext context, int index) {  },
                                         //                   children: ListTile.divideTiles(
                                         //                       context: context,
                                         //                       tiles: [
                                         //                         ListTile(
                                         //                           contentPadding:  EdgeInsets.only(top: 20.0, left: 20.0, right: 20, bottom: 5),
                                         //                           leading: Icon(
                                         //                             Iconsax.camera,
                                         //                             color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                         //                           ),
                                         //                           title: Transform.translate(
                                         //                               offset: Offset(-16, 0),
                                         //                               child: Text('Camera')),
                                         //                           onTap: () async{
                                         //                             Navigator.pop(new_context);
                                         //                             Navigator.of(new_context).push(MaterialPageRoute(builder: (context) => CustomCameraScreen())
                                         //                             );
                                         //                             // var res = await FilesHandler().createSkib(context, _navigator);
                                         //                           },
                                         //                         ),
                                         //                         ListTile(
                                         //                           contentPadding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                                         //                           leading: Icon(Iconsax.gallery,
                                         //                             color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                         //                           ),
                                         //                           title: Transform.translate(
                                         //                               offset: Offset(-16, 0),
                                         //
                                         //                               child: Text('Gallery')),
                                         //                           onTap: () async{
                                         //
                                         //                             Navigator.pop(new_context);
                                         //                             // await FilesHandler().callPicker(new_context);
                                         //                             await data.selectSkibFilesFromGallery(context);
                                         //                             // await FilePickerController().openPhotoEditorMulti();
                                         //                             // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                         //                             //     ImageFilePickerView(
                                         //                             //       fileType: FileType.image,
                                         //                             //       skibbleFriend: skibbleFriend,
                                         //                             //       conversationId: conversationId,
                                         //                             //       swipedMessage: swipedMessage,
                                         //                             //       onCancelReply: onCancelReply,
                                         //                             //     )
                                         //                             // )
                                         //                             // );
                                         //                           },
                                         //                         ),
                                         //
                                         //                       ]).toList()
                                         //               )
                                         //             ],
                                         //           )
                                         //       );
                                         //     });

                                       },
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: kContentColorLightTheme,
                                           elevation: 0,
                                           foregroundColor: kPrimaryColor,
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(10),
                                             side: const BorderSide(color: kPrimaryColor)
                                           )
                                         ),
                                         child: const Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Text('Upload'),
                                             SizedBox(width: 8,),
                                             Icon(Iconsax.attach_circle)
                                           ],
                                         )
                                     ),
                                   )
                                 ],
                               ),
                             ),
                           );
                         }
                       ),


                       TextField(
                         maxLines: null,
                         minLines: null,
                         controller: data.captionController,
                         // expands: true,
                         decoration: const InputDecoration(
                             border: InputBorder.none,
                             hintText: 'Add caption here...'
                         ),
                       ),
                       const Divider(),
                       const SizedBox(height: 5,),


                       //address
                       Consumer<LocationPickerData>(
                         builder: (context, location, child) {
                           Address? address;

                           if(location.pickedLocation != null) {
                             address =  location.pickedLocation;
                             WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                               data.setLocation(context, false, address: address);
                             });
                           }


                           return TextField(
                             maxLines: 1,
                             minLines: null,
                             controller: data.addressController!,
                             // expands: true,
                             readOnly: true,
                             onTap: () {
                               CustomPickers().showLocationPickerSheet(context);

                             },
                             decoration: const InputDecoration(
                                 border: InputBorder.none,
                                 hintText: 'Add a location',
                               suffixIcon: Icon(Icons.arrow_forward_ios_rounded,size: 18,)
                             ),
                           );
                         }
                       ),

                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 0.0),
                         child: Align(
                           alignment: Alignment.topLeft,
                           child: Wrap(
                               crossAxisAlignment: WrapCrossAlignment.start,
                               alignment: WrapAlignment.start,
                               spacing: 10,
                               runSpacing: 5,
                               children: List.generate(data.customLocation.length, (index) => GestureDetector(
                                 onTap: () async{

                                   if(data.selectedCustomLocation != data.customLocation[index]) {
                                     // addressController.text = '';
                                     // locationAddress = null;
                                     // selectedCustomLocation = customLocation[index];

                                     await data.setLocation(context, false, index: index);
                                   }
                                   else {
                                     await data.setLocation(context, true, index: index);

                                   }
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                                   // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(20),
                                       color: data.selectedCustomLocation == data.customLocation[index] ? kPrimaryColor : null,
                                       border: data.selectedCustomLocation == data.customLocation[index] ? null : Border.all(color:  CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor)
                                   ),
                                   child: Text(data.customLocation[index], style: TextStyle(color: data.selectedCustomLocation == data.customLocation[index] ? kLightSecondaryColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
                                 ),
                               ))
                           ),
                         ),
                       ),

                       const SizedBox(height: 15,),

                       const Divider(),

                       //food tags
                       Consumer<FoodOptionsPickerData>(
                           builder: (context, foodData, child) {

                             return Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 TextField(
                                   maxLines: 1,
                                   minLines: null,
                                   // expands: true,
                                   readOnly: true,
                                   onTap: () {
                                     CustomPickers().showFoodOptionsPickerSheet(context);

                                   },
                                   decoration: const InputDecoration(
                                       border: InputBorder.none,
                                       hintText: 'Add some yummy food tags',
                                       suffixIcon: Icon(Icons.arrow_forward_ios_rounded,size: 18,)

                                   ),
                                 ),

                                 const SizedBox(height: 2,),

                                 foodData.userChoices.isEmpty ?
                                 const Padding(
                                   padding: EdgeInsets.symmetric(horizontal: 0.0),
                                   child: Text('No tags selected',  style: TextStyle(fontStyle: FontStyle.italic)),)
                                     :
                                 SizedBox(
                                   height: 25,
                                   child: ListView.builder(
                                     itemCount: foodData.userChoices.length,
                                     scrollDirection: Axis.horizontal,
                                     shrinkWrap: true,
                                     itemBuilder: (context, index) =>
                                         Container(
                                           padding: const EdgeInsets.symmetric(horizontal: 8,),
                                           margin: const EdgeInsets.only(right: 10),
                                           decoration: BoxDecoration(
                                               color: kPrimaryColor,
                                               borderRadius: BorderRadius.circular(20),
                                               border:  Border.all(width: 0)
                                           ),
                                           child: Row(
                                             crossAxisAlignment: CrossAxisAlignment.center,
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             textBaseline: TextBaseline.alphabetic,
                                             children: [
                                               Text(
                                                 foodData.userChoices[index].capitalizeFirst!,
                                                 style: TextStyle(
                                                     color: foodData.userChoices.contains(foodData.userChoices[index].capitalizeFirst!) ? kLightSecondaryColor : Colors.blueGrey,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 13
                                                 ),
                                               ),

                                               const SizedBox(width: 3,),
                                               GestureDetector(
                                                   onTap: () => foodData.removeFromUserChoiceAtIndex(index),
                                                   child: const Icon(Icons.clear_rounded, size: 16, color: kContentColorLightTheme,))
                                             ],
                                           ),
                                         )
                                   ),
                                 )

                               ],
                             );
                           }
                       ),

                       const SizedBox(height: 15,),

                       const Divider(),


                       ///accessibility rating
                       Consumer<FoodOptionsPickerData>(
                           builder: (context, foodData, child) {

                             return Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 TextField(
                                   maxLines: 1,
                                   minLines: null,
                                   // expands: true,
                                   readOnly: true,
                                   onTap: () {
                                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => RateAccessibilityView()));

                                   },
                                   decoration: const InputDecoration(
                                       border: InputBorder.none,
                                       hintText: 'Rate accessibility',
                                       suffixIcon: Icon(Icons.arrow_forward_ios_rounded,size: 18,)

                                   ),
                                 ),

                                 const SizedBox(height: 2,),

                                 Row(
                                   children: [
                                     RatingBarIndicator(
                                       rating: 4,
                                       itemBuilder: (context, index) =>
                                       // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                       Padding(
                                         padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                         child: Container(
                                           // height: 0,
                                           // width: 20,
                                           decoration: BoxDecoration(
                                               color: RatingUtils.generateRatingColor(index),
                                               // borderRadius: BorderRadius.circular(8),
                                               shape: BoxShape.circle
                                           ),
                                           child: const Padding(
                                             padding: EdgeInsets.all(4.0),
                                             child: Icon(
                                               Icons.star_rounded,
                                               size: 15,
                                               color: kLightSecondaryColor,),
                                           ),
                                         ),
                                       ),
                                       itemCount: 5,
                                       unratedColor: Colors.grey.shade300,
                                       itemSize: 18.0,
                                       direction: Axis.horizontal,
                                     ),
                                     
                                     Text(' (4.0)')
                                   ],
                                 ),

                               ],
                             );
                           }
                       ),

                       const SizedBox(height: 15,),

                       const Divider(),


                       ///attach a recipe
                       //
                       // data.createSkibRecipe == null ? TextButton(
                       //   onPressed: () async{
                       //     var attachedRecipe = await Navigator.of(context).push<Recipe?>(MaterialPageRoute(builder: (context) => const UserRecipeSelectionView()));
                       //
                       //     if(attachedRecipe != null) {
                       //       data.setCreateRecipe = attachedRecipe;
                       //     }
                       //   },
                       //   style: TextButton.styleFrom(
                       //     padding: const EdgeInsets.symmetric(horizontal: 0)
                       //   ),
                       //   child: const Row(
                       //     children: [
                       //       Icon(Iconsax.document, color: kPrimaryColor,),
                       //       SizedBox(width: 10,),
                       //       Text('Attach a recipe'),
                       //     ],
                       //   ),
                       // )
                       //     :
                       // Row(
                       //   // mainAxisSize: MainAxisSize.min,
                       //   children: [
                       //     Expanded(
                       //       child: Card(
                       //         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                       //         // color: kLightSecondaryColor,
                       //         elevation: 3,
                       //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                       //         child: Container(
                       //           padding: const EdgeInsets.symmetric(horizontal: 10, vertical:  10),
                       //           child: Row(
                       //             children: [
                       //               Container(
                       //                 height: 50,
                       //                 width: 50,
                       //                 decoration: BoxDecoration(
                       //                     borderRadius: BorderRadius.circular(10),
                       //                     image: DecorationImage(
                       //                         image: CachedNetworkImageProvider(
                       //                             data.createSkibRecipe!.recipeImageUrl!
                       //                         ),
                       //                         fit: BoxFit.cover
                       //                     )
                       //                 ),
                       //               ),
                       //               const SizedBox(width: 10,),
                       //               Expanded(
                       //                 child: Text(
                       //                   data.createSkibRecipe!.title,
                       //                   maxLines: 1,
                       //                   overflow: TextOverflow.ellipsis,
                       //                   style: TextStyle(fontSize: 17, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
                       //               ),
                       //             ],
                       //           ),
                       //         ),
                       //       ),
                       //     ),
                       //
                       //     IconButton(
                       //         onPressed: () => data.createSkibRecipe = null,
                       //         splashRadius: 20,
                       //         icon: const Icon(Iconsax.trash))
                       //   ],
                       // ),
                     ],
                   ),
                 ),
               ),
             )
            ],
          ),
        );
      }
    );
  }
}
