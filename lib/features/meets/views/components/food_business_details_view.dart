import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:skibble/features/meets/views/create_meet/accessibility_ratings_view.dart';

import '../../../../controllers/map_launcher_controller.dart';
import '../../../../custom_icons/chef_icons_icons.dart';
import '../../../../models/address.dart';
import '../../../../models/google_place_details.dart';
import '../../../../models/skibble_place.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../services/maps_services/geo_locator_service.dart';
import '../../../../shared/bottom_sheet_dialogs.dart';
import '../../../../shared/custom_expanded_text.dart';
import '../../../../shared/custom_map.dart';
import '../../../../shared/custom_web_view.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/helper_methods.dart';
import '../../../../utils/number_display.dart';
import '../../../../utils/rating_utils.dart';
import '../../../discover/chef_profile/Tabs/description_view_tab.dart';
import '../../../discover/chef_profile/Tabs/menu_view_tab.dart';
import '../../../discover/chef_profile/Tabs/recipes_view_tab.dart';
import '../../../discover/chef_profile/Tabs/review_view_tab.dart';
import '../../../discover/chef_profile/Tabs/skibs_view_tab.dart';
import '../../../discover/chef_profile/components/featured_container.dart';
import '../../../kitchens/kitchen_profile/kitchen_profile_page.dart';
import '../../controllers/meets_date_time_controller.dart';
import '../../controllers/meets_location_controller.dart';
import '../../utils/meets_bottom_sheets.dart';
import '../create_meet/food_business_story_view.dart';

class FoodBusinessProfilePageAppBar extends StatefulWidget {
  const FoodBusinessProfilePageAppBar(
      {Key? key, required this.tabController, required this.business})
      : super(key: key);

  final TabController tabController;
  final SkibbleFoodBusiness business;

  @override
  State<FoodBusinessProfilePageAppBar> createState() => _FoodBusinessProfilePageAppBarState();
}

class _FoodBusinessProfilePageAppBarState extends State<FoodBusinessProfilePageAppBar> {
  List<String> popUpChoices = [];

  List popUpIcons = [];

  List tagsList = [
    'African',
    'Spanish',
    'Italian',
    'Pizza',
    'Mexican',
    'Desserts',
    'Baking',
    'Dinner',
    'Burgers',
    'Canadian',
    'Party'
  ];

  double controllerOffset = 300.0;

  double flexibleSpaceHeight = 440;
  late double baseHeight = 465;

  @override
  void initState() {
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;

    // scrollController.addListener(_listenToScrollChange);
  }

  @override
  void dispose() {
    // sticky!.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    var _isScrolled = Provider.of<AppData>(context).isChefProfileScrolled;
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;

    var distance = GeoLocatorService().getDistance(
        widget.business.googlePlaceDetails!.latitude!,
        widget.business.googlePlaceDetails!.longitude!,
        currentUserLocation!.latitude!, currentUserLocation.longitude!);



    return SliverAppBar(
      expandedHeight: flexibleSpaceHeight + 320,
      elevation: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      stretch: true,
      toolbarHeight: 90,

      backgroundColor: CurrentTheme(context).isDarkMode
          ? kBackgroundColorDarkTheme
          : kContentColorLightTheme,

      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        collapseMode: CollapseMode.pin,
        //TODO: Change this to background later
        background: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: _isScrolled ? 0.0 : 1.0,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodBusinessStoryView(business: widget.business),

              // //profile image
              // Container(
              //   transform: Matrix4.translationValues(0.0, -40.0, 0.0),
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   //TODO: change to cachedImageProvider
              //   child: Column(
              //     // mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         // crossAxisAlignment: CrossAxisAlignment.end,
              //         children: [
              //           Container(
              //             height: 100,
              //             width: 100,
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.circular(50),
              //               color: kDarkColor
              //             )
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              Container(
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                  child: Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(widget.business.googlePlaceDetails!.name!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20),),

                            Padding(
                              padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                              child: Row(
                                children: [

                                  if(widget.business.googlePlaceDetails!.priceLevel != null)
                                    Row(
                                      children: [
                                        Row(
                                          children: List.generate(5, (index) =>
                                              Text(
                                                '\$',
                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 12, color: index < widget.business.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
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
                                        '${widget.business.googlePlaceDetails!.city ?? ''}, '
                                            '${widget.business.googlePlaceDetails!.stateOrProvince ?? ''}',
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
                                RatingBarIndicator(
                                  rating: widget.business.googlePlaceDetails!.rating ?? 0,
                                  itemBuilder: (context, index) =>
                                  // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Container(
                                      // height: 0,
                                      // width: 20,
                                      decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.star_rounded,
                                          size: 24,
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
                                  ' (${NumberDisplay().displayDelivery(widget.business.googlePlaceDetails!.userRatingCount ?? 0)})',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ),

              //featured container
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Featured Items",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF233748)),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    Container(
                      height: 208,
                      child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            FeaturedContainer(),
                            SizedBox(
                              width: 5,
                            ),
                            FeaturedContainer(),
                            SizedBox(
                              width: 5,
                            ),
                            FeaturedContainer()
                          ]),
                    )
                  ],
                ),
              )
              // SizedBox(height: 10,),
            ],
          ),
        ),
      ),

      bottom: TabBar(
        // padding: EdgeInsets.symmetric(horizontal: 10),
        controller: widget.tabController,
        labelColor: kPrimaryColor,
        unselectedLabelColor: Colors.grey.withOpacity(0.5),
        indicatorColor: kPrimaryColor,
        tabs: [
          // Tab(
          //   // text: "Feed",
          //   icon: Icon(Iconsax.tag_user),
          // ),

          Tab(
            text: "Menu",
            // icon: Icon(Icons.restaurant_menu_rounded),
          ),
          Tab(
            text: "Info",
            // icon: Icon(Icons.star_border_outlined),
          ),
          Tab(
            text: "Skibs",
            // icon: Icon(Iconsax.video_play),
          ),

          Tab(
            text: "Events",
            // icon: Icon(Iconsax.book_1),
          ),

          // Tab(
          //   // text: "Explore",
          //   icon: Icon(Iconsax.star_1),
          // ),
        ],
        // unselectedLabelColor: Colors.grey,
        // unselectedLabelStyle: TextStyle(fontSize: 17),
        // // add it here
        // labelColor: kPrimaryColor,
        // labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        // indicator: DotIndicator(
        //   color: kPrimaryColor,
        //   distanceFromCenter: 16,
        //   radius: 3,
        //   paintingStyle: PaintingStyle.fill,
      ),
    );
  }

}


class FoodBusinessDetailsView extends StatefulWidget {
  const FoodBusinessDetailsView({Key? key, required this.business, this.allowCreateMeet = false}) : super(key: key);

  final SkibbleFoodBusiness business;
  final bool allowCreateMeet;

  @override
  State<FoodBusinessDetailsView> createState() => _FoodBusinessDetailsViewState();
}

class _FoodBusinessDetailsViewState extends State<FoodBusinessDetailsView> with SingleTickerProviderStateMixin {
  // final int? index;
  late ScrollController _scrollController;

  late TabController tabController;

  bool _isScrolled = false;

  List<String> popUpChoices = [];

  List popUpIcons = [];


  double controllerOffset = 300.0;

  @override
  void initState() {
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    tabController = new TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
  }

  SliverAppBar getAppbar() {
    return SliverAppBar(
      forceElevated: false,
      expandedHeight: 200,
      elevation: 0,
      stretch: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (d) {
          },
          itemBuilder: (BuildContext context) {
            return popUpChoices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                ),
              );
            }).toList();
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground
        ],
        background: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            SizedBox.expand(
              child: Container(
                padding: const EdgeInsets.only(top: 50),
                height: 30,
                color: Colors.white,
              ),
            ),
            // Container(height: 50, color: Colors.black),

            /// Banner image
            Container(
                height: 180,
                padding: const EdgeInsets.only(top: 28),
                child: Container()),

            /// UserModel avatar, message icon, profile edit and follow/following button
            Container(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle),
                      child: Container(
                        height: 80,
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 90, right: 30),
                    child: Row(
                      children: <Widget>[
                        Container(height: 40),
                        SizedBox(width: 10),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listenToScrollChange() {
    if (_scrollController.offset >= controllerOffset) {
      // setState(() {
      //   _isScrolled = true;
      // });

      Provider.of<AppData>(context, listen: false)
          .updateIsChefProfileScrolled(true);
    } else {
      // setState(() {
      //   _isScrolled = false;
      // });
      Provider.of<AppData>(context, listen: false)
          .updateIsChefProfileScrolled(false);
    }
  }

  @override
  Widget build(BuildContext context) {

    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;

    var distance = GeoLocatorService().getDistance(
        widget.business.googlePlaceDetails!.latitude!,
        widget.business.googlePlaceDetails!.longitude!,
        currentUserLocation!.latitude!, currentUserLocation.longitude!);


    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: FoodBusinessProfilePageAppBar(
              business: widget.business,
              tabController: tabController,
            ),
          )
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: [
          MenuViewTab(),
          InfoTabView(business: widget.business),
          SkibTabView(business: widget.business,),
          Container(),
          // Container()
          //
          //
          //
          // ReviewViewTab(),
          //
          //
          // SkibsViewTab(),
          //
          // RecipeViewTab(),
          //
          // DescriptionViewTab(),

        ],
      ),
    );

    ///
    return Container(
      // color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [

                FoodBusinessStoryView(business: widget.business),

                Container(
                    padding: const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                    child: Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(widget.business.googlePlaceDetails!.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20),),

                              Padding(
                                padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                                child: Row(
                                  children: [

                                    if(widget.business.googlePlaceDetails!.priceLevel != null)
                                      Row(
                                        children: [
                                          Row(
                                            children: List.generate(5, (index) =>
                                                Text(
                                                  '\$',
                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(fontSize: 12, color: index < widget.business.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
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
                                          '${widget.business.googlePlaceDetails!.city ?? ''}, '
                                              '${widget.business.googlePlaceDetails!.stateOrProvince ?? ''}',
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
                                  RatingBarIndicator(
                                    rating: widget.business.googlePlaceDetails!.rating ?? 0,
                                    itemBuilder: (context, index) =>
                                    // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Container(
                                        // height: 0,
                                        // width: 20,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.star_rounded,
                                            size: 24,
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
                                    ' (${NumberDisplay().displayDelivery(widget.business.googlePlaceDetails!.userRatingCount ?? 0)})',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),

                const SizedBox(height: 10,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [


                           Column(
                            children: [
                              ListTile(
                                leading: Icon(Iconsax.location,  color: kDarkSecondaryColor,),
                                title: Text('Address',),

                                onTap: () async{
                                  await MapLauncherController().launchMaps(context, widget.business.address);

                                },
                                subtitle: Text('${widget.business.googlePlaceDetails!.formattedAddressString}', maxLines: 2, overflow: TextOverflow.ellipsis,),
                                trailing: Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                              ),

                              Divider()
                            ],
                          ),

                        if(widget.business.googlePlaceDetails!.websiteAddress != null)
                          Column(
                            children: [
                              ListTile(
                                leading: const Icon(Iconsax.global, color: kDarkSecondaryColor,),
                                title: const Text('Visit website',),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWebView(webUrl: widget.business.googlePlaceDetails!.websiteAddress!, title: '${widget.business.googlePlaceDetails!.name}' )));

                                },
                                subtitle: Text('${widget.business.googlePlaceDetails!.websiteAddress}'),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                              ),

                              const Divider()
                            ],
                          ),

                        if(widget.business.googlePlaceDetails!.phoneNumber != null )
                          Column(
                            children: [
                              ListTile(
                                leading: const Icon(Iconsax.call,  color: kDarkSecondaryColor,),
                                title: const Text('Call'),
                                onTap: () async{
                                  if(Platform.isIOS) {
                                    await HelperMethods().callNumber(widget.business.googlePlaceDetails!.phoneNumber!);
                                  }
                                  else {
                                    await HelperMethods().getPhoneNumberAndLaunchDialPad(widget.business.googlePlaceDetails!.phoneNumber!);

                                  }
                                },
                                subtitle: Text('${widget.business.googlePlaceDetails!.phoneNumber}'),
                                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                              ),

                              Divider()
                            ],
                          ),

                        ListTile(
                          leading: const Icon(Iconsax.info_circle,  color: kDarkSecondaryColor,),
                          title: Row(

                            children: [
                              const Text('Accessibility rating'),

                              SizedBox(width: 8,),
                              Row(
                                children: [
                                  Icon(Iconsax.star1, size: 20, color: kDarkColor,),
                                  SizedBox(width: 4,),
                                  Text('4.0')
                                ],
                              )

                            ],
                          ),
                          onTap: () async{
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessibilityRatingView()));
                          },

                          subtitle: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Chip(label: Text('Accessible parking'),
                                  backgroundColor: kLightSecondaryColor,
                                  side: BorderSide(color: kDarkColor),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(vertical: -4),
                                  labelStyle: TextStyle(color: kDarkColor, fontSize: 12),),

                                SizedBox(width: 4,),
                                Chip(label: Text('Quiet space'),
                                  backgroundColor: kLightSecondaryColor,
                                  side: BorderSide(color: kDarkColor),
                                  padding: EdgeInsets.zero,
                                  visualDensity: VisualDensity(vertical: -4),
                                  labelStyle: TextStyle(color: kDarkColor, fontSize: 12),)
                              ],
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                          isThreeLine: true,
                        ),

                      ],
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 0),
                  child: SizedBox(
                    height: 180,
                    // width: 200,
                    child: Stack(
                      children: [
                        Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ChatMap(
                                  zoomLevel: 16,
                                  address: Address(latitude: widget.business.address.latitude, longitude: widget.business.address.longitude),))),

                        Positioned(
                          top: 20,
                          right: 10,
                          child: GestureDetector(
                              onTap: () async {
                                await MapLauncherController().launchMaps(context, widget.business.address);

                              },
                              child: const CircleAvatar(
                                  backgroundColor: kLightSecondaryColor,
                                  child: Icon(Iconsax.map, size: 20, color: kDarkSecondaryColor,))),
                        ),


                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15,),


                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20, bottom: 8),
                  child: Text('Google Reviews', style: TextStyle(fontSize: 17),),
                ),

                SizedBox(
                  height: 210,
                  child: widget.business.googlePlaceDetails!.ratingsAndReviewsList!.isNotEmpty ?
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.business.googlePlaceDetails!.ratingsAndReviewsList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var ratingAndReview = widget.business.googlePlaceDetails!.ratingsAndReviewsList![index];
                        return SizedBox(
                          width: 300,
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.grey.shade400)
                            ),
                            margin: const EdgeInsets.only(left: 15),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 35,
                                        decoration: BoxDecoration(
                                            image: ratingAndReview.profileImageUrl != null ? DecorationImage(
                                                image: CachedNetworkImageProvider(ratingAndReview.profileImageUrl!),
                                                fit: BoxFit.cover
                                            ) : null,
                                            shape: BoxShape.circle
                                          // border: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null:  Border.all()
                                        ),
                                        child: ratingAndReview.profileImageUrl != null ? null : const Icon(Iconsax.reserve, color: kDarkSecondaryColor,),
                                      ),
                                      const SizedBox(width: 10,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(ratingAndReview.authorName!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15),),

                                            Row(
                                              children: [
                                                Text('${ratingAndReview.overallRating!}',
                                                  overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14),),

                                                const SizedBox(width: 4,),
                                                RatingBarIndicator(
                                                  rating: ratingAndReview.overallRating!,
                                                  itemBuilder: (context, index) =>
                                                  // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    size: 16,
                                                    color: Colors.amber,),
                                                  itemCount: 5,
                                                  unratedColor: Colors.grey.shade300,
                                                  itemSize: 16.0,
                                                  direction: Axis.horizontal,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0, bottom: 6),
                                    child:  CustomExpandedText(
                                      text: '${ratingAndReview.reviewText}',
                                      onTapShowMore: () {  }, maxLength: 200,

                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      :
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Center(
                          child: Text(
                            'No reviews yet',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15
                            ),
                          )
                      )
                  ),
                ),

                const SizedBox(height: 130,)
              ],
            ),
          ),

          if(widget.allowCreateMeet)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 80,
              child: Container(
                decoration: BoxDecoration(
                    color: kContentColorLightTheme,
                    border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5))
                ),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Meet Date & Time', style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),),
                          const SizedBox(height: 4,),
                          Consumer<MeetsLocationController>(
                              builder: (context, data, child) {
                                var isBusinessDateTimeSelected = (data.finalSelectedBusinessId == widget.business.skibblePlaceId)
                                    && context.read<MeetsDateTimeController>().selectedDateTime != null;
                                // (data.finalSelectedButtonIndex == data.selectedButtonIndex)
                                //     &&
                                //     (data.finalSelectedListIndex == index) && context.read<MeetsDateTimeController>().selectedDateTime != null;
                                return Text(
                                  !isBusinessDateTimeSelected ?
                                  'No Date & Time selected'
                                      :
                                  '${DateFormat('EEE, dd MMM yyyy').format(context.read<MeetsDateTimeController>().selectedDateTime!)} at ${DateFormat('hh:mm a').format(context.read<MeetsDateTimeController>().selectedDateTime!)}',

                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    // fontStyle: FontStyle.italic
                                  ),
                                );
                              }
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15,),

                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () async{
                          if(widget.business.googlePlaceDetails != null) {
                            if(widget.business.googlePlaceDetails!.businessStatus == BusinessStatus.operational) {
                              await MeetsBottomSheets().showMeetsDateTimePickerSheet(context, widget.business, true);
                            }
                            else if(widget.business.googlePlaceDetails!.businessStatus == BusinessStatus.closed_temporarily){
                              CustomBottomSheetDialog.showErrorSheet(context, 'Oops! This business is temporarily closed.', onButtonPressed: () { Navigator.pop(context); });

                            }
                            else if(widget.business.googlePlaceDetails!.businessStatus == BusinessStatus.closed_permanently){
                              CustomBottomSheetDialog.showErrorSheet(context, 'Oops! This business is permanently closed.', onButtonPressed: () { Navigator.pop(context); });

                            }
                            else {
                              CustomBottomSheetDialog.showMessageSheet(context, 'We are unable to determine the status of this business at the moment. Try again later', onButtonPressed: () { Navigator.pop(context); });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10))
                            )
                        ),

                        child: const Text('Choose date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),),
                    ),

                  ],
                ),
              ),
            )

        ],
      ),
    );
  }
}

class InfoTabView extends StatelessWidget {
  const InfoTabView({super.key, required this.business});

  final SkibbleFoodBusiness business;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                      child: Text(
                        "Info",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [


                            Column(
                              children: [
                                ListTile(
                                  leading: Icon(Iconsax.location,  color: kDarkSecondaryColor,),
                                  title: Text('Address',),

                                  onTap: () async{
                                    await MapLauncherController().launchMaps(context, business.address);

                                  },
                                  subtitle: Text('${business.googlePlaceDetails!.formattedAddressString}', maxLines: 2, overflow: TextOverflow.ellipsis,),
                                  trailing: Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                                ),

                                Divider()
                              ],
                            ),

                            if(business.googlePlaceDetails!.websiteAddress != null)
                              Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Iconsax.global, color: kDarkSecondaryColor,),
                                    title: const Text('Visit website',),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWebView(webUrl: business.googlePlaceDetails!.websiteAddress!, title: '${business.googlePlaceDetails!.name}' )));

                                    },
                                    subtitle: Text('${business.googlePlaceDetails!.websiteAddress}'),
                                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                                  ),

                                  const Divider()
                                ],
                              ),

                            if(business.googlePlaceDetails!.phoneNumber != null )
                              Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Iconsax.call,  color: kDarkSecondaryColor,),
                                    title: const Text('Call'),
                                    onTap: () async{
                                      if(Platform.isIOS) {
                                        await HelperMethods().callNumber(business.googlePlaceDetails!.phoneNumber!);
                                      }
                                      else {
                                        await HelperMethods().getPhoneNumberAndLaunchDialPad(business.googlePlaceDetails!.phoneNumber!);

                                      }
                                    },
                                    subtitle: Text('${business.googlePlaceDetails!.phoneNumber}'),
                                    trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                                  ),

                                  Divider()
                                ],
                              ),

                            ListTile(
                              leading: const Icon(Iconsax.info_circle,  color: kDarkSecondaryColor,),
                              title: Row(

                                children: [
                                  const Text('Accessibility rating'),

                                  SizedBox(width: 8,),
                                  Row(
                                    children: [
                                      Icon(Iconsax.star1, size: 20, color: kDarkColor,),
                                      SizedBox(width: 4,),
                                      Text('4.0')
                                    ],
                                  )

                                ],
                              ),
                              onTap: () async{
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccessibilityRatingView()));
                              },

                              subtitle: SizedBox(
                                height: 50,
                                child: Row(
                                  children: [
                                    Chip(label: Text('Accessible parking'),
                                      backgroundColor: kLightSecondaryColor,
                                      side: BorderSide(color: kDarkColor),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(vertical: -4),
                                      labelStyle: TextStyle(color: kDarkColor, fontSize: 12),),

                                    SizedBox(width: 4,),
                                    Chip(label: Text('Quiet space'),
                                      backgroundColor: kLightSecondaryColor,
                                      side: BorderSide(color: kDarkColor),
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity(vertical: -4),
                                      labelStyle: TextStyle(color: kDarkColor, fontSize: 12),)
                                  ],
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kDarkSecondaryColor,),
                              isThreeLine: true,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ],
                )
            )
          ]
          )
      );
    });
  }
}


class SkibTabView extends StatelessWidget {
  const SkibTabView({super.key, required this.business});

  final SkibbleFoodBusiness business;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SafeArea(
          top: false,
          bottom: false,
          child: CustomScrollView(slivers: [
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverToBoxAdapter(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Skib",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),

                        SizedBox(height: 5,),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: CachedNetworkImageProvider('https://images.unsplash.com/photo-1558203728-00f45181dd84?q=80&w=2974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                                      radius: 18,
                                    ),
                                    SizedBox(width: 5,),

                                    Text('Dragos Gontariu'),
                                  ],
                                ),
                                SizedBox(height: 10,),

                                RatingBarIndicator(
                                  rating: 5,

                                  itemBuilder: (context, index) =>
                                  // CircleAvatar(radius: 3, backgroundColor: kPrimaryColor,),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                    child: Container(
                                      // height: 0,
                                      // width: 20,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          // borderRadius: BorderRadius.circular(8),
                                          shape: BoxShape.circle
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.star_rounded,
                                          size: 15,
                                          color: Colors.white,),
                                      ),
                                    ),
                                  ),
                                  itemCount: 5,
                                  unratedColor: Colors.grey.shade300,
                                  itemSize: 18.0,
                                  direction: Axis.horizontal,
                                ),

                                SizedBox(height: 10,),

                                Row(
                                  children: [
                                    Icon(Icons.camera_alt_outlined, color: Colors.grey.shade400,),

                                    SizedBox(width: 4,),

                                    Text('Tap to add a skib...', style: TextStyle(color: Colors.grey.shade400),)
                                  ],
                                ),


                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),


                        Text(
                          "Trending Skibs",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),

                        SizedBox(height: 10,),

                        SizedBox(
                          height: 210,
                          child: business.googlePlaceDetails!.ratingsAndReviewsList!.isNotEmpty ?
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: business.googlePlaceDetails!.ratingsAndReviewsList!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var ratingAndReview = business.googlePlaceDetails!.ratingsAndReviewsList![index];
                                return SizedBox(
                                  width: 300,
                                  child: Card(
                                    elevation: 1,

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(color: Colors.grey.shade400)
                                    ),
                                    margin: const EdgeInsets.only(right: 15),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 35,
                                                width: 35,
                                                decoration: BoxDecoration(
                                                    image: ratingAndReview.profileImageUrl != null ? DecorationImage(
                                                        image: CachedNetworkImageProvider(ratingAndReview.profileImageUrl!),
                                                        fit: BoxFit.cover
                                                    ) : null,
                                                    shape: BoxShape.circle
                                                  // border: widget.suggestion.googlePlaceDetails!.placeImages!.isNotEmpty ? null:  Border.all()
                                                ),
                                                child: ratingAndReview.profileImageUrl != null ? null : const Icon(Iconsax.reserve, color: kDarkSecondaryColor,),
                                              ),
                                              const SizedBox(width: 10,),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(ratingAndReview.authorName!,
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15),),

                                                    Row(
                                                      children: [
                                                        Text('${ratingAndReview.overallRating!}',
                                                          overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14),),

                                                        const SizedBox(width: 4,),

                                                        RatingBarIndicator(
                                                          rating: ratingAndReview.overallRating!,
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
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0, bottom: 6),
                                            child:  CustomExpandedText(
                                              text: '${ratingAndReview.reviewText}',
                                              onTapShowMore: () {  }, maxLength: 200,

                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                              :
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              child: const Center(
                                  child: Text(
                                    'No reviews yet',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15
                                    ),
                                  )
                              )
                          ),
                        ),

                      ],
                    ),
                  ),
                )
            )
            ]
          )
      );
    });
  }
}


