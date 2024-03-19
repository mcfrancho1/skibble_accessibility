import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/skib_controller.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/skibble_post.dart';
import 'package:skibble/services/firebase/database/recipe_database.dart';
import 'package:skibble/services/maps_services/map_requests.dart';
import 'package:skibble/services/typesense_search.dart';
import 'package:skibble/shared/type_ahead_field.dart';
import 'package:skibble/features/skibs/post_views/user_recipe_selection_view.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:uuid/uuid.dart';

import '../../../custom_icons/chef_icons_icons.dart';
import '../../../models/recipe.dart';
import '../../../models/skibble_file.dart';
import '../../../models/suggestion.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../shared/dialogs.dart';
import '../../../utils/helper_methods.dart';

class UserEditPostView extends StatefulWidget {
  const UserEditPostView({Key? key, required this.skibblePost}) : super(key: key);

  final SkibblePost skibblePost;

  @override
  State<UserEditPostView> createState() => _UserEditPostViewState();
}


class _UserEditPostViewState extends State<UserEditPostView> {

  Future? fileFutures;

  Address? locationAddress;

  TextEditingController addressController = TextEditingController();
  TextEditingController captionController = TextEditingController();

  List<String> foodTags = [];


  @override
  void initState() {
    // TODO: implement initState
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;

    // fileFutures =  processEntities();
    captionController.text = widget.skibblePost.caption;

    if(widget.skibblePost.postTags != null) {
      foodTags.addAll(List<String>.from(widget.skibblePost.postTags!));
    }

    if(widget.skibblePost.postAddress != null) {
      locationAddress = widget.skibblePost.postAddress;
      addressController.text = widget.skibblePost.postAddress!.placeName! + ", " + widget.skibblePost.postAddress!.formattedAddress!;
    }

    if(widget.skibblePost.attachedRecipeId != null) {
      // figure out the recipe here
      recipe = Recipe(title: '', recipeId: widget.skibblePost.attachedRecipeId, creatorId: currentUser.userId, creatorUser: currentUser);
    }

    if(widget.skibblePost.customLocation != null) {
      selectedCustomLocation = widget.skibblePost.customLocation;
    }
    super.initState();
  }


  final String _session = const Uuid().v4();

  Recipe? recipe;

  String? selectedCustomLocation;

  final List<String> customLocation = ['My Kitchen', 'School', 'Work'];

  @override
  void dispose() {
    // TODO: implement dispose
    addressController.dispose();
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return WillPopScope(
      onWillPop: () async{

        return true;
      },
      child: GestureDetector(
        onTap: () => HelperMethods().dismissKeyboard(context),

        child: Scaffold(
          appBar: AppBar(
            leading: TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('Cancel', style: TextStyle(fontSize: 16, color: kErrorColor),)
            ),
            centerTitle: true,
            leadingWidth: 70,
            title: Text('Edit Skib', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
            actions: [
              TextButton(
                  onPressed: () async{

                    CustomDialog(context).showProgressDialog(context, 'Updating skib...');

                    widget.skibblePost.caption = captionController.text;
                    widget.skibblePost.postAddress = locationAddress;
                    widget.skibblePost.customLocation = selectedCustomLocation;
                    widget.skibblePost.attachedRecipeId = recipe != null ? recipe!.recipeId! : null;
                    widget.skibblePost.postTags = foodTags;
                    widget.skibblePost.creatorUser = currentUser;
                    // await FeedDatabaseService().createTags();
                    // var result = await context.read<SkibController>().updateSkibblePost(widget.skibblePost, context);

                    // if(!result) {
                    //   Navigator.pop(context);
                    //
                    //   CustomDialog(context).showErrorDialog('Error', 'Unable to update your skib at the moment.');
                    // }
                    // else {
                    //   Navigator.pop(context);
                    //   if(Navigator.canPop(context)) {
                    //     Navigator.pop(context);
                    //   }
                    // }
                  },
                  child: const Text('Save', style: TextStyle(fontSize: 16))
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        ContentEditFutureDisplay(skibblePost: widget.skibblePost),

                        const SizedBox(width: 15,),
                        Expanded(
                          child: TextField(
                            maxLines: null,
                            minLines: null,
                            controller: captionController,
                            // expands: true,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Edit caption here...'
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 10,),

                  const Divider(),

                  //address
                  CustomTypeAheadField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: addressController,
                      enabled: selectedCustomLocation == null,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Iconsax.location),
                          hintText: 'Add a location(Optional)'
                      ),
                    ),
                    containerDecoration: const BoxDecoration(),
                    containerMargin: EdgeInsets.zero,
                    onSuggestionSelected: (Suggestion suggestion) async{
                      setState(() {
                        addressController.text = suggestion.title + ", " + suggestion.subTitle!;
                        locationAddress =  Address(googlePlaceId: suggestion.id, placeName: suggestion.title, formattedAddress: suggestion.subTitle );
                      });
                    },
                    suggestionCallback: (pattern) async {

                      return GoogleMapsService().getPlaceSuggestions(pattern, _session);
                    },
                  ),

                  const SizedBox(height: 10,),

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
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
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
                  const Divider(),


                  FoodTagsView(onListChanged: (value) => foodTags = value, initialFoodTags: foodTags,),
                  const SizedBox(height: 10,),

                  const Divider(),

                  //attach a recipe

                  recipe == null ? TextButton(
                    onPressed: () async{
                      var attachedRecipe = await Navigator.of(context).push<Recipe?>(MaterialPageRoute(builder: (context) => UserRecipeSelectionView(recipeId: widget.skibblePost.attachedRecipeId,)));

                      if(attachedRecipe != null) {
                        setState(() => recipe = attachedRecipe);
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Iconsax.document, color: Colors.grey,),
                        SizedBox(width: 10,),
                        Text('Attach a recipe'),
                      ],
                    ),
                  )
                      :

                      recipe!.title.trim().isNotEmpty ?
                  Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          // color: kLightSecondaryColor,
                          elevation: 3,
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
                                              recipe!.recipeImageUrl!
                                          ),
                                          fit: BoxFit.cover
                                      )
                                  ),
                                ),
                                const SizedBox(width: 10,),
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
                          icon: const Icon(Iconsax.trash))
                    ],
                  )
                  :
                  FutureBuilder<Recipe?>(
                    future: RecipeDatabaseService().getRecipeInfo(recipe!.recipeId!),
                    builder: (context, snapshot) {
                      switch(snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container();
                        case ConnectionState.waiting:
                          return Container(
                            width: double.infinity,
                            height: 40,
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade300
                            ),
                          );
                        case ConnectionState.active:

                        case ConnectionState.done:
                          if(snapshot.hasData) {
                            Recipe? recipeResult = snapshot.data as Recipe;
                            return Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    // color: kLightSecondaryColor,
                                    elevation: 3,
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
                                                        recipeResult.recipeImageUrl!
                                                    ),
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              recipeResult.title,
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
                                    icon: const Icon(Iconsax.trash))
                              ],
                            );
                          }

                          else {
                            return Row(
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    // color: kLightSecondaryColor,
                                    elevation: 3,
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
                                                image: const DecorationImage(
                                                    image: AssetImage('assets/images/dish.png'),
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                          ),
                                          const SizedBox(width: 10,),
                                          Expanded(
                                            child: Text(
                                              'Recipe unavailable',
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
                                    icon: const Icon(Iconsax.trash))
                              ],
                            );
                          }
                      }
                    }
                  ),

                  const SizedBox(height: 10,),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ContentEditFutureDisplay extends StatelessWidget {
  const ContentEditFutureDisplay({Key? key, required this.skibblePost}) : super(key: key);
  final SkibblePost skibblePost;
  @override
  Widget build(BuildContext context) {
    return skibblePost.postContentList!.last.fileType == SkibbleFileType.image ? Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
              image: CachedNetworkImageProvider(
                  skibblePost.postContentList!.last.mediaUrl!
              ),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.black26,
          child: CircleAvatar(
            radius: 10,

            child: Text('${skibblePost.postContentList!.length}'),
          ),
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
              image: CachedNetworkImageProvider(skibblePost.postContentList!.last.videoThumbnailUrl!),
              fit: BoxFit.cover
          )
      ),
      child: Center(
        child: CircleAvatar(
          radius: 12,
          backgroundColor: Colors.black26,
          child: CircleAvatar(
            radius: 10,
            child: Text('${skibblePost.postContentList!.length}'),
          ),
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
  const FoodTagsView({Key? key, required this.onListChanged, this.containerDecoration, this.initialFoodTags}) : super(key: key);
  final Function(List<String> value) onListChanged;
  final BoxDecoration? containerDecoration;
  final List<String>? initialFoodTags;

  @override
  State<FoodTagsView> createState() => _FoodTagsViewState();
}

class _FoodTagsViewState extends State<FoodTagsView> {

  TextEditingController typeAheadController = TextEditingController();


  Set<String> foodTags = {};


  @override
  void initState() {
    // TODO: implement initState
    if(widget.initialFoodTags != null) {
      foodTags = widget.initialFoodTags!.toSet();
    }
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    typeAheadController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //food tags
        CustomTypeAheadField(
          textFieldConfiguration: TextFieldConfiguration(
            controller: typeAheadController,
            onSubmitted: (value) {
              typeAheadController.clear();
              setState(() {
                foodTags.add(value.trim().toLowerCase());
              });
              widget.onListChanged(foodTags.toList());
            },
            decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(ChefIcons.chef_and_spoon),
                hintText: 'Include custom food tags (Optional)'
            ),
          ),
          containerDecoration: widget.containerDecoration != null ? widget.containerDecoration : const BoxDecoration(),
          containerMargin: EdgeInsets.zero,
          onSuggestionSelected: (Suggestion suggestion) async{
            typeAheadController.clear();
            setState(() {
              foodTags.add(suggestion.title.trim().toLowerCase());
            });
            widget.onListChanged(foodTags.toList());
          },
          suggestionCallback: (pattern) async {
            return await TypeSenseSearch().searchFoodTagsByPattern(pattern);
            // return await BackendService.getSuggestions(pattern);
          },
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 10,
            children: List.generate(foodTags.length, (index) => Chip(
              label: Text(foodTags.elementAt(index), style: const TextStyle(color: kLightSecondaryColor),),
              onDeleted: () {
                setState(() {
                  foodTags.remove(foodTags.elementAt(index));
                });
                widget.onListChanged(foodTags.toList());
              },
              deleteIconColor: kLightSecondaryColor,
            ),
            ),
          ),
        ),
      ],
    );
  }
}

