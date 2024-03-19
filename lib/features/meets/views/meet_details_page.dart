import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/user_image.dart';
import 'package:skibble/features/meets/controllers/meets_privacy_controller.dart';
import 'package:skibble/features/meets/services/database/meets_database.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';

import '../../../services/change_data_notifiers/app_data.dart';
import '../../../services/maps_services/geo_locator_service.dart';
import '../../../utils/constants.dart';
import '../../../utils/custom_navigator.dart';
import '../../../utils/number_display.dart';
import '../../kitchens/controllers/kitchen_controller.dart';
import '../../profile/followers_followings/shared/user_info_card.dart';
import '../controllers/meets_controller.dart';
import '../models/skibble_meet.dart';
import 'components/interested_invited_meet_pals.dart';


class MeetDetailsPage extends StatefulWidget {
  const MeetDetailsPage({Key? key, }) : super(key: key);

  @override
  State<MeetDetailsPage> createState() => _MeetDetailsPageState();
}

class _MeetDetailsPageState extends State<MeetDetailsPage> {

  late final SkibbleMeet meet;
  late NavigatorState _navigator;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    meet = context.read<MeetsController>().selectedMeetForDetails!;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _navigator.context.read<MeetsController>().disposeInterestedUsersInvitedStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _navigator = Navigator.of(context);
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    var distance = GeoLocatorService().getDistance(
      meet.meetLocation!.address.latitude!,
      meet.meetLocation!.address.longitude!,
      currentUserLocation!.latitude!, currentUserLocation.longitude!);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    height: MediaQuery.of(context).size.height / 2.5,
                    width: double.infinity,
                    child:
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(meet.meetImage!,),
                              fit: BoxFit.cover
                            )
                          ),
                        ),

                        IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.black.withOpacity(0.0),
                                    //Colors.black.withOpacity(0.0)
                                  ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    )

                  ),

                  Consumer<MeetsController>(
                    builder: (context, data, child) {
                      return Container(
                          padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(meet.meetTitle,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),

                                        const SizedBox(height: 6,),

                                        Row(
                                          children: [
                                            const Icon(Icons.people_alt_rounded, size: 18,),
                                            const SizedBox(width: 4,),
                                            Text('${meet.maxNumberOfPeopleMeeting}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, ),
                                            ),

                                            const SizedBox(width: 6),
                                            const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                                            const SizedBox(width: 6),

                                            const Icon(Icons.remove_red_eye_rounded, size: 18,),
                                            const SizedBox(width: 4,),
                                            Text('${meet.meetPrivacyStatus.name.capitalizeFirst}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, ),
                                            ),


                                            const SizedBox(width: 6),
                                            const CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                                            const SizedBox(width: 6),

                                            const Icon(Icons.receipt_rounded, size: 18,),
                                            const SizedBox(width: 4,),

                                            Text(meet.meetBillsType == SkibbleMeetBillsType.myTreat ?
                                            'My treat'
                                                :
                                            meet.meetBillsType == SkibbleMeetBillsType.meetPalsTreat ?
                                            'Meet pals treat'
                                                :
                                            meet.meetBillsType == SkibbleMeetBillsType.split ?
                                            'Split bills'
                                                :
                                            meet.meetBillsType == SkibbleMeetBillsType.random ?
                                            'Random'
                                                :
                                            'On the table',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14,),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    color: kLightSecondaryColor,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
                                      child: Column(
                                        children: [
                                          Text(
                                            DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime)).toUpperCase(),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),

                                          Text(
                                            DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime)),
                                            style: const TextStyle(fontWeight: FontWeight.bold),

                                          ),

                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),

                              const Divider(),

                              const SizedBox(height: 10,),

                              Row(
                                children: [
                                  UserImage(width: 30, height: 30, user: meet.meetCreator,),
                                  const SizedBox(width: 10,),
                                  RichText(
                                      text: TextSpan(
                                          children: [
                                            const TextSpan(text: 'Created by ', style: TextStyle(color: Colors.grey)),
                                            TextSpan(
                                                text: meet.meetCreator.fullName!,
                                                style: const TextStyle(color: kDarkSecondaryColor, decoration: TextDecoration.underline),
                                              recognizer: TapGestureRecognizer()..onTap = () {
                                                // Single tapped.
                                                CustomNavigator().navigateToProfile(meet.meetCreator, context);

                                              },
                                            )
                                          ]
                                      )
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: const Icon(Iconsax.calendar_1, color: Colors.grey,)),
                                  const SizedBox(width: 10,),
                                  Text(
                                    '${DateFormat('EEE, dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))} at ${DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(meet.meetDateTime))}',
                                    style: const TextStyle(),
                                  ),

                                ],
                              ),

                              const SizedBox(height: 10,),
                              Row(
                                children: [
                                  Container(
                                      height: 30,
                                      width: 30,
                                      child: const Icon(Iconsax.location, color: Colors.grey,)),
                                  const SizedBox(width: 10,),
                                  Text(
                                    '${meet.meetLocation!.address.city}, ${meet.meetLocation!.address.stateOrProvince}',
                                    style: const TextStyle(),
                                  ),
                                ],
                              ),


                              if((meet.interestedUsers ?? []).isNotEmpty)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InterestedInvitedMeetPals(index: 0,)));
                                    },
                                    child: Row(
                                      children: [
                                        // SizedBox(width: 5),

                                        FlutterImageStack.widgets(
                                          children: (meet.interestedUsers ?? []).map((e) => UserImage(width: 28, height: 28, user: e, showStoryWidget: false, margin: EdgeInsets.zero, showUserColor: true,)).toList(),
                                          showTotalCount: true,
                                          totalCount: (meet.interestedUsers ?? []).length,
                                          itemRadius: 35, // Radius of each images
                                          itemCount: 3, // Maximum number of images to be shown in stack
                                          itemBorderWidth: 3, // Border width around the images
                                          itemBorderColor: kLightSecondaryColor,
                                        ),

                                        Expanded(child: Text('${(meet.interestedUsers ?? []).length > 3 ? ' meet pals asked to join this meet' : ' asked to join this meet'}', maxLines: 1,))


                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(),
                              const SizedBox(height: 10),

                              if((meet.invitedUsers ?? []).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Invited',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),

                                    const SizedBox(height: 8,),

                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      elevation: 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Column(
                                              children: List.generate(meet.invitedUsers!.length > 3 ? 3 : meet.invitedUsers!.length, (index) => Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: UserInfoCard(
                                                          user: meet.invitedUsers![index],
                                                          navigationString: 'profile',
                                                          size: 35,
                                                          showUserCustomColor: true,
                                                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                        ),
                                                      ),

                                                      if(meet.meetCreator.userId ==  meet.invitedUsers![index].userId)
                                                        const Text('Creator', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),)
                                                    ],
                                                  ),

                                                    if(index != meet.invitedUsers!.length - 1)
                                                      const Divider(),
                                                ],
                                              )
                                              ),
                                            ),


                                            if(meet.invitedUsers!.length > 3)
                                              Column(
                                                children: [

                                                  TextButton(

                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const InterestedInvitedMeetPals(index: 1,)));

                                                      },
                                                      child: const Text('show more', style: TextStyle(color: kPrimaryColor),))
                                                ],
                                              )
                                          ],
                                        ),
                                      ),

                                    ),

                                    const SizedBox(height: 20),
                                  ],
                                ),

                              const Text(
                                'About',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8,),


                              Text(
                                '${meet.meetDescription}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),

                              const Divider(),


                              const SizedBox(height: 20),

                              const Text(
                                'Location',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 8,),

                              GestureDetector(
                                onTap: () async{
                                  await KitchenController().fetchKitchenFromGoogle(context, meet.meetLocation!.address.googlePlaceId!);

                                },
                                child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                  color: kLightSecondaryColor,
                                  margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              Text(meet.meetLocation!.googlePlaceDetails!.name!,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                                                child: Row(
                                                  children: [

                                                    if(meet.meetLocation!.googlePlaceDetails!.priceLevel != null)
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: List.generate(5, (index) =>
                                                                Text(
                                                                  '\$',
                                                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                                                  style: TextStyle(fontSize: 12, color: index < meet.meetLocation!.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
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
                                                      '${NumberDisplay(decimal: 0).displayDelivery(distance)}m ',
                                                      // '${(suggestion.yelpBusinessDetails!.distance! / 1000).toStringAsFixed(1)}km',
                                                      maxLines: 1, overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontSize: 12, color: Color(0xFF939393)),
                                                    ),

                                                  ],
                                                ),
                                              ),

                                              Row(
                                                children: [
                                                  RatingBarIndicator(
                                                    rating: meet.meetLocation!.googlePlaceDetails!.rating ?? 0,
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
                                                    ' (${NumberDisplay().displayDelivery(meet.meetLocation!.googlePlaceDetails!.userRatingCount ?? 0)})',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),

                                        Material(
                                          elevation: 2,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10)
                                          ),
                                          child: SizedBox(
                                            height: 60,
                                              width: 60,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(10),

                                                ),
                                                child: const Center(
                                                    child: Icon(Iconsax.reserve, color: Colors.grey,)),
                                              ),
                                          ),
                                        )


                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),

                      );
                    }
                  ),
                ],
              ),
            ),
          ),

          Positioned(
              top: 60,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {

                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close_rounded, color: kLightSecondaryColor,)),

                  GestureDetector(
                      onTap: () async{

                        await MeetsBottomSheets().showMeetMenuOptionsSheet(context, meet);
                      },
                      child: const Icon(Iconsax.more, color: kLightSecondaryColor,)),
                ],
              )
          ),

          //button
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

                  meet.meetCreator.userId == currentUser.userId ?
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () async{
                        context.read<MeetsController>().handleMeetDelete(context, meet, currentUser);
                        // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));
                      },

                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10))
                          ),
                        backgroundColor: Colors.grey.shade200,
                        elevation: 0,
                      ),

                      child: Text(
                        'Delete meet',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ),
                  )
                      :

                  meet.meetPrivacyStatus == SkibbleMeetPrivacyStatus.private ?
                  Consumer<MeetsController>(
                      builder: (context, data, child) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async{
                              // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));

                              await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                                backgroundColor: kLightSecondaryColor,
                                elevation: 0.5
                            ),

                            child: Consumer<MeetsPrivacyController>(
                              builder: (context, data, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      data.meetPalPrivateMeetChoice == SkibbleMeetMeetPalPrivateMeetChoice.going ? 'You are going':'Tap to make a decision',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkSecondaryColor),
                                    ),

                                    const SizedBox(width: 8,),

                                    if(data.meetPalPrivateMeetChoice == SkibbleMeetMeetPalPrivateMeetChoice.going)
                                      Icon(data.meetPalPrivateMeetChoice == SkibbleMeetMeetPalPrivateMeetChoice.going? CupertinoIcons.hand_thumbsup_fill : CupertinoIcons.hand_thumbsdown_fill, color: kPrimaryColor,)
                                ],
                                );
                              }
                            ),
                          ),
                        );

                      }
                  )
                      :
                  Consumer<MeetsController>(
                    builder: (context, data, child) {
                      if(data.getMeetStatus(meet) == SkibbleMeetStatus.nearby) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async{
                              // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));
                              await context.read<MeetsController>().askToJoinMeet(meet, currentUser, context);

                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                            ),

                            child: const Text(
                              'Ask to Join',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        );
                      }
                      else if(data.getMeetStatus(meet) == SkibbleMeetStatus.pending) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async{
                              await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                              // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              backgroundColor: Colors.grey.shade200,
                              elevation: 1
                            ),

                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Icon(Icons.pending, size: 18, color: Colors.grey,),
                                SizedBox(width: 5,),
                                Text(
                                  'Waiting for invite',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
                                ),

                              ],
                            ),
                          ),
                        );
                      }
                      else if(data.getMeetStatus(meet) == SkibbleMeetStatus.upcoming) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async{
                              // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));

                              await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                ),
                              backgroundColor: kLightSecondaryColor,
                              elevation: 0.5
                            ),

                            child: const Text(
                              'You are invited!',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkSecondaryColor),
                            ),
                          ),
                        );
                      }
                      else if(data.getMeetStatus(meet) == SkibbleMeetStatus.ongoing) {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () async{
                              // await AudioPlayer().play(AssetSource('sounds/skibble_wine_glass_clink.mp3'));
                              await context.read<MeetsController>().handleLeaveMeet(meet, currentUser, context);

                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                            ),

                            child: const Text(
                              'Ongoing',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        );
                      }

                      else {
                        return Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: null,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(10))
                                )
                            ),

                            child: const Text(
                              'Completed',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        );
                      }
                    }
                  ),

                ],
              ),
            ),
          )

        ],
      ),
      // backgroundColor: Colors.white,
    );
  }
}


class MeetDetailsPageFuture extends StatefulWidget {
  const MeetDetailsPageFuture({Key? key, required this.meetId}) : super(key: key);
  final String meetId;

  @override
  State<MeetDetailsPageFuture> createState() => _MeetDetailsPageFutureState();
}

class _MeetDetailsPageFutureState extends State<MeetDetailsPageFuture> {
  late final Future<SkibbleMeet>? meetFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    meetFuture = MeetsDatabase().getMeetInfo(widget.meetId).then((value) {
      context.read<MeetsController>().initMeetDetails(value!, context);
      return value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SkibbleMeet>(
      future: meetFuture,
      builder: (context, snapshot) {
        switch(snapshot.connectionState) {

          case ConnectionState.none:
          case ConnectionState.waiting:
            return Scaffold(body: Container());
          case ConnectionState.active:
          case ConnectionState.done:
            if(snapshot.hasData) {
              return const MeetDetailsPage();
            }
            else {
              return Scaffold(body: Container());
            }
        }
      }
    );
  }
}
