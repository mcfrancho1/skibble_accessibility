import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/kitchen_group.dart';
import 'package:skibble/models/home_page_model.dart';
import 'package:skibble/services/change_data_notifiers/kitchens_data/kitchen_data.dart';
import 'package:skibble/services/firebase/database/kitchens_database.dart';
import 'package:skibble/services/preferences/preferences.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/shared/no_content_view.dart';
import 'package:skibble/features/kitchens/kitchens_discover_view/kitchen_card.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

import '../../../localization/app_translation.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/change_data_notifiers/feed_data.dart';
import '../../../services/maps_services/geo_locator_service.dart';
import '../kitchen_profile/kitchen_profile_page.dart';
import 'kitchen_search_view.dart';
import 'discover_page_kitchens_list_view.dart';
import 'kitchen_view_more_and_filter_view.dart';


class DiscoverKitchensPreViewFuture extends StatefulWidget {
  const DiscoverKitchensPreViewFuture({Key? key}) : super(key: key);

  @override
  State<DiscoverKitchensPreViewFuture> createState() => _DiscoverKitchensPreViewFutureState();
}

class _DiscoverKitchensPreViewFutureState extends State<DiscoverKitchensPreViewFuture>{


  late Future<DiscoverPageModel?> homePageDataFuture;

  late Future<Address?> userLocationFuture;

  late final Preferences preferences;

  bool _isNotifyButtonClicked = false;

  @override
  void initState() {
    super.initState();

    preferences = Preferences.getInstance();


    var address = Provider
        .of<AppData>(context, listen: false)
        .userCurrentLocation;

    //TODO: Get user location here
    if(address != null) {
      userLocationFuture = Future.value(address);
    }
    else {
      userLocationFuture = GeoLocatorService().getCurrentPositionAddress(context);
    }

    // if(Provider.of<AppData>(context, listen: false).homePageModel == null ) {
    //   homePageDataFuture = Future.delayed(Duration(seconds: 1), () {
    //     return CustomHomePageData().getModel(context);
    //   });
    // }
    // else {
    //   homePageDataFuture = Future.delayed(Duration(milliseconds: 0), () => Provider.of<AppData>(context, listen: false).homePageModel);
    // }

  }


  @override
  Widget build(BuildContext context) {
    _isNotifyButtonClicked = preferences.getIsChefServiceNotifyMeButtonClicked(defaultValue: false)!;

    var result = Provider
        .of<AppData>(context)
        .result;

    var currentUser = Provider
        .of<AppData>(context)
        .skibbleUser;


    var address = Provider
        .of<AppData>(context)
        .userCurrentLocation;

    return FutureBuilder<Address?>(
        future: userLocationFuture,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.none) {
            return Container();
          }
          else if(snapshot.connectionState == ConnectionState.waiting) {
            return Container();
            // DiscoverChefViewShimmer();
          }
          else {
            if(snapshot.hasData) {
              Address? address = snapshot.data!;

              //TODO: Remove Nigeria here later
              // if(address.country == 'Canada') {
              return DiscoverKitchensView(address: address,);
            }
            else {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 150,),
                    Icon(Iconsax.location_slash, size: 30,),
                    SizedBox(height: 20,),
                    Text('Uh Oh!', style: TextStyle(fontSize: 20),),
                    SizedBox(height: 10,),
                    Text('We are unable to get your current location. ', style: TextStyle(fontSize: 15),),

                    SizedBox(height: 8,),

                    ElevatedButton(
                        onPressed: () async {

                          LocationPermission permission = await Geolocator.checkPermission();
                          if(permission == LocationPermission.deniedForever) {
                            CustomDialog(context).showOpenSettingsDialog('Grant Permissions', "In order to give suggestions of nearby kitchens, Skibble needs access to your location.\n\nClick the button below to grant Skibble access to your location.", onConfirm: () async{
                              Navigator.pop(context);
                              await openAppSettings();


                            });
                          }
                          else {
                            setState(() {
                              userLocationFuture = GeoLocatorService().getCurrentPositionAddress(context);

                            });
                          }

                          // CustomDialog(context).showProgressDialog('processing'.tr);



                          // if(userLocationFuture != null) {
                          //   Navigator.pop(context);
                          //
                          //   // CustomDialog(context).showCustomMessage('notification'.tr, '${'youHaveBeenAddedToOurWaitingList'.tr}\n\n${'youWillBeNotifiedOnceWeLaunchInYourLocation'.tr}');
                          // }
                          //
                          // else {
                          //   Navigator.pop(context);
                          //   CustomDialog(context).showErrorDialog('Error', 'unableToAddYouToOurWaitingListAtTheMoment'.tr);
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Iconsax.location, color: kLightSecondaryColor,),
                            SizedBox(width: 8,),
                            Text('Get my location', style: TextStyle(color: kLightSecondaryColor),)
                          ],
                        )
                    )
                  ],
                ),
              );
            }
          }
        }
    );
  }
}


class DiscoverKitchensView extends StatefulWidget {
  final Address address;

  DiscoverKitchensView({required this.address});

  @override
  State<DiscoverKitchensView> createState() => _DiscoverKitchensViewState();
}

class _DiscoverKitchensViewState extends State<DiscoverKitchensView> with TickerProviderStateMixin{

  static const _pageSize = 20;

  final PagingController<int, KitchenGroup> _pagingController =
  PagingController(firstPageKey: 0);


  @override
  void initState() {
      _pagingController.addPageRequestListener((pageKey) {
          _fetchPage(pageKey);
      });

    // else {
    //   final isLastPage = discoverPageRecipes.length < _pageSize;
    //
    //   if (isLastPage) {
    //     _pagingController.appendLastPage(discoverPageRecipes);
    //   }
    //
    //   else {
    //     final nextPageKey = (pageKey + newRecipesGroup.length).toInt();
    //     _pagingController.appendPage(newRecipesGroup, nextPageKey);
    //
    //   }
    // }

    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      var currentUser = Provider
          .of<AppData>(context, listen: false)
          .skibbleUser;

      var discoverPageKitchens = Provider
          .of<KitchensData>(context, listen: false)
          .discoverPageKitchens;
      if (discoverPageKitchens.isEmpty) {
        final newKitchenGroup = await KitchenDatabaseService().getDiscoverPageKitchens(context, widget.address);

        final isLastPage = newKitchenGroup.length < _pageSize;

        if (isLastPage) {
          _pagingController.appendLastPage(newKitchenGroup);
        }

        else {
          final nextPageKey = (pageKey + newKitchenGroup.length).toInt();
          _pagingController.appendPage(newKitchenGroup, nextPageKey);

        }
      }

      else {
        _pagingController.value = PagingState(
          nextPageKey: discoverPageKitchens.length,
          error: null,
          itemList: discoverPageKitchens,
        );
      }


    } catch (error) {
      _pagingController.error = error;
    }
  }

  late NavigatorState _navigator;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //
  //   var model = Provider.of<AppData>(context, listen: false).discoverPageModel;
  //
  //   if(model.topRatedKitchensList == null || model.nearbyKitchensList == null) {
  //     _future = KitchenDatabaseService().getDiscoverPageKitchens(context, widget.address);
  //   }
  //
  //   else {
  //     _future = Future.value(model);
  //   }
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<AppData>(context).discoverPageModel;
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10),
      child: CustomScrollView(
        slivers: [

          SliverAppBar(
            title: Text(
              '${tr.kitchens}',
              style: TextStyle(
                fontSize: 28,
                  color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                fontWeight: FontWeight.w700
              ),
            ),
            pinned: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : Colors.grey.shade300,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                KitchenSearchView(
                                    groupTitle: 'all'
                                )));
                      },
                      icon: Center(
                        child: Icon(
                          Iconsax.search_normal,
                          color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                          size: 25,
                        ),
                      )),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Divider(),
          ),

          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: PagedSliverList<int, KitchenGroup>(
              // showNewPageProgressIndicatorAsGridChild: true,
              // showNewPageErrorIndicatorAsGridChild: false,
              // showNoMoreItemsIndicatorAsGridChild: false,
              // shrinkWrap: true,
              pagingController: _pagingController,
              // physics: BouncingScrollPhysics(),
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 3,
              //     mainAxisSpacing: 2,
              //     crossAxisSpacing: 2,
              // ),
              builderDelegate: PagedChildBuilderDelegate<KitchenGroup>(
                  itemBuilder: (context, item, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${item.groupTitle}'.capitalizeFirst!,
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                              ),

                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) =>
                                            KitchenViewMoreAndFilterView(
                                              kitchenGroup: item,
                                            )));                              },
                                  child: Text('See more'))

                            ],
                          ),
                        ),

                        // SizedBox(height: 20,),

                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
                          child: MediaQuery.removePadding(
                            context: context,
                            removeBottom: true,
                            child: GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: size.width > 600 ? 1 / (0.6) :  1 / (1.4),
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                physics: NeverScrollableScrollPhysics(),
                                // Generate 5 widgets that display their index in the List.
                                children: List.generate( item.userKitchens.length > 4 ? 4 : item.userKitchens.length == 3 ? 2 : item.userKitchens.length, (index) {
                                  return
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) =>
                                                  KitchenProfilePage(
                                                      skibbleUser: item.userKitchens[index])));
                                        },
                                        child: NewDiscoverPageKitchenCard(kitchenUser: item.userKitchens[index],));

                                }
                                )
                            ),
                          ),
                        ),

                        Divider()
                        //CommunityCard(community: item.communities[0],),

                      ],
                    );
                  },
                  firstPageProgressIndicatorBuilder: (context) {
                    return DiscoverPageListViewShimmer();
                  },
                  noItemsFoundIndicatorBuilder: (context) {
                    return NoContentView(message: 'No kitchens found');
                  }
                // newPageProgressIndicatorBuilder: (context) {
                //   return NewExplorePageShimmer();
                // }
              ),
            ),
          ),
        ],
      ),
    );

  }
}
