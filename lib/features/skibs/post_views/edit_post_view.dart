import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/skib_controller.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/skibble_post.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import 'package:skibble/services/maps_services/map_requests.dart';
import 'package:skibble/services/typesense_search.dart';
import 'package:skibble/shared/type_ahead_field.dart';
import 'package:skibble/features/skibs/post_views/user_recipe_selection_view.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/custom_pickers/custom_pickers.dart';
import 'package:uuid/uuid.dart';

import '../../../custom_icons/chef_icons_icons.dart';
import '../../../models/recipe.dart';
import '../../../models/skib_entity.dart';
import '../../../models/suggestion.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../shared/custom_file_picker/lib/drishya_picker.dart';
import '../../../shared/custom_file_picker/lib/src/gallery/src/widgets/entity_thumbnail.dart';
import '../../../shared/dialogs.dart';
import '../../../utils/helper_methods.dart';

class EditPostView extends StatefulWidget {
  const EditPostView({Key? key, required this.skibEntities}) : super(key: key);

  final List<SkibEntity> skibEntities;

  @override
  State<EditPostView> createState() => _EditPostViewState();
}


class _EditPostViewState extends State<EditPostView> {

  Future? fileFutures;

  Address? locationAddress;

  TextEditingController addressController = TextEditingController();
  TextEditingController captionController = TextEditingController();
  TextEditingController recipeController = TextEditingController();

  List<String> foodTags = [];

  late SkibblePost post;

  late Future processEntitiesFuture;
  late Future uploadFilesFuture;
  late CancelableCompleter completer;

  CancelableCompleter<T> wrapInCompleter<T>(Future<T> future) {
    final completer = CancelableCompleter<T>();
    future.then(completer.complete).catchError(completer.completeError);
    return completer;
  }

  @override
  void initState() {
    // TODO: implement initState
    var user = Provider.of<AppData>(context, listen: false).skibbleUser!;

    //process data in the background
    post = SkibblePost(
        caption: captionController.text,
        postAddress: locationAddress,
        postAuthorId: user.userId!,
        // creat: user,
        creatorUser: user,
        customLocation: selectedCustomLocation,
        attachedRecipeId: recipe != null ? recipe!.recipeId! : null,
        // recipeList: recipeController.text,
        postTags: foodTags,
        likesDocMap: {},
        likesDocMapCount: {'likes_1': 0}
      // skibblePostType: skibblePostType
    );

    processEntitiesFuture = context.read<SkibController>().processEntitiesToFiles(post, widget.skibEntities);
    completer = wrapInCompleter(processEntitiesFuture);
    // uploadFilesFuture
    // fileFutures =  processEntities();
    super.initState();
  }


  final String _session = Uuid().v4();

  Recipe? recipe;

  String? selectedCustomLocation;

  final List<String> customLocation = ['My Kitchen', 'School', 'Work'];

  @override
  void dispose() {
    // TODO: implement dispose
    addressController.dispose();
    captionController.dispose();
    recipeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AppData>(context).skibbleUser!;
    return WillPopScope(
      onWillPop: () async{

        for(var skibEntity in widget.skibEntities) {
          if(skibEntity.isRecentlyCreated) {
            // final List<String> result =
            if(skibEntity.file!.existsSync()) {
              skibEntity.file!.deleteSync();
            }
          }
        }
        //TODO: check if the files were uploaded and delete from storage
        await completer.operation.cancel();
        return true;
      },
      child: GestureDetector(
        onTap: () => HelperMethods().dismissKeyboard(context),

        child: Scaffold(
          appBar: AppBar(
            leading: TextButton(
                onPressed: () async {
                  for(var skibEntity in widget.skibEntities) {
                    if(skibEntity.isRecentlyCreated) {
                      // final List<String> result =
                      if(skibEntity.file!.existsSync()) {
                        skibEntity.file!.deleteSync();
                      }
                    }
                  }
                  // for(var skibEntity in widget.skibEntities) {
                  //   if(skibEntity.isRecentlyCreated && Platform.isAndroid) {
                  //     // final List<String> result =
                  //     await PhotoManager.editor.deleteWithIds(
                  //       <String>[skibEntity.assetEntity.id],
                  //     );
                  //   }
                  // }

                  //TODO: check if the files were uploaded and delete from storage
                  await completer.operation.cancel();
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: TextStyle(fontSize: 16, color: kErrorColor),)
            ),
            centerTitle: true,
            leadingWidth: 70,
            title: Text('Edit Skib', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
            actions: [
              TextButton(
                  onPressed: () async{
                    //

                    if(completer.isCompleted) {
                      Map<String, dynamic> map = await completer.operation.value;

                      post = map['post'];

                      post.caption= captionController.text;
                      post.postAddress = locationAddress;
                      post.postAuthorId = user.userId!;
                      post.creatorUser = user;
                      post.customLocation = selectedCustomLocation;
                      post.attachedRecipeId = recipe != null ? recipe!.recipeId! : null;
                      // recipeList: recipeController.text,
                      post.postTags = foodTags;
                      post.likesList = {};
                      post.likesDocMap = {};
                      post.likesDocMapCount = {'likes_1': 0};

                      await context.read<SkibController>().postContent(post, map, context, user);

                    }
                    else {
                      // show dialog
                      CustomDialog(context).showProgressDialog(context, 'Adding final touches...');
                      await completer.operation.value.whenComplete(() async{
                        Map<String, dynamic> map = await completer.operation.value;

                        post = map['post'];

                        post.caption= captionController.text;
                        post.postAddress = locationAddress;
                        post.postAuthorId = user.userId!;
                        post.creatorUser = user;
                        post.customLocation = selectedCustomLocation;
                        post.attachedRecipeId = recipe != null ? recipe!.recipeId! : null;
                        // recipeList: recipeController.text,
                        post.postTags = foodTags;
                        post.likesDocMap = {};
                        post.likesList = {};
                        post.likesDocMapCount = {'likes_1': 0};


                        await context.read<SkibController>().postContent(post, map, context, user);
                        // await PostController().postContentWithEntities(post, widget.skibEntities, context, user);

                      });

                    }
                  },
                  child: Text('Post', style: TextStyle(fontSize: 16))
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        ContentFutureDisplay(skibEntities: widget.skibEntities),

                        SizedBox(width: 15,),
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            minLines: null,
                            controller: captionController,
                            // expands: true,
                            decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add caption here...'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Divider(),

                  //address
                  CustomTypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: addressController,
                      enabled: selectedCustomLocation == null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Iconsax.location),
                          hintText: 'Add a location(Optional)'
                      ),
                    ),
                    containerDecoration: BoxDecoration(),
                    containerMargin: EdgeInsets.zero,
                    onSuggestionSelected: (Suggestion suggestion) async{
                      setState(() {
                        addressController.text = suggestion.title + ", " + suggestion.subTitle!;
                        locationAddress = new Address(googlePlaceId: suggestion.id, placeName: suggestion.title, formattedAddress: suggestion.subTitle );

                      });
                    },
                    suggestionCallback: (pattern) async {

                      return GoogleMapsService().getPlaceSuggestions(pattern, _session);
                    },
                  ),

                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        alignment: WrapAlignment.start,
                        spacing: 10,
                        runSpacing: 5,
                        children: List.generate(customLocation.length, (index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              if(selectedCustomLocation != customLocation[index]) {
                                addressController.text = '';
                                locationAddress = null;
                                selectedCustomLocation = customLocation[index];
                              }
                              else {
                                selectedCustomLocation = null;
                              }

                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                            // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selectedCustomLocation == customLocation[index] ? kPrimaryColor : null,
                                border: selectedCustomLocation == customLocation[index] ? null : Border.all(color:  CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor)
                            ),
                            child: Text(customLocation[index], style: TextStyle(color: selectedCustomLocation == customLocation[index] ? kLightSecondaryColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
                          ),
                        ))
                      ),
                    ),
                  ),


                  Divider(),


                  FoodTagsView(onListChanged: (value) => foodTags = value),
                  SizedBox(height: 10,),

                  Divider(),

                  //attach a recipe

                  recipe == null ? TextButton(
                    onPressed: () async{
                      var attachedRecipe = await Navigator.of(context).push<Recipe?>(MaterialPageRoute(builder: (context) => UserRecipeSelectionView()));

                      if(attachedRecipe != null) {
                        setState(() => recipe = attachedRecipe);
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Iconsax.document, color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text('Attach a recipe'),
                      ],
                    ),
                  )
                      :
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          // color: kLightSecondaryColor,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical:  10),
                            child: Row(
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              recipe!.recipeImageUrl!
                                          ),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    recipe!.title,
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
                        onPressed: () => setState(() => recipe = null),
                        splashRadius: 20,
                        icon: Icon(Iconsax.trash))
                    ],
                  ),

                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentFutureDisplay extends StatelessWidget {
  const ContentFutureDisplay({Key? key, required this.skibEntities}) : super(key: key);
  final List<SkibEntity> skibEntities;
  @override
  Widget build(BuildContext context) {
    return skibEntities.last.fileType == AssetType.image ? Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: FileImage(
                  skibEntities.last.file!
              ),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.black54,
          child:Text('${skibEntities.length}'),
        ),
      ),
    )
        :
    Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: MediaThumbnailProvider(entity: skibEntities.last.assetEntity!.toSkibble),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.black54,
          child: Text('${skibEntities.length}'),
        ),
      ),
    );

    //   FutureBuilder<File?>(
    //     future: skibEntities.last.file,
    //     builder: (context, snapshot) {
    //       if(snapshot.connectionState == ConnectionState.waiting) {
    //         return Container(
    //           height: 80,
    //           width: 80,
    //         );
    //       }
    //       else if(snapshot.connectionState == ConnectionState.done) {
    //         var file = snapshot.data as File;
    //         return skibEntities.last.assetEntity.type == AssetType.image ? Container(
    //           height: 80,
    //           width: 80,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               image: DecorationImage(
    //                   image: FileImage(
    //                       file
    //                   ),
    //                   fit: BoxFit.cover
    //               )
    //           ),
    //           child: Center(
    //             child: CircleAvatar(
    //               radius: 12,
    //               backgroundColor: Colors.black26,
    //               child: CircleAvatar(
    //                 radius: 10,
    //
    //                 child: Text('${skibEntities.length}'),
    //               ),
    //             ),
    //           ),
    //         )
    //             :
    //         Container(
    //           height: 80,
    //           width: 80,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               image: DecorationImage(
    //                   image: MediaThumbnailProvider(entity: skibEntities.last.assetEntity.toSkibble),
    //                   fit: BoxFit.cover
    //               )
    //           ),
    //           child: Center(
    //             child: CircleAvatar(
    //               radius: 12,
    //               backgroundColor: Colors.black26,
    //               child: CircleAvatar(
    //                 radius: 10,
    //                 child: Text('${skibEntities.length}'),
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       else {
    //         return Container();
    //       }
    //     }
    // );
  }
}


class FoodTagsView extends StatefulWidget {
  const FoodTagsView({Key? key, required this.onListChanged, this.initialFoodTag}) : super(key: key);
  final Function(List<String> value) onListChanged;
  final List<String>? initialFoodTag;

  @override
  State<FoodTagsView> createState() => _FoodTagsViewState();
}

class _FoodTagsViewState extends State<FoodTagsView> {
  

  @override
  void initState() {
    // TODO: implement initState
  
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey, width: 0.6)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //food tags

          TextField(
            readOnly: true,
            onTap: () {
              CustomPickers().showFoodOptionsPickerSheet(context);
            },
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(ChefIcons.chef_and_spoon),
                hintText: 'Include custom food tags (Optional)'
            ),
          ),
          // CustomTypeAheadField(
          //   textFieldConfiguration: TextFieldConfiguration(
          //     onTap: () {
          //
          //     },
          //     decoration: InputDecoration(
          //         border: InputBorder.none,
          //         prefixIcon: Icon(ChefIcons.chef_and_spoon),
          //         hintText: 'Include custom food tags (Optional)'
          //     ),
          //   ),
          //   containerDecoration: widget.containerDecoration != null ? widget.containerDecoration : BoxDecoration(),
          //   containerMargin: EdgeInsets.zero,
          // ),
          Consumer<FoodOptionsPickerData>(
              builder: (context, data, child) {
                return Padding(
                  padding: const EdgeInsets.only( top: 8, bottom: 8),
                  child: SizedBox(
                    height: 40,
                    child: ListView.builder(
                      itemCount: data.userChoices.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Chip(
                            label: Text(data.userChoices.elementAt(index), style: TextStyle(color: kLightSecondaryColor),),
                            onDeleted: () {
                              data.removeFromUserChoiceAtIndex(index);
                            },
                            deleteIconColor: kLightSecondaryColor,
                          ),
                        );
                    }),
                  ),
                );
              }
          ),
          // Consumer<FoodOptionsPickerData>(
          //   builder: (context, data, child) {
          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //       child: Wrap(
          //         spacing: 10,
          //         children: List.generate(data.userChoices.length, (index) => Chip(
          //           label: Text(data.userChoices.elementAt(index), style: TextStyle(color: kLightSecondaryColor),),
          //           onDeleted: () {
          //             data.removeFromUserChoiceAtIndex(index);
          //           },
          //           deleteIconColor: kLightSecondaryColor,
          //         ),
          //         ),
          //       ),
          //     );
          //   }
          // ),
        ],
      ),
    );
  }
}

