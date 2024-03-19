
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/skibble_place.dart';
import 'package:skibble/features/meets/controllers/create_edit_meets_controller.dart';
import 'package:skibble/features/meets/controllers/meets_date_time_controller.dart';
import 'package:skibble/features/meets/controllers/meets_location_controller.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/custom_date_picker/views/horizontal_date_picker.dart';

import '../../../../utils/time_slot/controllers/day_part_controller.dart';
import '../../../../utils/time_slot/models/time_slot_interval.dart';
import '../../../../utils/time_slot/views/time_slot_from_interval.dart';


class MeetsDateTimePickerView extends StatefulWidget {
  const MeetsDateTimePickerView({Key? key, required this.business, required this.isFromLocationPicker}) : super(key: key);
  final SkibbleFoodBusiness business;
  // final int listIndex;

  final bool isFromLocationPicker;

  @override
  State<MeetsDateTimePickerView> createState() => _MeetsDateTimePickerViewState();
}

class _MeetsDateTimePickerViewState extends State<MeetsDateTimePickerView> {

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, bottom: 0, top: 20,),
            child: SafeArea(
              child: Consumer2<MeetsDateTimeController, CreateEditMeetsController>(
                  builder: (context, data, meetsData, child) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 20, top: 20, right: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15,),

                              Text(
                                  'Meet at ${widget.business.googlePlaceDetails!.name!}',
                                  style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                              ),

                              const SizedBox(height: 2,),

                              const Text(
                                  'Select the meet date and time.',
                                  style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500)
                              ),

                              const SizedBox(height: 10,),

                              HorizontalDatePickerWidget(
                                startDate: DateTime.now(),
                                endDate: DateTime.now().add(const Duration(days: 30)),
                                selectedDate: context.read<MeetsDateTimeController>().tempSelectedDateTime != null ? context.read<MeetsDateTimeController>().tempSelectedDateTime!.isAfter(DateTime.now()) ? context.read<MeetsDateTimeController>().tempSelectedDateTime! : DateTime.now() : DateTime.now(),
                                widgetWidth: MediaQuery.of(context).size.width - 60,
                                height: 80,
                                selectedTextColor: kDarkSecondaryColor,
                                normalColor: kContentColorLightTheme,
                                disabledColor: kContentColorLightTheme,
                                datePickerController: context.read<MeetsDateTimeController>().datePickerController!,
                                onValueSelected: context.read<MeetsDateTimeController>().onDateValueChanged,
                              ),

                              const SizedBox(height: 10),

                              MeetsTimeSelector(
                                business: widget.business,
                                timeSlotInterval: data.timeSlotInterval!
                              ),

                              const SizedBox(height: 10),


                              // Container(
                              //   width: MediaQuery.of(context).size.width,
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(15),
                              //       border: Border.all(color: Colors.grey)
                              //   ),
                              //   child: Column(
                              //     children: [
                              //       Padding(
                              //         padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //
                              //           children: [
                              //             Text(
                              //                 'Meet Pals',
                              //                 style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 22, fontWeight: FontWeight.w600)
                              //             ),
                              //
                              //           ],
                              //         ),
                              //       ),
                              //
                              //       SizedBox(height: 10),
                              //
                              //
                              //       Padding(
                              //         padding: const EdgeInsets.only(right: 8.0),
                              //         child: MaxNumberOfPeopleSlider(
                              //           onChanged: (double value) {
                              //             context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet = value;
                              //           },
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              //

                              const SizedBox(height: 60,),
                            ],
                          ),
                        )
                      ],
                    );
                  }
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
                color: kContentColorLightTheme
              // color: Colors.white
            ),
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
            // height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);

                    },
                    child: const Text('Cancel', style: TextStyle(decoration: TextDecoration.underline),)),

                Consumer<MeetsDateTimeController>(
                  builder: (context, data, child) {
                    return ElevatedButton(
                      onPressed: data.openingHours.isEmpty ? null : () {
                        if( data.tempSelectedDateTime != null) {
                          DateTime? dateTime = data.tempSelectedDateTime;
                          data.selectedDateTime = DateTime(dateTime!.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
                          // data.tempSelectedDateTime = null;
                        }

                        context.read<MeetsLocationController>().finalSelectedButtonIndex = context.read<MeetsLocationController>().selectedButtonIndex;
                        // context.read<MeetsLocationController>().finalSelectedListIndex = widget.listIndex;
                        context.read<MeetsLocationController>().finalSelectedBusinessId = widget.business.skibblePlaceId;

                        context.read<CreateEditMeetsController>().setFoodBusiness(widget.business);
                        context.read<CreateEditMeetsController>().meetDateTime = DateTime(data.selectedDateTime!.year, data.selectedDateTime!.month, data.selectedDateTime!.day, data.selectedDateTime!.hour, data.selectedDateTime!.minute);

                        Navigator.pop(context, true);

                        if(widget.isFromLocationPicker) {
                          if(Navigator.canPop(context))
                            Navigator.pop(context);

                          if(Navigator.canPop(context))
                            Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)
                          )
                      ),
                      child: const Text('Done',),

                    );
                  }
                )
              ],
            ),
          ),
        ),

        // Positioned(
        //   bottom: 0,
        //   left: 0,
        //   right: 0,
        //   height: 100,
        //   child: Container(
        //     decoration: BoxDecoration(
        //         color: kContentColorLightTheme
        //     ),
        //     padding: EdgeInsets.symmetric(horizontal: 25),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Expanded(
        //           child: ElevatedButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             style: ElevatedButton.styleFrom(
        //                 backgroundColor: Colors.grey.shade200,
        //                 elevation: 0,
        //                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.all(Radius.circular(10))
        //                 )
        //             ),
        //
        //             child: Text('Cancel', style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 18),),),
        //         ),
        //         const SizedBox(width: 15,),
        //         Expanded(
        //           child: Consumer<MeetsDateTimeController>(
        //               builder: (context, data, child) {
        //                 return ElevatedButton(
        //                   onPressed: data.openingHours.isEmpty ? null : () {
        //                     if( data.tempSelectedDateTime != null) {
        //                       DateTime? dateTime = data.tempSelectedDateTime;
        //                       data.selectedDateTime = DateTime(dateTime!.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
        //                       // data.tempSelectedDateTime = null;
        //                     }
        //
        //                     context.read<MeetsLocationController>().finalSelectedButtonIndex = context.read<MeetsLocationController>().selectedButtonIndex;
        //                     // context.read<MeetsLocationController>().finalSelectedListIndex = widget.listIndex;
        //                     context.read<MeetsLocationController>().finalSelectedBusinessId = widget.business.skibblePlaceId;
        //
        //                     context.read<CreateEditMeetsController>().setFoodBusiness(widget.business);
        //                     context.read<CreateEditMeetsController>().meetDateTime = DateTime(data.selectedDateTime!.year, data.selectedDateTime!.month, data.selectedDateTime!.day, data.selectedDateTime!.hour, data.selectedDateTime!.minute);
        //
        //                     Navigator.pop(context, true);
        //
        //                     if(widget.isFromLocationPicker) {
        //                       if(Navigator.canPop(context))
        //                         Navigator.pop(context);
        //
        //                       if(Navigator.canPop(context))
        //                         Navigator.pop(context);
        //                     }
        //
        //                   },
        //                   statesController: MaterialStatesController(),
        //                   style: ElevatedButton.styleFrom(
        //                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        //                       shape: const RoundedRectangleBorder(
        //                           borderRadius: BorderRadius.all(Radius.circular(10))
        //                       )
        //                   ),
        //
        //                   child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),);
        //               }
        //           ),
        //         ),
        //
        //       ],
        //     ),
        //   ),
        // )
      ],
    );
  }

}

class MeetsTimeSelector extends StatefulWidget {
  const MeetsTimeSelector({Key? key, required this.business, required this.timeSlotInterval}) : super(key: key);
  final SkibbleFoodBusiness business;
  final TimeSlotInterval timeSlotInterval;
  // final List<DateTime> timeSelector;
  // final DateTime? initialDateTime;

  @override
  State<MeetsTimeSelector> createState() => _MeetsTimeSelectorState();
}

class _MeetsTimeSelectorState extends State<MeetsTimeSelector> {
  // int _selectedIndex = 0;

  late DateTime _selectedTime;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTime = context.read<MeetsDateTimeController>().tempSelectedDateTime ?? DateTime.now();

      // if(context.read<MeetsDateTimeController>().selectedDateTime != null) {
      //   if(context.read<MeetsDateTimeController>().selectedDateTime!.isAfter(DateTime.now())) {
      //     int index = context.read<MeetsDateTimeController>().openingHours.isNotEmpty ? context.read<MeetsDateTimeController>().openingHours.indexWhere((dateTime) {
      //       return (dateTime.hour == context.read<MeetsDateTimeController>().selectedDateTime!.hour && dateTime.minute == context.read<MeetsDateTimeController>().selectedDateTime!.minute);
      //     }) : 0;
      //
      //     context.read<MeetsDateTimeController>().selectedTime = index != -1 ? index : 0;
      //   }
      // }
    // });
  }


  @override
  Widget build(BuildContext context) {
    return  Container(
      // height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey)
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                        'Time',
                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 22, fontWeight: FontWeight.w600)
                    ),

                  ],
                ),
              ),

              const Divider(),
              Consumer<MeetsDateTimeController>(
                builder: (context, data, child) {


                  if(data.timeSlotInterval!.start == null || data.timeSlotInterval!.end == null) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                    child: TimesSlotGridViewFromInterval(
                      locale: "en",
                      initTime: data.tempSelectedDateTime!,
                      crossAxisCount: 3,
                      timeSlotInterval: data.timeSlotInterval!,
                      onChange: (value) {
                        setState(() {
                          _selectedTime = value;
                        });
                        DateTime? dateTime = data.tempSelectedDateTime;
                        data.tempSelectedDateTime = DateTime(dateTime!.year, dateTime.month, dateTime.day, value.hour, value.minute);

                      },
                    ),

                    // data.openingHours.isNotEmpty ? Wrap(
                    //     crossAxisAlignment: WrapCrossAlignment.start,
                    //     alignment: WrapAlignment.start,
                    //     direction: Axis.horizontal,
                    //     spacing: 10,
                    //     runAlignment: WrapAlignment.start,
                    //     runSpacing: 8,
                    //     children: List.generate(data.openingHours.length, (index) => GestureDetector(
                    //       onTap: () {
                    //         data.selectTime(index);
                    //         // setState(() {
                    //         //   _selectedIndex = index;
                    //         // });
                    //         //
                    //         DateTime? dateTime = context.read<MeetsDateTimeController>().tempSelectedDateTime;
                    //         context.read<MeetsDateTimeController>().tempSelectedDateTime = DateTime(dateTime!.year, dateTime.month, dateTime.day, data.openingHours[index].hour, data.openingHours[index].minute);

                    //       },
                    //       child: Container(
                    //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    //         // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(10),
                    //             border: Border.all(color: data.selectedTime == index ? kDarkSecondaryColor : Colors.grey.shade400),
                    //           color: data.selectedTime == index ? kDarkSecondaryColor : null
                    //         ),
                    //         child: Text(
                    //           DateFormat("hh:mm a").format(data.openingHours[index]),
                    //           style: TextStyle(color: data.selectedTime == index ? kLightSecondaryColor : null),
                    //         )
                    //       ),
                    //     ))
                    //   // List.generate(widget.business.googlePlaceDetails.openingHours.periods., (index) => null)
                    // ) :
                    // Center(
                    //   child: Text('Unable to fetch available times',
                    //     style: TextStyle(),
                    //   )
                    // ),
                  );
                }
              )
            ]
        )
    );
  }
}

