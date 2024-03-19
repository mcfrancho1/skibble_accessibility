import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/meets/models/nearby_meets_stream.dart';
import 'package:skibble/features/meets/services/database/meets_database.dart';
import 'package:skibble/utils/constants.dart';
import 'package:sliding_up_panel2/sliding_up_panel2.dart';
import '../../../config.dart';
import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/maps_services/geo_locator_service.dart';
import '../../../shared/custom_web_view.dart';
import '../../../utils/current_theme.dart';
import '../../identity_verification/views/verify_user_info_view.dart';
import '../controllers/meets_controller.dart';
import '../controllers/meets_map_controller.dart';
import '../models/completed_meets_stream.dart';

import 'components/meets_page_header.dart';
import 'meet_page_components/completed_meets_list_view.dart';
import 'meet_page_components/created_meets_list_view.dart';
import 'meet_page_components/nearby_meets_list_view.dart';
import 'meet_page_components/ongoing_meets_list_view.dart';
import 'meet_page_components/pending_meets_list_view.dart';
import 'meet_page_components/upcoming_meets_view.dart';



class MeetPageWrapper extends StatelessWidget {
  const MeetPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    return const MeetsPage();

    //
    // if(currentUser.isUserVerified) {
    //   return const MeetsPage();
    // }
    //
    // else {
    //   return const VerifyUserInfoView();
    // }

  }
}



class MeetsPage extends StatefulWidget {
  const MeetsPage({Key? key}) : super(key: key);

  @override
  State<MeetsPage> createState() => _MeetsPageState();
}

class _MeetsPageState extends State<MeetsPage> with AutomaticKeepAliveClientMixin{

  Future? userLocationFuture;

  double _panelHeightOpen = 0;
  double _panelHeightClosed = 90.0;


  @override
  void initState() {
    // TODO: Make sure we have the user location
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    Size size = MediaQuery.of(context).size;
    _panelHeightOpen = size.height - 80;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MeetsMapController(),),

          StreamProvider<NearbyMeetsStream>.value(
            initialData: NearbyMeetsStream([]),
            value: MeetsDatabase().streamNearbyMeets(currentUser),
          ),


          StreamProvider<CompletedMeetsStream>.value(
            initialData: CompletedMeetsStream([]),
            value: MeetsDatabase().streamCompletedMeets(currentUser),
          ),


        ],
        child: currentUserLocation != null ? Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
            // ConnectMapGL(),
            // NewConnectMap(),
            ///
            // const MeetsMapView(),
            ///
            ///

            SlidingUpPanel(
                maxHeight: _panelHeightOpen,
                // minHeight: _panelHeightClosed,
                minHeight: _panelHeightOpen,
                // snapPoint: 0,
                parallaxEnabled: true,
                parallaxOffset: .5,
                color: kContentColorLightTheme,
                defaultPanelState: PanelState.OPEN,
                controller: context.read<MeetsController>().panelController,
                scrollController: context.read<MeetsController>().scrollController,
                panelBuilder: () => const MeetsSlidingPanel(),
                header: ForceDraggableWidget(
                  child: SizedBox(
                    width: size.width,
                    height: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12.0))),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0)),
                onPanelSlide: (double pos) {
                  if(pos > 0.3) {
                    context.read<MeetsController>().isBottomSheetVisible = true;
                  }
                  else {
                    context.read<MeetsController>().isBottomSheetVisible = false;

                  }
                  // setState(() {
                  //   _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) +
                  //       _initFabHeight;
                  // });
                }
            ),

            // the fab
            // Positioned(
            //   right: 20.0,
            //   bottom: _fabHeight,
            //   child: FloatingActionButton(
            //     onPressed: () {},
            //     backgroundColor: Colors.white,
            //     child: Icon(
            //       Icons.gps_fixed,
            //       color: Theme.of(context).primaryColor,
            //     ),
            //   ),
            // ),

            // Positioned(
            //     top: 0,
            //     child: ClipRRect(
            //         child: BackdropFilter(
            //             filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            //             child: Container(
            //               width: MediaQuery.of(context).size.width,
            //               height: MediaQuery.of(context).padding.top,
            //               color: Colors.transparent,
            //             )
            //         )
            //     )
            // ),
            //the SlidingUpPanel Title

            const Positioned(
                top: 2.0,
                left: 0,
                right: 0,
                child: MeetsPageHeader()
            ),

            // Positioned(
            //   top: 52.0,
            //   child: SizedBox(
            //     width: size.width - 40,
            //     child: TextField(
            //       decoration: InputDecoration(
            //         contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //         border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20),
            //           borderSide: BorderSide(color: kContentColorLightTheme)
            //         ),
            //         filled: true,
            //         // ena
            //         // fillColor: kContentColorLightTheme
            //       ),
            //     ),
            //   ),
            // ),

            ///
            // Consumer<MeetsMapController>(
            //   builder: (context, data, child) {
            //     return Positioned(
            //       left: 0,
            //       right: 0,
            //       bottom: Platform.isIOS ? 120 : 90,
            //       height: 195,
            //       child:GestureDetector(
            //         onTap: ()
            //         {
            //           // context.read<SpotsData>().currentSpotToView = item;
            //           // context.read<SpotsData>().showCurrentSpotInfo(context, item: item);
            //         },
            //         child: Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: Card(
            //             elevation: 5,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             color: kContentColorLightTheme,
            //             child: Padding(
            //               padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 0, top: 15),
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Column(
            //                         crossAxisAlignment: CrossAxisAlignment.start,
            //                         children: [
            //                           Text('popopo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),),
            //                           SizedBox(height: 4,),
            //                           Text('By ${item.host.fullName}', style: TextStyle(fontSize: 13, color: Colors.blueGrey),),
            //                         ],
            //                       ),
            //
            //                       Card(
            //                         elevation: 2,
            //                         shape: RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.circular(8)
            //                         ),
            //                         child: Padding(
            //                           padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
            //                           child: Column(
            //                             children: [
            //                               Text(
            //                                 '${DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(item.spotDateTime)).toUpperCase()}',
            //                                 style: TextStyle(fontWeight: FontWeight.bold),
            //                               ),
            //
            //                               Text(
            //                                 '${DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(item.spotDateTime))}',
            //                                 style: TextStyle(fontWeight: FontWeight.bold),
            //
            //                               ),
            //
            //                             ],
            //                           ),
            //                         ),
            //                       ),
            //
            //
            //                     ],
            //                   ),
            //
            //                   SizedBox(height: 15,),
            //
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                     crossAxisAlignment: CrossAxisAlignment.center,
            //                     children: [
            //                       // ConnectViewFacePile(spot: item,),
            //
            //                       if(item.host.userId != currentUser.userId)
            //                         GestureDetector(
            //                             onTap: () {
            //                               CustomBottomSheetDialog.showSpotConfirmationDialog(item, context);
            //                             },
            //                             child:
            //                             // Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryColor,)
            //
            //                             Container(
            //                                 padding: EdgeInsets.all(8),
            //                                 margin: EdgeInsets.only(right: 6),
            //                                 decoration: BoxDecoration(
            //                                     borderRadius: BorderRadius.circular(10),
            //                                     color: kPrimaryColor
            //                                 ),
            //                                 child: Image.asset(
            //                                   'assets/icons/wave_light.png',
            //                                   width: 30,
            //                                   height: 30,
            //                                 )
            //                               // SvgPicture.asset(
            //                               //   'assets/icons/waving_hand.svg',
            //                               //   width: 25,
            //                               //   height: 25,
            //                               //   color: kLightSecondaryColor,
            //                               // ),
            //                             )
            //                           // Text.rich(
            //                           //   TextSpan(
            //                           //     children: [
            //                           //       TextSpan(text: 'show more', style: TextStyle(color: kPrimaryColor)),
            //                           //       WidgetSpan(
            //                           //         child: Icon(Icons.keyboard_arrow_down_rounded, color: kPrimaryColor,),
            //                           //         alignment: PlaceholderAlignment.middle
            //                           //       ),
            //                           //     ],
            //                           //   ),
            //                           // ),
            //                         )
            //
            //                       // Row(
            //                       //   children: [
            //                       //     Text('View Details'),
            //                       //
            //                       //     Icon(Icons.chevron_right_rounded)
            //                       //   ],
            //                       // )
            //                     ],
            //                   )
            //
            //                   // Row(
            //                   //   children: [
            //                   //     UserImage(width: 30, height: 30, user: item.mealHost)
            //                   //   ],
            //                   // ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     );
            //   },
            // )
            ///Horizontal list view

          ],
        )
            :
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.location_slash, size: 30,),
              const SizedBox(height: 20,),
              const Text('Uh Oh!', style: TextStyle(fontSize: 20),),
              const SizedBox(height: 10,),
              const Text('We are unable to get your current location. ', style: TextStyle(fontSize: 15),),

              const SizedBox(height: 8,),

              ElevatedButton(
                  onPressed: () async {

                    LocationPermission permission = await Geolocator.checkPermission();
                    if(permission == LocationPermission.deniedForever) {

                      CustomBottomSheetDialog.showLocationPermissionSheet(
                          "Click the button below to grant Skibble access to your location.",
                          context);
                      // CustomDialog(context).showOpenSettingsDialog(
                      //     'Grant Permissions',
                      //     "In order to use Spots,\n\nClick the button below to grant Skibble access to your location.",
                      //
                      //     onConfirm: () async{
                      //   Navigator.pop(context);
                      //   await openAppSettings();
                      //
                      // });
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
                  child: const Row(
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
        )
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}

class MeetsSlidingPanel extends StatefulWidget {
  const MeetsSlidingPanel({Key? key}) : super(key: key);

  @override
  State<MeetsSlidingPanel> createState() => _MeetsSlidingPanelState();
}

class _MeetsSlidingPanelState extends State<MeetsSlidingPanel>  with AutomaticKeepAliveClientMixin{

  final List<Widget> panelViews = [
    const NearbyMeetsListView(),
    const UpcomingMeetsListView(),
    const OngoingMeetsListView(),

    const PendingMeetsListView(),
    const CreatedMeetsListView(),
    const CompletedMeetsListView()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var address = Provider
        .of<AppData>(context, listen: false)
        .userCurrentLocation;

    //TODO: Get user location here
    // if(address != null) {
    //   userLocationFuture = Future.value(address);
    // }
    // else {
    //   userLocationFuture = GeoLocatorService().getCurrentPositionAddress(context);
    // }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // context.read<MeetsController>().initMeets(context);

    });

    // panelController.isPanelAnimating

  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<MeetsController>(
      builder: (context, meetsData, child) {
        return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: Column(
              children: [
                const SizedBox(height: 80,),

                Expanded(
                    child: PageView.builder(
                      itemCount: panelViews.length,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return panelViews[meetsData.selectedHeader];
                      },
                      onPageChanged: (page) {
                        meetsData.selectedHeader = page;
                      },

                    ),
                  )
              ],
            )

        );
      }
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ScrollToHideWidget extends StatefulWidget {
  const ScrollToHideWidget({Key? key, required this.child, required this.height, this.duration = const Duration(milliseconds: 200)}) : super(key: key);
  final Widget child;
  final Duration duration;
  final double height;

  @override
  State<ScrollToHideWidget> createState() => _ScrollToHideWidgetState();
}

class _ScrollToHideWidgetState extends State<ScrollToHideWidget> {

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   widget.scrollController.addListener(() {
  //
  //     final direction = widget.scrollController.position.userScrollDirection;
  //
  //     print(direction);
  //     if(direction == ScrollDirection.forward) {
  //       show();
  //     }
  //     else if(direction == ScrollDirection.reverse) {
  //       hide();
  //     }
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   widget.scrollController.removeListener(() { });
  //   super.dispose();
  //
  // }
  //
  // void show() {
  //   if(!isVisible)
  //     setState(() {
  //       isVisible = true;
  //     });
  // }
  //
  // void hide() {
  //   if(isVisible)
  //
  //     setState(() {
  //     isVisible = false;
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Consumer<MeetsController>(
      builder: (context, data, child) {
        return AnimatedContainer(
          duration: widget.duration,
          height: data.isBottomSheetVisible ? widget.height : 0,
          child: Wrap(
            children: [
              widget.child,
            ],
          ));
      }
    );
  }
}


