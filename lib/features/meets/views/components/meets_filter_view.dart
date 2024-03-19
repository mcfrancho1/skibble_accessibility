import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/features/meets/controllers/meets_filter_controller.dart';
import 'package:skibble/features/meets/models/meet_filter.dart';
import 'package:skibble/features/meets/utils/meets_bottom_sheets.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../controllers/meets_controller.dart';
import 'max_number_of_people_slider.dart';

class MeetsFilterView extends StatelessWidget {
  const MeetsFilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;

    return Consumer2<MeetsController, MeetsFilterController>(
      builder: (context, meetsData, filterData, child) {
        SkibbleMeetsFilter? meetsFilter = filterData.tempMeetFilter;
        return Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0, bottom: 100, top: 10,),
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        IconButton(
                          onPressed: () {
                              Navigator.pop(context);
                            },
                          icon: Icon(Icons.close_rounded)
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                              'Filter',
                              style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                          ),
                        ),

                        Opacity(
                          opacity: 0,
                            child: TextButton(onPressed: () {}, child: Text('')))

                      ],
                    ),

                    Divider(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                              child: Text('Date',
                                style: TextStyle(
                                    color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        GestureDetector(
                          onTap: () async{
                            MeetsBottomSheets().showMeetsDatePickerFilterSheet(context, meetsFilter != null ? [meetsFilter.filterFromDateTime, meetsFilter.filterToDateTime] : [], );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              // color: Colors.white
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('When', style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.w600),),

                                if(meetsFilter != null)

                                    RichText(
                                        text: TextSpan(
                                      children: [
                                        if(meetsFilter.filterFromDateTime != null)
                                          TextSpan(
                                              text: DateFormat('MMM dd').format(meetsFilter.filterFromDateTime!),
                                              style: TextStyle(
                                                  color: kDarkSecondaryColor, fontWeight: FontWeight.w600
                                              )
                                          ),

                                        if(meetsFilter.filterToDateTime != null)
                                          TextSpan(
                                              text: ' - ${DateFormat('MMM dd').format(meetsFilter.filterToDateTime!)}',
                                              style: TextStyle(
                                                  color: kDarkSecondaryColor, fontWeight: FontWeight.w600
                                              )
                                          )
                                      ]
                                    )),

                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 15,),

                        ///meet pals
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                              child: Text('Max. Meet pals',
                                style: TextStyle(
                                    color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade300),
                              // color: Colors.white
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 20.0),
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15),
                            child: MaxNumberOfPeopleSlider(
                              onChanged: (value) {
                                filterData.chooseMaxMeetPals(value.toInt());
                              },
                              minValue: 2,
                              maxValue: 10,
                              initialValue: meetsFilter != null ? (meetsFilter.maxNumberOfPeopleMeeting ?? 2.0).toDouble() : 2.0,

                            )
                        ),

                        SizedBox(height: 15,),

                        ///bills
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0, bottom: 10),
                              child: Text('Bills handling',
                                style: TextStyle(
                                    color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300)
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: List.generate(filterData.billsHandlerPickerList.length, (index) => CheckboxListTile(
                              // contentPadding:  EdgeInsets.symmetric(vertical: 5.0, horizontal: 20),
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: kPrimaryColor,
                              secondary:  CircleAvatar(
                                child: Icon(filterData.billsHandlerPickerListIcons[index], color: kDarkSecondaryColor,),
                                backgroundColor: Colors.grey.shade200,
                              ),
                              title: Text(filterData.billsHandlerPickerList[index], style: TextStyle(fontWeight: FontWeight.bold),),
                              value: meetsFilter != null ? meetsFilter.meetBillsType!.contains(filterData.billsTypePickerList[index]) : false,
                              selected: meetsFilter != null ? meetsFilter.meetBillsType!.contains(filterData.billsHandlerPickerList[index]) : false,
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                              // groupValue: context.read<MeetsBillsController>().userBillsTypeChoiceIndex,
                              onChanged: (value) {
                                if(value!) {
                                  filterData.addBillTypeFilter(index);
                                }
                                else {
                                  filterData.removeBillTypeFilter(index);

                                }

                                // print(meetsFilter!.meetBillsType!);
                                // context.read<MeetsBillsController>().userBillsTypeChoiceIndex = value!;
                              },
                            ),
                            ),
                          ),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20),
                        //   child: InkWell(
                        //     customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        //     onTap: () async{
                        //       Navigator.pop(new_context);
                        //       // _navigator.restorablePush(_dialogBuilder);
                        //       // _navigator.push(MaterialPageRoute(builder: (context) {
                        //       //   return CreateMealInvite();
                        //       // }));
                        //     },
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(vertical: 10),
                        //       width: double.infinity,
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text('Meal Invite'),
                        //         ],
                        //       ),
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(20),
                        //           border: Border.all(color: kDarkSecondaryColor)
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    )
                  ],
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
                  // color: Colors.white
                ),
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 20),
                // height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        filterData.resetFilter();
                        Navigator.pop(context);

                      },
                        child: Text('Clear all', style: TextStyle(decoration: TextDecoration.underline),)),

                    ElevatedButton(
                      onPressed: (){
                        filterData.setMeetFilter(filterData.tempMeetFilter, context, currentUser);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: Text('Done'),

                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}
