import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/custom_icons/chef_icons_icons.dart';

import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/shared/no_content_view.dart';
import 'package:skibble/features/kitchens/kitchen_profile/Tabs/description_view_tab.dart';
import 'package:skibble/features/kitchens/kitchen_profile/Tabs/menu_view_tab.dart';
import 'package:skibble/features/kitchens/kitchen_profile/Tabs/recipes_view_tab.dart';
import 'package:skibble/features/kitchens/kitchen_profile/Tabs/review_view_tab.dart';
import 'package:skibble/features/kitchens/kitchen_profile/Tabs/skibs_view_tab.dart';

import 'package:skibble/features/profile/user_profile.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/helper_methods.dart';

import '../../../models/chat_models/chat_message.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/firebase/database/kitchens_database.dart';
import '../../../utils/currency_formatter.dart';
import '../../booking/share_friend_view.dart';
import 'components/featured_container.dart';

class KitchenProfileFuture extends StatefulWidget {
  const KitchenProfileFuture({Key? key, required this.user}) : super(key: key);
  final SkibbleUser user;
  @override
  State<KitchenProfileFuture> createState() => _KitchenProfileFutureState();
}

class _KitchenProfileFutureState extends State<KitchenProfileFuture> {
  Future? future;

  @override
  void initState() {
    if (widget.user.kitchen == null) {
      // future = UserDatabaseService().getUserDoc(widget.user.userId!);
      var user = Provider.of<AppData>(context, listen: false)
          .getUserFromMap(widget.user.userId!);

      if (user != null) {
        future = Future.value(user);
      } else {
        future = UserDatabaseService().getUserDoc(widget.user.userId!, context);
      }
    } else {
      future = Future.value(widget.user);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Scaffold(body: Container());
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                SkibbleUser skibbleUser = snapshot.data as SkibbleUser;
                return KitchenProfilePage(skibbleUser: skibbleUser);
              } else {
                return Scaffold(
                    body: NoContentView(
                        imagePath: 'assets/images/coconut.svg',
                        message: 'Unable to fetch kitchen\'s data'));
              }
          }
        });
  }
}

class KitchenProfilePage extends StatefulWidget {
  const KitchenProfilePage({Key? key, required this.skibbleUser})
      : super(key: key);

  final SkibbleUser skibbleUser;

  @override
  _KitchenProfilePageState createState() => _KitchenProfilePageState();
}

class _KitchenProfilePageState extends State<KitchenProfilePage>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController tabController;
  bool _isScrolled = false;

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
  @override
  void initState() {
    super.initState();
    var currentUser = Provider.of<AppData>(context, listen: false).skibbleUser!;
    if (widget.skibbleUser.kitchen!.receivePrivateMessages &&
        currentUser.userId != widget.skibbleUser.userId) {
      popUpChoices = [
        'Message',
        'View Private Profile',
        'Add to Wishlist',
        'Share'
      ];
      popUpIcons = [
        Iconsax.message,
        Iconsax.user,
        Iconsax.bookmark,
        Iconsax.send_2
      ];
    } else {
      popUpChoices = ['View Private Profile', 'Add to Wishlist', 'Share'];
      popUpIcons = [Iconsax.user, Iconsax.bookmark, Iconsax.send_2];
    }
    tabController = new TabController(length: 5, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_listenToScrollChange);
  }

  handlePopUpChoiceClicked(int v, String currentUserId) async {
    if (popUpChoices.length == 3) {
      switch (v) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfilePageView(
                    userId: widget.skibbleUser.userId!,
                    user: widget.skibbleUser,
                  )));
          break;

        case 1:
          var res = await KitchenDatabaseService().addKitchenToWishlist(
              widget.skibbleUser.userId!, currentUserId, context);
          if (res) {
            CustomDialog(context).showCustomMessage('Added to Wishlist',
                'This kitchen has been added to your wishlist');
          } else {
            CustomDialog(context).showErrorDialog(
                'Error', 'Unable to add kitchen to your wishlist');
          }
          break;

        case 2:
          var value = await showModalBottomSheet<bool>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              isDismissible: true,
              backgroundColor: CurrentTheme(context).isDarkMode
                  ? kDarkSecondaryColor
                  : kLightSecondaryColor,
              builder: (context) {
                return ShareFriendView(
                  // conversationId: conversationId,
                  shareType: ChatMessageType.contact,
                  conversationFriendId: widget.skibbleUser.userId,
                  contentId: widget.skibbleUser.userId!,
                );
              });
          break;
      }
    } else {
      switch (v) {
        case 0:
          HelperMethods()
              .createConversation(context, currentUserId, widget.skibbleUser);
          // AutoScrollers(_scrollController).scrollToBottom();
          // Scrollable.ensureVisible(dataKey.currentContext!);
          break;

        case 1:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfilePageView(
                    userId: widget.skibbleUser.userId!,
                    user: widget.skibbleUser,
                  )));
          break;

        case 2:
          var res = await KitchenDatabaseService().addKitchenToWishlist(
              widget.skibbleUser.userId!, currentUserId, context);
          if (res) {
            CustomDialog(context).showCustomMessage('Added to Wishlist',
                'This kitchen has been added to your wishlist');
          } else {
            CustomDialog(context).showErrorDialog(
                'Error', 'Unable to add kitchen to your wishlist');
          }
          break;

        case 3:
          var value = await showModalBottomSheet<bool>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              isDismissible: true,
              backgroundColor: CurrentTheme(context).isDarkMode
                  ? kDarkSecondaryColor
                  : kLightSecondaryColor,
              builder: (context) {
                return ShareFriendView(
                  // conversationId: conversationId,
                  shareType: ChatMessageType.contact,
                  contentId: widget.skibbleUser.userId!,
                );
              });
          break;
      }
    }
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
            if (d == "Share") {
            } else if (d == "QR code") {}
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
    Size size = MediaQuery.of(context).size;

    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Scaffold(
        backgroundColor: CurrentTheme(context).isDarkMode
            ? kBackgroundColorDarkTheme
            : kContentColorLightTheme,
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: KitchenProfilePageAppBar(
                  skibbleUser: widget.skibbleUser,
                  tabController: tabController,
                ),

                // TabBar(
                //   controller: tabController,
                //   labelColor: kPrimaryColor,
                //   unselectedLabelColor: Colors.grey.withOpacity(0.5),
                //   indicatorColor: kPrimaryColor,
                //   tabs: [
                //     Tab(text: "Overview"),
                //     Tab(text: "Reviews"),
                //     Tab(text: "Photos"),
                //     // Tab(text: "Videos"),
                //   ],
                // ),
                // )
              )
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              //overview
              // KitchenProfileOverviewView(skibbleUser: currentUser.userId == widget.skibbleUser.userId ? currentUser : widget.skibbleUser,),
              // KitchenMenuDisplayFutureView(
              //   user: widget.skibbleUser,
              // ),
              MenuViewTab(),

              //Photos
              // SkibsGridView(
              //   user: widget.skibbleUser,
              // ),
              ReviewViewTab(),

              //menu

              //recipe
              // RecipeGridFutureView(
              //   user: widget.skibbleUser,
              // ),
              SkibsViewTab(),
              //Ratings & Reviews

              RecipeViewTab(),
              // KitchenReviewsView(
              //   user: widget.skibbleUser,
              // ),
              DescriptionViewTab(),

              //Videos
            ],
          ),
        ));
  }

  Widget tabs(Size size) {
    return Container();
  }
}

class RatingRod extends StatelessWidget {
  final String ratingNumber;
  final int totalNumberOfRatings;
  final int totalGroupRating;
  const RatingRod(
      {Key? key,
      required this.totalNumberOfRatings,
      required this.ratingNumber,
      required this.totalGroupRating})
      : super(key: key);

  final rodWidth = 180.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          ratingNumber,
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          width: 5,
        ),
        Container(
          width: rodWidth,
          height: 10,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.withOpacity(0.3)),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: (rodWidth * totalGroupRating) / totalNumberOfRatings,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: kPrimaryColor),
            ),
          ),
        )
      ],
    );
  }
}

class KitchenProfilePageAppBar extends StatefulWidget {
  const KitchenProfilePageAppBar(
      {Key? key, required this.skibbleUser, required this.tabController})
      : super(key: key);

  final SkibbleUser skibbleUser;
  final TabController tabController;

  @override
  State<KitchenProfilePageAppBar> createState() => _KitchenProfilePageAppBarState();
}

class _KitchenProfilePageAppBarState extends State<KitchenProfilePageAppBar> {
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
    if (widget.skibbleUser.kitchen!.receivePrivateMessages &&
        currentUser.userId != widget.skibbleUser.userId) {
      popUpChoices = [
        'Message',
        'View Private Profile',
        'Add to Wishlist',
        'Share'
      ];
      popUpIcons = [
        Iconsax.message,
        Iconsax.user,
        Iconsax.bookmark,
        Iconsax.send_2
      ];
    } else {
      popUpChoices = ['View Private Profile', 'Add to Wishlist', 'Share'];
      popUpIcons = [Iconsax.user, Iconsax.bookmark, Iconsax.send_2];
    }
    // scrollController.addListener(_listenToScrollChange);
  }

  @override
  void dispose() {
    // sticky!.remove();
    super.dispose();
  }

  handlePopUpChoiceClicked(int v, String currentUserId) async {
    if (popUpChoices.length == 3) {
      switch (v) {
        case 0:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfilePageView(
                    userId: widget.skibbleUser.userId!,
                    user: widget.skibbleUser,
                  )));
          break;

        case 1:
          var res = await KitchenDatabaseService().addKitchenToWishlist(
              widget.skibbleUser.userId!, currentUserId, context);
          if (res) {
            CustomDialog(context).showCustomMessage('Added to Wishlist',
                'This kitchen has been added to your wishlist');
          } else {
            CustomDialog(context).showErrorDialog(
                'Error', 'Unable to add kitchen to your wishlist');
          }
          break;

        case 2:
          var value = await showModalBottomSheet<bool>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              isDismissible: true,
              backgroundColor: CurrentTheme(context).isDarkMode
                  ? kDarkSecondaryColor
                  : kLightSecondaryColor,
              builder: (context) {
                return ShareFriendView(
                  // conversationId: conversationId,
                  shareType: ChatMessageType.contact,
                  conversationFriendId: widget.skibbleUser.userId,
                  contentId: widget.skibbleUser.userId!,
                );
              });
          break;
      }
    } else {
      switch (v) {
        case 0:
          HelperMethods()
              .createConversation(context, currentUserId, widget.skibbleUser);
          // AutoScrollers(_scrollController).scrollToBottom();
          // Scrollable.ensureVisible(dataKey.currentContext!);
          break;

        case 1:
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => UserProfilePageView(
                    userId: widget.skibbleUser.userId!,
                    user: widget.skibbleUser,
                  )));
          break;

        case 2:
          var res = await KitchenDatabaseService().addKitchenToWishlist(
              widget.skibbleUser.userId!, currentUserId, context);
          if (res) {
            CustomDialog(context).showCustomMessage('Added to Wishlist',
                'This kitchen has been added to your wishlist');
          } else {
            CustomDialog(context).showErrorDialog(
                'Error', 'Unable to add kitchen to your wishlist');
          }
          break;

        case 3:
          var value = await showModalBottomSheet<bool>(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              isDismissible: true,
              backgroundColor: CurrentTheme(context).isDarkMode
                  ? kDarkSecondaryColor
                  : kLightSecondaryColor,
              builder: (context) {
                return ShareFriendView(
                  // conversationId: conversationId,
                  shareType: ChatMessageType.contact,
                  contentId: widget.skibbleUser.userId!,
                );
              });
          break;
      }
    }
  }

  Size _textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 3,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    var _isScrolled = Provider.of<AppData>(context).isChefProfileScrolled;
    final TextStyle descriptionTextStyle = TextStyle(
      fontSize: 14,
    );
    final Size descriptionTextSize = _textSize(
        widget.skibbleUser.kitchen!.description ?? '', descriptionTextStyle);

    return SliverAppBar(
      expandedHeight: flexibleSpaceHeight + 120,
      elevation: 0,
      automaticallyImplyLeading: false,
      pinned: true,
      stretch: true,
      toolbarHeight: 90,

      backgroundColor: CurrentTheme(context).isDarkMode
          ? kBackgroundColorDarkTheme
          : kContentColorLightTheme,

      // centerTitle: true,
      title: AnimatedOpacity(
        opacity: _isScrolled ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(13)),
                    child: Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: widget.skibbleUser.userCustomColor,
                          image: widget.skibbleUser.profileImageUrl != null
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      widget.skibbleUser.profileImageUrl!),
                                  fit: BoxFit.cover)
                              : null),
                      //TODO: change to cachedImageProvider
                      child: widget.skibbleUser.profileImageUrl == null
                          ? Center(
                              child: Icon(
                              ChefIcons.chef_hat_dark_1,
                              size: 24,
                              color: kLightSecondaryColor,
                            ))
                          : null,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.skibbleUser.fullName!,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: CurrentTheme(context).isDarkMode
                                        ? kLightSecondaryColor
                                        : kDarkSecondaryColor),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            if (widget.skibbleUser.isUserVerified)
                              Icon(
                                Iconsax.verify5,
                                size: 15,
                                color: kPrimaryColor,
                              )
                          ],
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          '@${widget.skibbleUser.userName!}',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            widget.skibbleUser.userId != currentUser.userId
                ? Row(
                    children: [
                      Container(
                          // margin: EdgeInsets.only(top: 15),
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // InkWell(
                          //   onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserBookingView(kitchenUser: widget.skibbleUser,))),
                          //   child: Container(
                          //       padding: EdgeInsets.all(8.0),
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius
                          //               .circular(
                          //               20),
                          //           color: kPrimaryColor
                          //       ),
                          //       child: Text(
                          //         'bookNow'.tr, style: TextStyle(
                          //           fontSize: 16,
                          //           color: kLightSecondaryColor),)
                          //   ),
                          // ),

                          SizedBox(
                            width: 8,
                          ),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Material(
                              color: Colors.transparent,
                              child: PopupMenuButton<int>(
                                color: CurrentTheme(context).isDarkMode
                                    ? kDarkSecondaryColor
                                    : kLightSecondaryColor,
                                onSelected: (v) async {
                                  handlePopUpChoiceClicked(
                                      v, currentUser.userId!);
                                },
                                tooltip: 'viewOptions'.tr,
                                itemBuilder: (BuildContext context) {
                                  // int index = 0;
                                  // List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];

                                  return List.generate(
                                      popUpChoices.length,
                                      (index) => PopupMenuItem<int>(
                                            value: index,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      popUpIcons[index],
                                                      color: CurrentTheme(
                                                                  context)
                                                              .isDarkMode
                                                          ? kLightSecondaryColor
                                                          : kDarkSecondaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      popUpChoices[index],
                                                      style: TextStyle(
                                                        color: CurrentTheme(
                                                                    context)
                                                                .isDarkMode
                                                            ? kLightSecondaryColor
                                                            : kDarkSecondaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  padding: EdgeInsets.all(9.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: CurrentTheme(context).isDarkMode
                                            ? kContentColorLightTheme
                                            : kDarkSecondaryColor,
                                      )),
                                  child: Icon(
                                    Iconsax.more,
                                    size: 18,
                                    color: CurrentTheme(context).isDarkMode
                                        ? kContentColorLightTheme
                                        : kDarkSecondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // TextButton(
                          //   child: Text('Book Now',),
                          //   onPressed: () {},
                          //   style: TextButton.styleFrom(
                          //     // textStyle: TextStyle(fontSize: 14),
                          //     primary: kLightSecondaryColor,
                          //     padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                          //
                          //     backgroundColor: kPrimaryColor,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                          //   ),
                          // ),
                        ],
                      ))
                    ],
                  )
                : Container()
          ],
        ),
      ),
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
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  image: widget.skibbleUser.kitchen!.kitchenCoverImageUrl != null
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(
                            widget.skibbleUser.kitchen!.kitchenCoverImageUrl!,
                          ),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: AssetImage('assets/images/dish.png'),
                          // fit: BoxFit.cover
                        ),
                ),
              ),

              //profile image
              FadeIn(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  //TODO: change to cachedImageProvider
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: widget.skibbleUser.userCustomColor,
                                image: widget.skibbleUser.profileImageUrl !=
                                        null
                                    ? DecorationImage(
                                        image: CachedNetworkImageProvider(widget
                                            .skibbleUser.profileImageUrl!),
                                        fit: BoxFit.cover)
                                    : null),
                            //TODO: change to cachedImageProvider
                            child: widget.skibbleUser.profileImageUrl == null
                                ? Center(
                                    child: Icon(
                                    ChefIcons.chef_hat_dark_1,
                                    size: 50,
                                    color: kLightSecondaryColor,
                                  ))
                                : null,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          widget.skibbleUser.userId != currentUser.userId
                              ? !_isScrolled
                                  ? Container(
                                      // margin: EdgeInsets.only(top: 15),
                                      child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // ElevatedButton(
                                        //   style: ElevatedButton.styleFrom(
                                        //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        //       shape: RoundedRectangleBorder(
                                        //       borderRadius: BorderRadius.circular(20)
                                        //     )
                                        //   ),
                                        //     onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserBookingView(kitchenUser: widget.skibbleUser,))),
                                        //     child: Text('bookNow'.tr,
                                        //   style: TextStyle(
                                        //       fontSize: 16,
                                        //       color: kLightSecondaryColor),)),
                                        //
                                        // SizedBox(width: 8,),
                                        !_isScrolled
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: Material(
                                                  color: Colors.transparent,

                                                  //TODO: change to Popupchoice
                                                  child: PopupMenuButton<int>(
                                                    color: CurrentTheme(context)
                                                            .isDarkMode
                                                        ? kDarkSecondaryColor
                                                        : kLightSecondaryColor,
                                                    onSelected: (v) async {
                                                      handlePopUpChoiceClicked(
                                                          v,
                                                          currentUser.userId!);
                                                    },
                                                    tooltip: 'viewOptions'.tr,
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      int index = 0;
                                                      // List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];

                                                      return List.generate(
                                                          popUpChoices.length,
                                                          (index) =>
                                                              PopupMenuItem<
                                                                  int>(
                                                                value: index,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          popUpIcons[
                                                                              index],
                                                                          color: CurrentTheme(context).isDarkMode
                                                                              ? kLightSecondaryColor
                                                                              : kDarkSecondaryColor,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          popUpChoices[
                                                                              index],
                                                                          style:
                                                                              TextStyle(
                                                                            color: CurrentTheme(context).isDarkMode
                                                                                ? kLightSecondaryColor
                                                                                : kDarkSecondaryColor,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: CurrentTheme(
                                                                          context)
                                                                      .isDarkMode
                                                                  ? kLightSecondaryColor
                                                                  : kDarkSecondaryColor)),
                                                      child: Icon(
                                                        Iconsax.more,
                                                        color: CurrentTheme(
                                                                    context)
                                                                .isDarkMode
                                                            ? kLightSecondaryColor
                                                            : kDarkSecondaryColor,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ))
                                  : Container()
                              : Container(),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      FadeIn(
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          width: size.width / 2,
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.skibbleUser.fullName!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: CurrentTheme(context).isDarkMode
                                          ? kLightSecondaryColor
                                          : kDarkSecondaryColor,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              if (widget.skibbleUser.isUserVerified)
                                Icon(
                                  Iconsax.verify5,
                                  size: 15,
                                  color: kPrimaryColor,
                                )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),

                      !_isScrolled
                          ? FadeIn(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                '@${widget.skibbleUser.userName!}',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            )
                          : Container(),

                      // SizedBox(height: 15,),
                      // Text(
                      //   widget.skibbleUser.chef!.description ?? '',
                      //   maxLines: 3,
                      //   overflow: TextOverflow.ellipsis,
                      //   style: TextStyle(fontSize: 15, ),
                      // ),

                      // IntrinsicDimension(
                      //     listener: (context, width, height, startOffset) {
                      //       setState(() {
                      //         flexibleSpaceHeight  = height;
                      //       });
                      //     },
                      //   builder: (context, width, height, startOffset) {
                      //     // use the height to draw the vertical line
                      //     // in the second frame
                      //     return
                      //   },
                      // ),

                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 14,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            widget.skibbleUser.kitchen!.serviceLocation!.city!,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            // style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.star_outline_rounded,
                            size: 14,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${(widget.skibbleUser.kitchen!.averageRatings!).toStringAsFixed(1)}',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            // style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Iconsax.money_2,
                            size: 14,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(widget.skibbleUser.kitchen!.serviceLocation!.countryCode!)}${widget.skibbleUser.kitchen!.chargeRateString!}',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            // style: TextStyles.bodySm.subTitleColor.bold,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
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
                      // SizedBox(height: 10,),
                      //
                      // Text(
                      //   'Accepts Swift Coins',
                      //   style: TextStyle(
                      //       color: Colors.grey,
                      //       fontSize: 14
                      //   ),
                      //   // style: TextStyles.bodySm.subTitleColor.bold,
                      // ),

                      // Text('Food Specialty', style: TextStyle(
                      //   fontSize: 16,
                      //   color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,)),

                      // SizedBox(height: 15,),

                      // if(widget.skibbleUser.kitchen!.foodSpecialtyList!.isNotEmpty)
                      //   SizedBox(
                      //     height: 40,
                      //     child: ListView.builder(
                      //         itemCount: widget.skibbleUser.kitchen!.foodSpecialtyList!.length,
                      //         // shrinkWrap: true,
                      //         scrollDirection: Axis.horizontal,
                      //         physics: BouncingScrollPhysics(),
                      //         itemBuilder: (context, index) {
                      //           return Center(
                      //             child: Container(
                      //                 padding: EdgeInsets.symmetric(
                      //                     horizontal: 10.0,
                      //                     vertical: 4),
                      //                 margin: EdgeInsets.only(right: 8),
                      //                 decoration: BoxDecoration(
                      //                   borderRadius: BorderRadius
                      //                       .circular(20),
                      //                   border: Border.all(
                      //                       color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : Colors.blueGrey.shade400
                      //                   ),
                      //                   // color: kPrimaryColor
                      //                 ),
                      //                 child:  Text(widget.skibbleUser.kitchen!.foodSpecialtyList![index],
                      //                   style: TextStyle(fontSize: 15,
                      //                       color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : Colors.blueGrey.shade400
                      //                   ),)
                      //             ),
                      //           );
                      //         }),
                      //   ),

                      // Wrap(
                      //     spacing: 10,
                      //     runSpacing: 8,
                      //
                      //     children: List.generate(
                      //       tagsList.length, (index) =>
                      //     index < 10 ? Container(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 10.0,
                      //             vertical: 8),
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius
                      //               .circular(20),
                      //           border: Border.all(
                      //               color: kPrimaryColor),
                      //           // color: kPrimaryColor
                      //         ),
                      //         child: index != 9
                      //             ? Text(tagsList[index],
                      //           style: TextStyle(fontSize: 13,
                      //               color: kPrimaryColor),)
                      //             : Text(
                      //           'More...', style: TextStyle(
                      //             fontSize: 13,
                      //             color: kPrimaryColor),)
                      //     ) : Container(),
                      //     )
                      // )
                    ],
                  ),
                ),
              ),
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
            // text: "Explore",
            icon: Icon(Icons.restaurant_menu_rounded),
          ),
          Tab(
            // text: "Explore",
            icon: Icon(Icons.star_border_outlined),
          ),
          Tab(
            // text: "Explore",
            icon: Icon(Iconsax.video_play),
          ),

          Tab(
            // text: "Explore",
            icon: Icon(Iconsax.book_1),
          ),

          Tab(
            // text: "Explore",
            icon: Icon(Iconsax.star_1),
          ),
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
