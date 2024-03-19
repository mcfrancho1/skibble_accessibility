import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/controllers/skib_data_controller.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
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
import '../../../services/firebase/database/recipe_database.dart';
import '../../../shared/bottom_sheet_dialogs.dart';
import '../../../shared/custom_image_widget.dart';
import '../../../shared/custom_video_player.dart';
import '../../../utils/camera_views/camera_screen.dart';
import '../../../utils/constants.dart';
import '../../../utils/current_theme.dart';
import '../../../utils/custom_pickers/custom_pickers.dart';

class EditSkibView extends StatefulWidget {
  const EditSkibView({Key? key}) : super(key: key);

  @override
  State<EditSkibView> createState() => _EditSkibViewState();
}

class _EditSkibViewState extends State<EditSkibView> {

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

                const SizedBox(height: 30,),
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
                          'Edit Skib',
                          style: TextStyle(
                              color: kDarkSecondaryColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),

                        )
                    ),

                    TextButton(
                        onPressed: () async{
                          CustomDialog(context).showProgressDialog(context, 'Updating skib...');
                          var res = await data.updateSkibblePost(currentUser, context);

                          Navigator.pop(context);
                          if(res != null) {
                            CustomBottomSheetDialog.showSuccessSheet(context, 'Your skib was updated successfully!', onButtonPressed: () {
                              Navigator.pop(context);
                              data.clearSkibMediaFiles();
                              if(Navigator.canPop(context))
                                Navigator.pop(context);
                            });
                          }

                        },
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                        child: Text(
                          'Update',
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
                                return SizedBox(
                                  height: 300,
                                  child: Swiper(
                                    loop: false,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Stack(
                                        children:  [
                                          skibMediaFiles[index].fileType == SkibbleFileType.image ?
                                          Container(
                                              height: 300,
                                              width: size.width,
                                              child: Container(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15),
                                                    child:
                                                    CustomNetworkImageWidget(
                                                      imageUrl: skibMediaFiles[index].mediaUrl!,
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
                                              videoUrl: skibMediaFiles[index].mediaUrl,
                                              image: skibMediaFiles[index].videoThumbnailUrl,
                                              isNetworkImage: true
                                          ),
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
                                      hintText: 'Where did this yummy experience happen?'
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
                                          hintText: 'Add some yummy food tags'
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
                                                    color: kBackgroundColorDarkTheme.withOpacity(0.8),
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
                          //attach a recipe

                          data.createSkibRecipe == null ? TextButton(
                            onPressed: () async{
                              var attachedRecipe = await Navigator.of(context).push<Recipe?>(MaterialPageRoute(builder: (context) => const UserRecipeSelectionView()));

                              if(attachedRecipe != null) {
                                data.setCreateRecipe = attachedRecipe;
                              }
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 0)
                            ),
                            child: const Row(
                              children: [
                                Icon(Iconsax.document, color: kPrimaryColor,),
                                SizedBox(width: 10,),
                                Text('Attach a recipe'),
                              ],
                            ),
                          )
                              :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 20,),

                                  const Text('Recipe', style: TextStyle(fontSize: 16, color: kDarkSecondaryColor,),),
                                  Row(
                                    // mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(
                                        child: Card(
                                          margin: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                                          // color: kLightSecondaryColor,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical:  10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              data.createSkibRecipe!.recipeImageUrl!
                                                          ),
                                                          fit: BoxFit.cover
                                                      )
                                                  ),
                                                ),
                                                const SizedBox(width: 10,),
                                                Expanded(
                                                  child: Text(
                                                    data.createSkibRecipe!.title,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 17, color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      IconButton(
                                          onPressed: () => data.setCreateRecipe = null,
                                          splashRadius: 20,
                                          icon: const Icon(Iconsax.trash))
                                    ],
                                  ),
                                ],
                              )
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
