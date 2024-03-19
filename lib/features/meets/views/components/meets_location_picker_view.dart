import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/services/maps_services/geo_locator_service.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/shared/loading_spinner.dart';
import 'package:skibble/features/meets/controllers/meets_loading_controller.dart';
import 'package:skibble/features/meets/controllers/meets_location_controller.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/emojis.dart';
import '../../../../custom_icons/skibble_custom_icons_icons.dart';
import '../../../../utils/number_display.dart';
import '../../../../utils/rating_utils.dart';


class MeetsLocationPickerView extends StatefulWidget {
  const MeetsLocationPickerView({Key? key, }) : super(key: key);

  @override
  State<MeetsLocationPickerView> createState() => _MeetsLocationPickerViewState();
}

class _MeetsLocationPickerViewState extends State<MeetsLocationPickerView> {


  List<String> foodBusinessesTypes = ['Restaurants', 'Cafés & Bistros', 'Bars', 'Fast Food',];
  List<String> emojis = [];
  static final EmojiController emojiController = EmojiController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<MeetsLocationController>(context, listen: false).fetchGoogleFoodBusinesses(context, 0);

    });


    emojis = [
      emojiController.getEmojiCode('spaghetti'),
      emojiController.getEmojiCode('coffee'),
      emojiController.getEmojiCode('beers'),
      emojiController.getEmojiCode('hamburger'),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);},
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10)),
                child: const Text('Cancel', style: TextStyle(color: Colors.blueGrey),),
              ),

              // TextButton(
              //   onPressed: () {
              //     Navigator.pop(context);
              //     },
              //   style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10)),
              //   child: Text('Done',),
              // ),
            ],
          ),

          const SizedBox(height: 20,),


          const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Choose a location',
                  style: TextStyle(
                      color: kDarkSecondaryColor,
                      fontSize: 17,
                      fontWeight:  FontWeight.bold
                  ),
                ),
              )),

          const SizedBox(height: 8,),

          Expanded(
            child: Consumer<MeetsLocationController>(
              builder: (context, locationCont, child) {
                return Column(
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 8),
                            child: SizedBox(
                              height: 34,
                              child: Material(
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: locationCont.textController,
                                  style: const TextStyle(fontSize: 14),

                                  onChanged: (newValue) async {

                                    locationCont.searchString = newValue;
                                    context.read<MeetsLocationController>().getGooglePlaceSuggestions(context, newValue);
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),

                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    // label: Text('Meal Invite Title'),
                                    // labelStyle: TextStyle(fontSize: 20.0, height: 0.8),
                                    // alignLabelWithHint: true,
                                    filled: true,
                                    isDense: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    // contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                    hintText: "Search for a location here...",
                                    prefixIcon: const Icon(cu.CupertinoIcons.search, size: 20,),
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    suffixIcon: locationCont.searchString.isEmpty ? null
                                        :
                                    GestureDetector(
                                        onTap: () async{
                                          locationCont.textController!.clear();
                                          locationCont.searchString = '';
                                        },
                                        child: const Icon(Icons.cancel_rounded, color: Colors.grey,)),
                                    // If  you are using latest version of flutter then label text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,

                                    // suffixIcon: Icon(Iconsax.user),
                                  ),

                                ),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async{
                            await MeetsBottomSheets().showMeetsLocationAccessibilityFilterSheet(context,);

                          },
                          child: Container(
                              padding: const EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, .25), blurRadius: 5.0)
                                  ],
                                  border:  null
                              ),
                              child: const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
                                  child: Icon(
                                    SkibbleCustomIcons.filter_thick,
                                    // Icons.steppers,
                                    size: 19,
                                  ),
                                ),
                              )
                          ),
                        )
                      ],
                    ),


                    locationCont.searchString.length > 1 ?
                    const MeetsAutoCompleteListView()
                        :
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10),
                            child: SizedBox(
                              height: 50,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  // padding: const EdgeInsets.all(8),
                                  itemCount: foodBusinessesTypes.length,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int index) {
                                    return NeumorphicButton(
                                      // curve: Neumorphic.DEFAULT_CURVE,
                                      onPressed: () async {
                                        await locationCont.fetchGoogleFoodBusinesses(context, index);
                                      },
                                      style: NeumorphicStyle(
                                          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                                          depth: index != locationCont.selectedButtonIndex ? 0: 1,
                                          shape: NeumorphicShape.flat,
                                          border: NeumorphicBorder(color: index != locationCont.selectedButtonIndex ? kContentColorLightTheme : kDarkSecondaryColor, width: 0.8),
                                          // lightSource: LightSource.bottom,
                                          color: index != locationCont.selectedButtonIndex ? kLightSecondaryColor : kLightSecondaryColor
                                      ),
                                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                                      // width: 100,
                                      child: Center(
                                        child: Text(
                                          '${emojis[index]} ${foodBusinessesTypes[index]}',
                                          style: TextStyle(
                                              color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : index != locationCont.selectedButtonIndex ? Colors.grey : kDarkSecondaryColor,
                                              fontWeight: index != locationCont.selectedButtonIndex ? null : FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          const MeetsLocationListView()
                        ],
                      ),
                    ),
                  ],
                );
              }
            ),
          )
        ],
      ),
    );

  }
}

class MeetsAutoCompleteListView extends StatelessWidget {
  const MeetsAutoCompleteListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MeetsLocationController>(
      builder: (context, data, child) {
        var list = data.placeSuggestions ?? [];
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Expanded(
            child: Consumer<MeetsLoadingController>(
                builder: (context, loading, child) {
                  return loading.isLoading ?
                  const Center(child: LoadingFallingDot(color: kDarkSecondaryColor, size: 50,))
                      :
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemBuilder: (context, index) {
                              var suggestion = list[index];
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [

                                  ListTile(
                                    onTap: () async{
                                      CustomBottomSheetDialog.showProgressSheetWithMessage(context, 'Fetching this business...', '');
                                      //TODO: Start from here tomorrow
                                      var result = await context.read<MeetsLocationController>().fetchGoogleDetails(context, context.read<MeetsLocationController>().selectedButtonIndex, googlePlaceId: suggestion.id);

                                      Navigator.pop(context);

                                     if(result != null) {
                                       await MeetsBottomSheets().showMeetsBusinessDetailsSheet(context, result, true);
                                     }

                                    },
                                    title: Text(suggestion.title, maxLines: 2, overflow: TextOverflow.ellipsis,),
                                    subtitle:suggestion.subTitle == null ? null: suggestion.subTitle!.trim().isNotEmpty ? Text("${suggestion.subTitle}", maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey),) : null,
                                  ),

                                  const Divider()
                                ],
                              );
                            }),
                      ),
                    ],
                  );
                }
            ),
          ),
        );
      },
    );
  }
}


class MeetsLocationListView extends StatelessWidget {
  const MeetsLocationListView({Key? key, }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<MeetsLocationController>(
      builder: (context, data, child) {
        List<SkibbleFoodBusiness> list = [];
        List<bool> boolList = [];

        if(data.foodBusinesses.isNotEmpty) {
          // var entriesList = data.foodBusinesses.length.entries.toList();
          // if(data.foodBusinesses.length > data.selectedButtonIndex) {
            String type = '';
            switch(data.selectedButtonIndex) {
              case 0:
                type = 'restaurants';
                break;
              case 1:
                type = 'cafes';
                break;
              case 2:
                type = 'bars';
                break;
              case 3:
                type = 'food';
                break;
            }

            var entry = data.foodBusinesses[type];
            list = entry ?? [];

            // var boolEntriesList = data.expandedBusinessMap.entries.toList();

            var boolEntry = data.expandedBusinessMap[type];
            boolList = boolEntry ?? [];

          // }
      }
        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                // here you update your data or load your data from network
                data.loadMoreGoogleFoodBusinesses(context);
              }
              return true;
            },
            child: Expanded(
              child: Consumer<MeetsLoadingController>(
                builder: (context, loading, child) {
                  return loading.isLoading ?
                  const Center(child: LoadingFallingDot(color: kDarkSecondaryColor, size: 50,))
                      :
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            itemBuilder: (context, index) {

                              var suggestion = list[index];

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///
                                  FoodBusinessSuggestionTile(suggestion: suggestion, data: data, index: index, isInitiallyExpanded: boolList[index],),
                                  const Divider()
                                ],
                              );
                            }),
                      ),

                      if(loading.isLoadingThird)
                        const Center(child: LoadingFallingDot(color: kDarkSecondaryColor, size: 50,))
                    ],
                  );
                }
              ),
            ),
          ),
        );
      },
    );
  }
}

class FoodBusinessSuggestionTile extends StatefulWidget {
  const FoodBusinessSuggestionTile({Key? key, required this.suggestion, required this.data, required this.index, required this.isInitiallyExpanded}) : super(key: key);
  final SkibbleFoodBusiness suggestion;
  final MeetsLocationController data;
  final int index;
  final bool isInitiallyExpanded;

  @override
  State<FoodBusinessSuggestionTile> createState() => _FoodBusinessSuggestionTileState();
}

class _FoodBusinessSuggestionTileState extends State<FoodBusinessSuggestionTile> {

  late NavigatorState _navigator;


  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;

    var distance = GeoLocatorService().getDistance(
        widget.suggestion.googlePlaceDetails!.latitude!,
        widget.suggestion.googlePlaceDetails!.longitude!,
        currentUserLocation!.latitude!, currentUserLocation.longitude!);


    return InkWell(
      onTap: ()async {
        CustomBottomSheetDialog.showProgressSheetWithMessage(context, '${widget.suggestion.googlePlaceDetails!.name}', 'Fetching this business...');
        //TODO: Start from here tomorrow
        var result = await context.read<MeetsLocationController>().fetchGoogleDetails(context, context.read<MeetsLocationController>().selectedButtonIndex, indexInList: widget.index);

        Navigator.pop(context);

        if(result != null) {
          await MeetsBottomSheets().showMeetsBusinessDetailsSheet(context, result, true);
        }

      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
        child: Row(
          children: [
            Material(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  image: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? DecorationImage(
                      image: CachedNetworkImageProvider(widget.suggestion.googlePlaceDetails!.placeImages![0]!),
                      fit: BoxFit.cover
                  ) : null,
                  borderRadius: BorderRadius.circular(10),
                  // border: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null:  Border.all()
                ),
                child: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null : const Icon(Iconsax.reserve, color: kDarkSecondaryColor,),
              ),
            ),
            const SizedBox(width: 15,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(widget.suggestion.googlePlaceDetails!.name!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16),),

                  Padding(
                    padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                    child: Row(
                      children: [

                        if(widget.suggestion.googlePlaceDetails!.priceLevel != null)
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) =>
                                    Text(
                                      '\$',
                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: index < widget.suggestion.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
                                    ),),
                              ),
                              const SizedBox(width: 5,),
                              const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                              const SizedBox(width: 5,),
                            ],
                          ),
                        Text(
                          '${NumberDisplay(decimal: 0).displayDelivery(distance)}'.length > 3 ?
                          '${NumberDisplay(decimal: 1).displayDelivery(distance / 1000)}km'
                              :
                          '${NumberDisplay(decimal: 0).displayDelivery(distance)}m',
                          // '${(suggestion.yelpBusinessDetails!.distance! / 1000).toStringAsFixed(1)}km',
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF939393)),
                        ),
                        const SizedBox(width: 5,),
                        const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                        const SizedBox(width: 5,),
                        Expanded(
                            child: Text(
                              '${widget.suggestion.googlePlaceDetails!.city ?? ''}, '
                                  '${widget.suggestion.googlePlaceDetails!.stateOrProvince ?? ''}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF939393)),
                            )
                        ),

                      ],
                    ),
                  ),

                  Row(
                    children: [
                      // SvgPicture.asset(
                      //
                      //   'assets/icons/google_icon.svg',
                      //   height: 18,
                      //   width: 18,
                      // ),
                      // SizedBox(width: 8,),
                      // Container(
                      //   padding: EdgeInsets.all(4),
                      //   decoration: BoxDecoration(
                      //     color: kPrimaryColor,
                      //     borderRadius: BorderRadius.circular(6),
                      //
                      //   ),
                      //   child: Text(
                      //     '${widget.suggestion.googlePlaceDetails!.rating}',
                      //     style: TextStyle(
                      //       color: kLightSecondaryColor,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(width: 3,),
                      RatingBarIndicator(
                        rating: widget.suggestion.googlePlaceDetails!.rating ?? 1,
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
                        itemSize: 24.0,
                        direction: Axis.horizontal,
                      ),

                      Text(
                        ' (${NumberDisplay().displayDelivery(widget.suggestion.googlePlaceDetails!.userRatingCount ?? 0)})',
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),

                  // if(widget.suggestion.googlePlaceDetails!.types != null)
                  //   Column(
                  //     children: [
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 6.0),
                  //         child: SizedBox(
                  //           height: 21,
                  //           child: ListView.builder(
                  //               itemCount: widget.suggestion.googlePlaceDetails!.types?.length,
                  //               scrollDirection: Axis.horizontal,
                  //               itemBuilder: (context, index) {
                  //                 return Container(
                  //                   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
                  //                   margin: EdgeInsets.only(right: 4),
                  //
                  //                   decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(20),
                  //                       border: Border.all(color: kDarkSecondaryColor)
                  //                   ),
                  //                   child: Center(
                  //                       child: Text(
                  //                         '${widget.suggestion.googlePlaceDetails!.types![index]}',
                  //                         maxLines: 1,
                  //                         style: TextStyle(fontSize: 11, color: kDarkSecondaryColor),
                  //                         overflow: TextOverflow.ellipsis,)
                  //                   ),
                  //                 );
                  //               }),
                  //         ),
                  //       ),
                  //     ],
                  //   ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
    ///
    // return ExpansionTile(
    //   onExpansionChanged: (isExpanded) {
    //     if(isExpanded) {
    //       widget.data.expandBusinessTile(context, widget.data.selectedButtonIndex, widget.index);
    //     }
    //     else {
    //       widget.data.collapseTile(widget.data.selectedButtonIndex, widget.index);
    //
    //     }
    //   },
    //   key: UniqueKey(),
    //   expandedAlignment: Alignment.topLeft,
    //   leading: Material(
    //     elevation: 3,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(10),
    //
    //     ),
    //     child: Container(
    //       height: 40,
    //       width: 40,
    //       decoration: BoxDecoration(
    //         image: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? DecorationImage(
    //             image: CachedNetworkImageProvider(widget.suggestion.googlePlaceDetails!.placeImages![0]!),
    //             fit: BoxFit.cover
    //         ) : null,
    //         borderRadius: BorderRadius.circular(10),
    //         // border: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null:  Border.all()
    //       ),
    //       child: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null : Icon(Iconsax.reserve, color: kDarkSecondaryColor,),
    //     ),
    //   ),
    //   initiallyExpanded: widget.isInitiallyExpanded,
    //   trailing: const SizedBox(),
    //   title: Text(widget.suggestion.googlePlaceDetails!.name!, maxLines: 2, overflow: TextOverflow.ellipsis,),
    //   subtitle: Column(
    //     children: [
    //
    //       Padding(
    //         padding: const EdgeInsets.only(top: 6.0),
    //         child: Row(
    //           children: [
    //
    //             if(widget.suggestion.googlePlaceDetails!.priceLevel != null)
    //               Row(
    //                 children: [
    //                   Row(
    //                     children: List.generate(5, (index) =>
    //                         Text(
    //                           '\$',
    //                           maxLines: 1, overflow: TextOverflow.ellipsis,
    //                           style: TextStyle(fontSize: 12, color: index < widget.suggestion.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
    //                         ),),
    //                   ),
    //                   SizedBox(width: 5,),
    //                   CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
    //                   SizedBox(width: 5,),
    //                 ],
    //               ),
    //             Text(
    //               '${NumberDisplay(decimal: 0).displayDelivery(distance)}'.length > 3 ?
    //               '${NumberDisplay(decimal: 1).displayDelivery(distance / 1000)}km'
    //                   :
    //               '${NumberDisplay(decimal: 0).displayDelivery(distance)}m',
    //               // '${(suggestion.yelpBusinessDetails!.distance! / 1000).toStringAsFixed(1)}km',
    //               maxLines: 1, overflow: TextOverflow.ellipsis,
    //               style: TextStyle(fontSize: 12, color: Color(0xFF939393)),
    //             ),
    //             SizedBox(width: 5,),
    //             CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
    //             SizedBox(width: 5,),
    //             Expanded(
    //                 child: Text(
    //                   '${widget.suggestion.googlePlaceDetails!.city!}, '
    //                       '${widget.suggestion.googlePlaceDetails!.stateOrProvince!}',
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                   style: TextStyle(fontSize: 12, color: Color(0xFF939393)),
    //                 )
    //             ),
    //
    //           ],
    //         ),
    //       ),
    //
    //       if(widget.suggestion.googlePlaceDetails!.types != null)
    //         Column(
    //           children: [
    //             Padding(
    //               padding: const EdgeInsets.symmetric(vertical: 6.0),
    //               child: SizedBox(
    //                 height: 21,
    //                 child: ListView.builder(
    //                     itemCount: widget.suggestion.googlePlaceDetails!.types?.length,
    //                     scrollDirection: Axis.horizontal,
    //                     itemBuilder: (context, index) {
    //                       return Container(
    //                         padding: EdgeInsets.symmetric(vertical: 1, horizontal: 6),
    //                         margin: EdgeInsets.only(right: 4),
    //
    //                         decoration: BoxDecoration(
    //                             borderRadius: BorderRadius.circular(20),
    //                             border: Border.all(color: kDarkSecondaryColor)
    //                         ),
    //                         child: Center(
    //                             child: Text(
    //                               '${widget.suggestion.googlePlaceDetails!.types![index]}',
    //                               maxLines: 1,
    //                               style: TextStyle(fontSize: 11, color: kDarkSecondaryColor),
    //                               overflow: TextOverflow.ellipsis,)
    //                         ),
    //                       );
    //                     }),
    //               ),
    //             ),
    //           ],
    //         ),
    //
    //     ],
    //   ),
    //   children: [
    //     Consumer<MeetsLoadingController>(
    //       builder: (context, loading, child) {
    //         return SizedBox(
    //           height: 210,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               loading.isLoadingSecond ?
    //               Expanded(child: Center(child: LoadingFallingDot(color: kDarkSecondaryColor,)))
    //                   :
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 75.0, top: 6),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Container(
    //                             height: 20,
    //                             width: 100,
    //                             child: Align(
    //                               // alignment: A,
    //                                 alignment: Alignment.topLeft,
    //                                 child: Image.asset(widget.data.yelpImagePath(widget.suggestion.googlePlaceDetails!.rating!), fit: BoxFit.cover))),
    //                         SizedBox(width: 1,),
    //                         Container(
    //                             height: 20,
    //                             width: 80,
    //                             child: Align(
    //                               // alignment: A,
    //                                 alignment: Alignment.topLeft,
    //                                 child: SvgPicture.asset('assets/images/yelp_assets/yelp_logo.svg')))
    //                         // Image.asset(data.yelpImagePath(suggestion.yelpBusinessDetails!.rating!), fit: BoxFit.cover))),
    //
    //                       ],
    //                     ),
    //                     SizedBox(height: 4,),
    //                     Text(
    //                       'Based on ${widget.suggestion.googlePlaceDetails!.userRatingCount} reviews',
    //                       style: TextStyle(color: Colors.grey),
    //                     ),
    //                     // Container(
    //                     //     height: 90,
    //                     //     width: 90,
    //                     //
    //                     //     child: PhotoX(
    //                     //         items: [
    //                     //           PhotoXItem(
    //                     //               id: "1", resource: "${suggestion.yelpBusinessDetails!.placeImages![0]}", isAsset: false),
    //                     //           PhotoXItem(
    //                     //               id: "2", resource: "${suggestion.yelpBusinessDetails!.placeImages![1]}", isAsset: false),
    //                     //         ],
    //                     //       dismissMode: DismissMode.swipeVertical,
    //                     //     )
    //                     // ),
    //
    //                     ///
    //                     SizedBox(
    //                         height: 90,
    //                         child: ListView.builder(
    //                             itemCount: widget.suggestion.yelpBusinessDetails!.placeImages?.length,
    //                             scrollDirection: Axis.horizontal,
    //                             itemBuilder: (context, index) {
    //
    //                               return GestureDetector(
    //                                 onTap: () {
    //                                   PhotoViewController().onTap(context, widget.suggestion.yelpBusinessDetails!.placeImages![index],
    //                                       widget.suggestion.yelpBusinessDetails!.placeImages!.map((e) => GalleryImage(
    //                                           resource: e,
    //                                           type: PhotoType.network
    //                                       )).toList()
    //
    //                                   );
    //
    //                                 },
    //                                 child: Container(
    //                                   height: 75,
    //                                   width: 50,
    //                                   margin: EdgeInsets.only(right: 10, top: 10),
    //                                   decoration: BoxDecoration(
    //                                       image: DecorationImage(
    //                                           image: CachedNetworkImageProvider(widget.suggestion.yelpBusinessDetails!.placeImages?[index]),
    //                                           fit:  BoxFit.cover
    //                                       ),
    //                                       borderRadius: BorderRadius.circular(8)
    //                                   ),
    //                                 ),
    //                               );
    //                               ///
    //                             })
    //                     ),
    //
    //                     SizedBox(height: 15,),
    //
    //                     Row(
    //                       children: [
    //                         Expanded(
    //                           child: ElevatedButton(
    //                             onPressed: () async{
    //
    //                               CustomBottomSheetDialog.showProgressSheetWithMessage(_navigator.context, '${widget.suggestion.yelpBusinessDetails!.name}', 'Getting opening hours...');
    //
    //                               var result = await context.read<MeetsLocationController>().fetchGoogleDetails(context, widget.data.selectedButtonIndex, widget.index);
    //                               Navigator.pop(context);
    //
    //                               if(result.googlePlaceDetails != null) {
    //                                 if(result.googlePlaceDetails!.businessStatus == BusinessStatus.operational) {
    //                                   await MeetsBottomSheets().showMeetsDateTimePickerSheet(_navigator.context, result, widget.index);
    //                                 }
    //                                 else if(result.googlePlaceDetails!.businessStatus == BusinessStatus.closed_temporarily){
    //                                   CustomBottomSheetDialog.showErrorSheet(_navigator.context, 'Oops! This business is temporarily closed.', onButtonPressed: () { Navigator.pop(_navigator.context); });
    //
    //                                 }
    //                                 else if(result.googlePlaceDetails!.businessStatus == BusinessStatus.closed_permanently){
    //                                   CustomBottomSheetDialog.showErrorSheet(_navigator.context, 'Oops! This business is permanently closed.', onButtonPressed: () { Navigator.pop(_navigator.context); });
    //
    //                                 }
    //                                 else {
    //                                   CustomBottomSheetDialog.showMessageSheet(_navigator.context, 'We are unable to determine the status of this business at the moment. Try again later', onButtonPressed: () { Navigator.pop(_navigator.context); });
    //
    //                                 }
    //                               }
    //                               // await Future.delayed(Duration(seconds: 10),  () {});
    //                             },
    //
    //                             child: Text(
    //                               !isBusinessDateTimeSelected ?
    //                                 'Choose meet date and time'
    //                                     :
    //                                 'Meet on ${DateFormat('EEE, dd MMM yyyy').format(context.read<MeetsDateTimeController>().selectedDateTime!)} at ${DateFormat('hh:mm a').format(context.read<MeetsDateTimeController>().selectedDateTime!)}',
    //                                 style: TextStyle(
    //                                     color: isBusinessDateTimeSelected ? kLightSecondaryColor : kDarkSecondaryColor,
    //                                   fontSize: 13,
    //
    //                                 ),
    //                             ),
    //                             style: ElevatedButton.styleFrom(
    //                                 shape: RoundedRectangleBorder(
    //                                     borderRadius: BorderRadius.circular(20),
    //                                     side: BorderSide(color: kDarkSecondaryColor)
    //                                 ),
    //                                 backgroundColor: !isBusinessDateTimeSelected ? kLightSecondaryColor : kDarkSecondaryColor
    //                             ),
    //                           ),
    //                         ),
    //                         SizedBox(width: 10,),
    //                         // ElevatedButton(
    //                         //   onPressed: () {},
    //                         //   child: Text('Set Location', ),
    //                         //   style: ElevatedButton.styleFrom(
    //                         //       shape: RoundedRectangleBorder(
    //                         //         borderRadius: BorderRadius.circular(20),
    //                         //         // side: BorderSide(color: kDarkSecondaryColor)
    //                         //       ),
    //                         //       backgroundColor: kDarkSecondaryColor
    //                         //
    //                         //   ),
    //                         // ),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               ),
    //
    //             ],
    //           ),
    //         );
    //       }
    //     )
    //   ],
    // );
  }
}

