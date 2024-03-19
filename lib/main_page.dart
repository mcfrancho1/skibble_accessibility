import 'package:extended_image/extended_image.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart' as cu;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble_accessibility/models/address.dart';
import 'package:skibble_accessibility/services/change_data_notifiers/app_data.dart';
import 'package:skibble_accessibility/services/firebase/database/user_database.dart';
import 'package:skibble_accessibility/services/maps_services/geo_locator_service.dart';
import 'package:skibble_accessibility/services/preferences/preferences.dart';
import 'package:skibble_accessibility/utils/constants.dart';
import 'package:skibble_accessibility/utils/current_theme.dart';

import 'features/meets/views/meets_page.dart';
import 'features/skibs/components/view_or_comment_post.dart';
import 'lang/localizations.dart';
import 'localization/app_translation.dart';
import 'main_page_bottom_sheet_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({required String tab, Key? key, this.uri,}): super(key: key);

  final Uri? uri;
  @override
  State<MainPage> createState() => _MainPageState();

}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {


  late PageController _pageController;
  int _selectedPage = 0;
  Uri? uriLink;

  // StreamController? stream;

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      _pageController.jumpToPage(index);
      // switch (index) {
      //   case 0:
      //     context.go('/${AppRoute.feed.name}');
      //     break;
      //   case 1:
      //     context.go('/${AppRoute.explore.name}');
      //     break;
      //   case 2:
      //     context.go('/${AppRoute.market.name}');
      //     break;
      //   case 3:
      //     context.go('/${AppRoute.currentUserProfile.name}');
      //     break;
      // }
    });
  }


  List<Widget> bodyDisplays = [];
  List<String> bodyDisplayText = [];
  List<IconData> bodyDisplayIcons = [];


  @override
  void initState() {
    // TODO: implement initState
    _selectedPage = 0;



    uriLink = widget.uri;
    var address = Provider
        .of<AppData>(context, listen: false)
        .userCurrentLocation;

    var user = Provider.of<AppData>(context, listen: false).skibbleUser!;

    // NotificationController.initializeNotificationsEventListeners(context);


     streamDynamicLinks(uriLink);

     WidgetsBinding.instance.addPostFrameCallback((_) {
       // Provider.of<LoadingController>(context, listen: false).isLoading = false;

     });

    //TODO: Get user location here
    if(address == null) {
      GeoLocatorService().getCurrentPositionAddress(context).then((value) async{
        if(value != null) {
          var user = Provider.of<AppData>(context, listen: false).skibbleUser!;
          UserDatabaseService().updateUserCurrentLocation(user.userId!, value as Address);
        }
      });
    }

    _pageController = PageController(initialPage: 0);

    bodyDisplays = [
       Container(),
      // const MeetsPage(),
       MeetPageWrapper(),
      // const NewExplorePageFuture(),
      // const DiscoverPageView(),
       Container(),
      // ChefProfilePage(skibbleUser: user),
      // const KitchensView(),
       Container(),
      // ChatPage(),
        // DiscoverPage(),
        // CameraPage(),
       Container(),
    ];

    bodyDisplayText = [
      tr.home,
      'Meets',
      // tr.explore,
      'Communities',
      // tr.kitchens,
      tr.chats,
      tr.profile,
      // tr.profile,
      // AppLocalization.of(context).getTranslatedValue('feed')!,
      // AppLocalization.of(context).getTranslatedValue('explore')!,
      // AppLocalization.of(context).getTranslatedValue('market')!,
      // AppLocalization.of(context).getTranslatedValue('profile')!,
      // 'feed'.tr,
      // 'explore'.tr,
      // 'market'.tr,
      // 'profile'.tr
    ];

    bodyDisplayIcons = [
       // Iconsax.home_1, Iconsax.flash_1, Iconsax.shop,
      Iconsax.home_1,
      cu.CupertinoIcons.flame,
      // Iconsax.flash_1,
      Iconsax.people,
      Iconsax.message,
    ];

    var preferences = Preferences.getInstance();

    // if(!preferences.getFirstTimeEmailVerifiedKey()!) {
    //     if(user.isEmailVerified! && user.profileImageUrl == null) {
    //       WidgetsBinding.instance.addPostFrameCallback((_) async {
    //         CustomDialog(context).showWelcomeMessage(
    //             tr.welcome,
    //             'Thank you for registering on Skibble.\n\nTo get started, add a profile photo so that other skibblers can easily find you.\n\nHope you have the best food experiences ever!'
    //         );
    //       });
    //
    //     }
    //     else if(user.isASkibbleRegisteredChef) {
    //       CustomDialog(context).showWelcomeMessage(
    //           tr.welcome,
    //           'Thank you for registering on Skibble.\n\nTo get started, set up your payments profile by clicking on "Profile", then selecting "Earnings".'
    //       );
    //     }
    //
    //     preferences.setFirstTimeEmailVerifiedKey(true);
    //   }
    //

    super.initState();

    WidgetsBinding.instance.addObserver(this);
    //_setUpCamera();
  }
  String value = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _selectedPage = widget.index;

  }


  ///THis handles the action of setting our user active status in the database
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   String? userId = Preferences.getInstance().getCurrentUserIdKey();
  //
  //   if (state == AppLifecycleState.resumed) {
  //     ///Set the user status to online
  //     if(userId != null) {
  //       UserDatabaseService().updateUserActiveStatus(userId, true);
  //     }
  //   }
  //   else {
  //     ///Set the user status to offline
  //     ///This is also called in the sign out action of the user
  //     if(userId != null) {
  //
  //       int timestamp = DateTime.now().millisecondsSinceEpoch;
  //
  //       UserDatabaseService().updateUserActiveStatus(userId, false, timeLastActive: timestamp);
  //
  //     }
  //
  //   }
  // }

  streamDynamicLinks(Uri? link) {
    try {
      //  FirebaseDynamicLinks.instance.getInitialLink().then((value) {
      //    if(value != null) {
      //      Uri deepLink = value.link;
      //      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPostFuture(postId: deepLink.queryParameters['id']!)));
      //
      //    }
      //   return value;
      // });

      FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
        //Navigator.pushNamed(context, dynamicLinkData.link.path);

        Uri deepLink = dynamicLinkData.link;


        switch(deepLink.queryParameters['type']) {
          case 'skib':
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPostScreen(postId: deepLink.queryParameters['id']!, isFromFeedScreen: false,)));
            break;

          case 'community':
            // context.read<CommunityController>().navigateToCommunityUsingId(context, deepLink.queryParameters['id']!);
            break;

        }

        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewPostFuture(postId: deepLink.queryParameters['id']!)));

      }).onError((error) {
        // Handle errors
        debugPrint(error);
      });
    }
    catch(e) {

      debugPrint(e.toString());
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    // AwesomeNotifications().actionSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var result = Provider.of<AppData>(context).result;
    var user = Provider.of<AppData>(context).skibbleUser!;


    Provider.of<AppData>(context).isThemeChanged;
    var size = MediaQuery
        .of(context)
        .size;

    value = result;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor:  CurrentTheme(context).isDarkMode ?  kBackgroundColorDarkTheme : kContentColorLightTheme,
        body: PageView(
            onPageChanged: (index) => setState(() { _selectedPage = index; }),
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [...bodyDisplays]
        ),
        floatingActionButton: SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kPrimaryColor,
              foregroundColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kLightSecondaryColor,
              isExtended: true,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              extendedPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              onPressed: () async{

                // throw StateError('Another here');
                await showModalBottomSheet<bool>(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                    ),
                    isDismissible: true,
                    backgroundColor:  kLightSecondaryColor,
                    builder: (context) {
                      return const MainPageBottomView();
                    });
              },
              label: const Text('Create'),
            ),
          ),
        ),
        // bottomNavigationBar: CurvedFlashyTabBar(
        //   selectedIndex: _selectedPage,
        //   elevation: 5,
        //   newMessagesCount: '0',
        //   shape: CircularNotchedRectangle(),
        //   backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,
        //   onItemSelected: (index) => _onItemTapped(index),
        //   items: [
        //     FlashyTabBarItem(
        //       icon:  Icon(bodyDisplayIcons[0], size: 25),
        //       title: Text(
        //         bodyDisplayText[0],),
        //       activeColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
        //     ),
        //
        //     FlashyTabBarItem(
        //       icon: Icon(bodyDisplayIcons[1], size: 25),
        //       title: Text(bodyDisplayText[1],),
        //       activeColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
        //     ),
        //     FlashyTabBarItem(
        //       icon: Icon(
        //           bodyDisplayIcons[2],
        //           size: 25),
        //       title: Text(bodyDisplayText[2],
        //       ),
        //       activeColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
        //     ),
        //     FlashyTabBarItem(
        //       icon: Icon(
        //           bodyDisplayIcons[3],
        //           size: 25),
        //       title: Text(bodyDisplayText[3]),
        //       activeColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
        //
        //     ),
        //     FlashyTabBarItem(
        //       title: Text(bodyDisplayText[4]),
        //       activeColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kPrimaryColor,
        //
        //     ),
        //   ],
        // ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(bodyDisplayIcons[0]),
                label: bodyDisplayText[0]
            ),
            BottomNavigationBarItem(
                icon: Icon(bodyDisplayIcons[1]),
                label: bodyDisplayText[1]
            ),

            BottomNavigationBarItem(
                icon: Icon(bodyDisplayIcons[2]),
                label: bodyDisplayText[2]
            ),

            BottomNavigationBarItem(
                icon: Icon(bodyDisplayIcons[3]),
                label: bodyDisplayText[3]
            ),
            BottomNavigationBarItem(
                icon: user.profileImageUrl != null ?

                Container(
                    width: 23.5,
                    height: 23.5,
                    child: ExtendedImage.network(
                      user.profileImageUrl!,
                      width: 23.5,
                      height: 23.5,
                      fit: BoxFit.cover,
                      cache: true,

                      border: Border.all(
                          color: Colors.grey.shade200, width: 1.0),
                      shape: BoxShape.circle,
                      loadStateChanged: (ExtendedImageState state) {
                        switch (state.extendedImageLoadState) {
                          case LoadState.loading:
                          // _controller.reset();
                            return Container(
                              width: 23.5,
                              height: 23.5,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade200,
                                  border: Border.all(color: kPrimaryColor)
                              ),
                            );

                        ///if you don't want override completed widget
                        ///please return null or state.completedWidget
                        //return null;
                        //return state.completedWidget;
                          case LoadState.completed:
                          // _controller.forward();
                            return state.completedWidget;
                        //   ExtendedRawImage(
                        //   image: state.extendedImageInfo?.image,
                        // );
                        // break;
                          case LoadState.failed:
                          // _controller.reset();
                            return GestureDetector(
                              child:  Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/failed.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                  const Positioned(
                                    bottom: 0.0,
                                    left: 0.0,
                                    right: 0.0,
                                    child: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                state.reLoadImage();
                              },
                            );
                        }
                      },
                      // borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      //cancelToken: cancellationToken,
                    )
                  ///
                  // CachedNetworkImage(
                  //   imageUrl: user.profileImageUrl!,
                  //   memCacheWidth: 76,
                  //   memCacheHeight: 76,
                  //   // width: 25,
                  //   // height: 25,
                  //   imageBuilder: (context, imageProvider) {
                  //     return Container(
                  //       width: 25,
                  //       height: 25,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           image: DecorationImage(
                  //               image: imageProvider,
                  //             fit: BoxFit.cover
                  //           )
                  //       ),
                  //     );
                  //   },
                  // ),

                  ///
                  // Container(
                  //   width: 25,
                  //   height: 25,
                  //   decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //
                  //       image: DecorationImage(
                  //           image: CachedNetworkImageProvider(user.profileImageUrl!),
                  //         fit: BoxFit.cover
                  //       )
                  //   ),
                  // ),
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: user.userCustomColor != null ? user.userCustomColor : kPrimaryColor,
                  //   border: Border.all(color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kPrimaryColor)
                  // ),
                )
                    :
                Container(
                  width: 23.5,
                  height: 23.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                    // border: Border.all(color: kPrimaryColor)
                  ),

                  child: Center(
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      // padding: EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                          child: Icon(cu.CupertinoIcons.person_solid, size: 14, color: Colors.grey,)),
                    ),
                  ),
                ),
                label: bodyDisplayText[4]
            ),
          ],
          // elevation: 2,
          currentIndex: _selectedPage,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          unselectedItemColor: Colors.grey,

          // selectedLabelStyle: TextStyle(color: kPrimaryColor, fontSize: 12),
        ),
      );
  }


}
