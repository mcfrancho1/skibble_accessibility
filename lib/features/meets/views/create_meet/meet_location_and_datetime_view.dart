import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_date_time_controller.dart';
import 'package:skibble/features/meets/controllers/meets_location_controller.dart';

import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../services/maps_services/geo_locator_service.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/number_display.dart';
import '../../../../utils/validators.dart';
import '../../utils/meets_bottom_sheets.dart';
import '../components/max_number_of_people_slider.dart';

class MeetLocationAndDateTimeView extends StatefulWidget {
  const MeetLocationAndDateTimeView({Key? key}) : super(key: key);

  @override
  State<MeetLocationAndDateTimeView> createState() => _MeetLocationAndDateTimeViewState();
}

class _MeetLocationAndDateTimeViewState extends State<MeetLocationAndDateTimeView> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var currentUserLocation = Provider.of<AppData>(context).userCurrentLocation;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Consumer<CreateEditMeetsController>(
          builder: (context, data, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Where and When?',
                  style: TextStyle(
                      color: kDarkSecondaryColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold
                  ),
                ),

                SizedBox(height: 15,),

                Text(
                  'Choose the restaurant/cafe where this meet will take place. Decide on the time based on the available opening hours.',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13
                  ),
                ),

                SizedBox(height: 15,),

                Text(
                  'Where',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14
                  ),
                ),

                SizedBox(height: 10,),

                Consumer<CreateEditMeetsController>(
                  builder: (context, data, child) {

                    if(data.foodBusinessForMeetLocation == null) {
                      return GestureDetector(
                        onTap: () {
                          MeetsBottomSheets().showMeetsLocationPickerSheet(context);

                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: DottedBorder(
                            radius: const Radius.circular(10),
                            borderType: BorderType.RRect,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            color: Colors.grey,
                            dashPattern: const [4, 2],
                            strokeCap: StrokeCap.round,
                            child: Text('Tap to select location and time', style: TextStyle(color: Colors.grey.shade600),),
                          ),
                        ),
                      );
                    }
                    else {
                      var distance = GeoLocatorService().getDistance(
                          data.foodBusinessForMeetLocation!.googlePlaceDetails!.latitude!,
                          data.foodBusinessForMeetLocation!.googlePlaceDetails!.longitude!,
                          currentUserLocation!.latitude!, currentUserLocation.longitude!);

                      return Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
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
                                            image: data.foodBusinessForMeetLocation!.googlePlaceDetails!.placeImages!.isNotEmpty ? DecorationImage(
                                                image: CachedNetworkImageProvider(data.foodBusinessForMeetLocation!.googlePlaceDetails!.placeImages![0]!),
                                                fit: BoxFit.cover
                                            ) : null,
                                            borderRadius: BorderRadius.circular(10),
                                            // border: data.foodBusinessForMeetLocation!.googlePlaceDetails!.placeImages!.isNotEmpty ? null:  Border.all()
                                          ),
                                          child: data.foodBusinessForMeetLocation!.googlePlaceDetails!.placeImages!.isNotEmpty ? null : Icon(Iconsax.reserve, color: kDarkSecondaryColor,),
                                        ),
                                      ),
                                      SizedBox(width: 15,),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(data.foodBusinessForMeetLocation!.googlePlaceDetails!.name!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16),),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                                              child: Row(
                                                children: [

                                                  if(data.foodBusinessForMeetLocation!.googlePlaceDetails!.priceLevel != null)
                                                    Row(
                                                      children: [
                                                        Row(
                                                          children: List.generate(5, (index) =>
                                                              Text(
                                                                '\$',
                                                                maxLines: 1, overflow: TextOverflow.ellipsis,
                                                                style: TextStyle(fontSize: 12, color: index < data.foodBusinessForMeetLocation!.googlePlaceDetails!.priceLevel! ? kPrimaryColor: Colors.grey.shade300),
                                                              ),),
                                                        ),
                                                        SizedBox(width: 5,),
                                                        CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                                                        SizedBox(width: 5,),
                                                      ],
                                                    ),
                                                  Text(
                                                    '${NumberDisplay(decimal: 0).displayDelivery(distance)}'.length > 3 ?
                                                    '${NumberDisplay(decimal: 1).displayDelivery(distance / 1000)}km'
                                                        :
                                                    '${NumberDisplay(decimal: 0).displayDelivery(distance)}m',
                                                    // '${(suggestion.yelpBusinessDetails!.distance! / 1000).toStringAsFixed(1)}km',
                                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(fontSize: 12, color: Color(0xFF939393)),
                                                  ),
                                                  const SizedBox(width: 5,),
                                                  CircleAvatar(radius: 2, backgroundColor: Colors.grey,),
                                                  SizedBox(width: 5,),
                                                  Expanded(
                                                      child: Text(
                                                        '${data.foodBusinessForMeetLocation!.googlePlaceDetails!.city ?? ''}, '
                                                            '${data.foodBusinessForMeetLocation!.googlePlaceDetails!.stateOrProvince ?? ''}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(fontSize: 12, color: Color(0xFF939393)),
                                                      )
                                                  ),

                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),
                                InkWell(

                                  child: Icon(Iconsax.edit),
                                  onTap: () async {
                                    MeetsBottomSheets().showMeetsLocationPickerSheet(context);

                                  },
                                )
                              ],
                            )
                          ],
                        ),
                      );

                    }

                  }
                ),

                SizedBox(height: 25,),


                Consumer2<CreateEditMeetsController, MeetsDateTimeController>(
                    builder: (context, data, date, child) {
                      if(data.meetDateTime == null) {
                        return Container();
                      }
                      else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'When',
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14
                              ),
                            ),

                            const SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Card(
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        margin: EdgeInsets.zero,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 11.0, vertical: 8),
                                          child: Column(
                                            children: [
                                              Text(
                                                DateFormat('MMM').format(DateTime.fromMillisecondsSinceEpoch(data.meetDateTime!.millisecondsSinceEpoch)).toUpperCase(),
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),

                                              Text(
                                                DateFormat('dd').format(DateTime.fromMillisecondsSinceEpoch(data.meetDateTime!.millisecondsSinceEpoch)),
                                                style: const TextStyle(fontWeight: FontWeight.bold),

                                              ),

                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 15,),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(
                                              '${DateFormat('EEEE, dd MMM yyyy').format(data.meetDateTime!)}',

                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 6.0, bottom: 6),
                                              child: Text(
                                                'at ${DateFormat('hh:mm a').format(data.meetDateTime!)}',
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 20,),
                                InkWell(

                                  child: Icon(Iconsax.edit),
                                  onTap: () async{
                                    await MeetsBottomSheets().showMeetsDateTimePickerSheet(context, data.foodBusinessForMeetLocation!, false);

                                  },
                                )
                              ],
                            ),
                          ],
                        );
                      }
                    }
                ),


                if(data.foodBusinessForMeetLocation != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25,),
                      Text(
                        'Meet Pals',
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14
                        ),
                      ),
                      SizedBox(height: 10,),

                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade300)
                        ),
                        child: Column(
                          children: [


                            SizedBox(height: 10),


                            Padding(
                              padding: const EdgeInsets.only(right: 8.0, bottom: 10),
                              child: MaxNumberOfPeopleSlider(
                                onChanged: (double value) {
                                  context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet = value;
                                },
                                initialValue: context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet,
                                maxValue: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 6),

                      const Text('This is the number of pals you want to meet on the table.', style: TextStyle(color: Colors.grey, fontSize: 12),)
                      //
                      // MaxNumberOfPeopleSlider(
                      //   initialValue: context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet,
                      //   onChanged: (double value ) {
                      //     context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet = value;
                      //   },)
                    ],
                  )
                // Text(
                //   'Meet Date & Time',
                //   style: TextStyle(
                //       color: Colors.grey.shade700,
                //       fontSize: 14
                //   ),
                // ),
                //
                // SizedBox(height: 10,),
              ],
            );
          }
      ),
    );
  }
}