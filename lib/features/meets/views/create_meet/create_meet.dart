import 'package:animated_switch/animated_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import 'package:skibble/features/meets/views/components/max_number_of_people_slider.dart';
import 'package:skibble/utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../../../utils/custom_pickers/custom_pickers.dart';
import '../../../../utils/shaking_error_text.dart';
import '../../../../utils/validators.dart';
import '../../controllers/create_edit_meets_controller.dart';
import '../../controllers/meets_bills_controller.dart';
import '../../controllers/meets_date_time_controller.dart';
import '../../controllers/meets_location_controller.dart';
import '../../controllers/meets_privacy_controller.dart';
import '../../utils/meets_bottom_sheets.dart';

class CreateMeet extends StatelessWidget {
  const CreateMeet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentUser = context.read<AppData>().skibbleUser!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            splashRadius: 20,
            icon: const Icon( Icons.clear, color: kDarkSecondaryColor,)),
        centerTitle: true,
        title: const Text('Create a meet', style: TextStyle(fontWeight: FontWeight.bold,color: kDarkSecondaryColor)),
      ),
      body: Consumer<CreateEditMeetsController>(
          builder: (context, data, child) {
            return Form(
                key: data.formKey,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Divider(),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    Text(
                                        'Meet Title',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),
                                    TextFormField(
                                      initialValue: data.meetTitle,
                                      keyboardType: TextInputType.text,
                                      onSaved: (newValue) => data.meetTitle = newValue ?? '',
                                      validator: (value) => Validator().validateText(value, 'Please enter a meet title'),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                              color: Theme.of(context).backgroundColor,
                                              width: 0.5
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            color: kPrimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        // label: Text('Meal Invite Title'),
                                        labelText: 'Meet Title',
                                        // labelStyle: TextStyle(fontSize: 20.0, height: 0.8),
                                        // alignLabelWithHint: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        hintText: "e.g ${currentUser.fullName!.split(' ').first}'s Friends\' Hangout",
                                        // If  you are using latest version of flutter then label text and hint text shown like this
                                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        // suffixIcon: Icon(Iconsax.user),
                                      ),

                                    ),

                                    const SizedBox(height: 20,),



                                    Text(
                                        'Meet Location',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),
                                    //meet location
                                    InkWell(
                                      onTap: () {
                                        // CustomDateTimePicker().showDateTimePicker(context);
                                        MeetsBottomSheets().showMeetsLocationPickerSheet(context);
                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocationPickerView()));
                                      },
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6)
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.all(6.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text('Meet Location', style: TextStyle(color: Colors.grey, fontSize: 12),),

                                                  const SizedBox(height: 3,),

                                                  Consumer<MeetsLocationController>(
                                                    builder: (context, location, child) {
                                                      if(location.selectedSuggestion != null && data.locationController.isVisible) {
                                                        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                                          data.locationController.hideError();
                                                        });
                                                      }
                                                      return Text(
                                                        location.selectedSuggestion == null ? ('No location set') : location.selectedSuggestion!.title + ', ' + (location.selectedSuggestion!.subTitle ?? ''),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      );
                                                    },
                                                  ),

                                                ],
                                              ),
                                            )),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: Colors.grey, width: 1)
                                        ),
                                      ),
                                    ),



                                    ShakingErrorText(
                                      controller: data.locationController,
                                    ),

                                    //  SizedBox(height: 10,),
                                    //
                                    //
                                    //
                                    // // show location toggle
                                    //  Row(
                                    //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //    children: [
                                    //      Expanded(
                                    //          child: Text(
                                    //            'Automatically approve interested skibblers',
                                    //            style: TextStyle(
                                    //              // fontWeight: FontWeight.bold,
                                    //                fontSize: 15
                                    //            )
                                    //            ,
                                    //          )
                                    //      ),
                                    //
                                    //      AnimatedSwitch(
                                    //        colorOn: kPrimaryColor,
                                    //        value: data.showUserLocation,
                                    //        colorOff: Colors.grey.shade400,
                                    //        indicatorColor: kContentColorLightTheme,
                                    //        animationDuration: Duration(milliseconds: 10),
                                    //        onChanged: (value) {print(value); data.showUserLocation = value;},
                                    //      ),
                                    //
                                    //    ],
                                    //  ),

                                    const SizedBox(height: 20,),

                                    Text(
                                        'Max. Meet Pals',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),
                                    const SizedBox(height: 3,),

                                    Text(
                                        'Choose the maximum number of people for this meet.',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : Colors.grey, fontSize: 13,)
                                    ),

                                    const SizedBox(height: 10,),

                                    MaxNumberOfPeopleSlider(
                                      onChanged: (v) {
                                        context.read<CreateEditMeetsController>().maxNumberOfPeopleToMeet = v;

                                      },
                                    ),
                                    const SizedBox(height: 20,),

                                    Text(
                                        'How will bills be handled',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),

                                    //Bills handling
                                    Consumer<MeetsBillsController>(
                                        builder: (context, data, child) {
                                          return InkWell(
                                            onTap: () async{
                                              // CustomDateTimePicker().showDateTimePicker(context);
                                              MeetsBottomSheets().showMeetsBillsHandlingSheet(context);
                                            },
                                            customBorder: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text('Who will handle the bills?', style: TextStyle(color: Colors.grey, fontSize: 12),),

                                                        const SizedBox(height: 3,),

                                                        Text(data.billsHandlerPickerList[data.userBillsTypeChoiceIndex]),

                                                      ],
                                                    ),
                                                  )),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: Colors.grey, width: 1)
                                              ),
                                            ),
                                          );
                                        }
                                    ),

                                    const SizedBox(height: 20,),

                                    Text(
                                        'Meet Privacy',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),

                                    //people invited
                                    Consumer<MeetsPrivacyController>(
                                        builder: (context, data, child) {
                                          return InkWell(
                                            onTap: () async{
                                              // CustomDateTimePicker().showDateTimePicker(context);
                                              MeetsBottomSheets().showMeetsPrivacySheet(context);
                                            },
                                            customBorder: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 50,
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(6.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        const Text('Who can show interest?', style: TextStyle(color: Colors.grey, fontSize: 12),),

                                                        const SizedBox(height: 3,),

                                                        Text(data.privacyPickerList[data.userPrivacyChoiceIndex]),

                                                      ],
                                                    ),
                                                  )),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: Colors.grey, width: 1)
                                              ),
                                            ),
                                          );
                                        }
                                    ),

                                    const SizedBox(height: 20,),

                                    Text(
                                        'Food/Drink Options',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),

                                    //food expected
                                    Consumer<FoodOptionsPickerData>(
                                        builder: (context, data, child) {
                                          return InkWell(
                                            onTap: () {
                                              // CustomDateTimePicker().showDateTimePicker(context);
                                              CustomPickers().showFoodOptionsPickerSheet(context);
                                            },
                                            customBorder: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(6)
                                            ),
                                            child: Container(
                                              width: double.infinity,
                                              height: 58,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(color: Colors.grey, width: 1)
                                              ),
                                              child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Padding(
                                                        padding: EdgeInsets.all(6.0),
                                                        child: Text('What type of food/drink will be getting?', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                                      ),

                                                      const SizedBox(height: 4,),

                                                      data.userChoices.isEmpty ?
                                                      const Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 6.0),
                                                        child: Text('No options selected',  style: TextStyle(fontStyle: FontStyle.italic)),)
                                                          :
                                                      SizedBox(
                                                        height: 20,
                                                        child: ListView.builder(
                                                          itemCount: data.userChoices.length,
                                                          scrollDirection: Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemBuilder: (context, index) => Container(
                                                            padding: const EdgeInsets.symmetric(horizontal: 8,),
                                                            margin: const EdgeInsets.only(left: 6),
                                                            decoration: BoxDecoration(
                                                                color: kBackgroundColorDarkTheme.withOpacity(0.8),
                                                                borderRadius: BorderRadius.circular(20),
                                                                border:  Border.all(width: 0)
                                                            ),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              textBaseline: TextBaseline.alphabetic,
                                                              children: [
                                                                Text(
                                                                  data.userChoices[index].capitalizeFirst!,
                                                                  style: TextStyle(
                                                                      color: data.userChoices.contains(data.userChoices[index].capitalizeFirst!) ? kLightSecondaryColor : Colors.blueGrey,
                                                                      fontWeight: FontWeight.bold,
                                                                      fontSize: 13
                                                                  ),
                                                                ),

                                                                const SizedBox(width: 3,),
                                                                GestureDetector(
                                                                    onTap: () => data.removeFromUserChoiceAtIndex(index),
                                                                    child: const Icon(Icons.clear_rounded, size: 16, color: kContentColorLightTheme,))
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )

                                                    ],
                                                  )),
                                            ),
                                          );
                                        }
                                    ),

                                    const SizedBox(height: 20,),

                                    Text(
                                        'Special Notes',
                                        style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor, fontSize: 18, fontWeight: FontWeight.w600)
                                    ),

                                    const SizedBox(height: 10,),
                                    TextField(
                                      // initialValue: inviteTitle,
                                      keyboardType: TextInputType.text,
                                      maxLines: 5,
                                      onChanged: (newValue) => data.meetDescription = newValue ?? '',
                                      // validator: (value) => Validator().validateText(value, 'Please enter a meal invite title'),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: BorderSide(
                                              color: Theme.of(context).backgroundColor,
                                              width: 0.5
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6),
                                          borderSide: const BorderSide(
                                            color: kPrimaryColor,
                                            width: 1,
                                          ),
                                        ),
                                        // label: Text('Meal Invite Title'),
                                        // labelText: 'Meal Invite Title',
                                        // labelStyle: TextStyle(fontSize: 20.0, height: 0.8),
                                        // alignLabelWithHint: true,
                                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                        hintText: "Tell your future meet pals what interests you",
                                        // If  you are using latest version of flutter then label text and hint text shown like this
                                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                                        // suffixIcon: Icon(Iconsax.user),
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 70,
                        width: double.infinity,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 20),
                        // margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: kContentColorLightTheme,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              // spreadRadius: 5,
                              // blurRadius: 7,
                              blurRadius: 3,
                              spreadRadius: 3,
                              // offset: Offset(0, 0), // changes position of shadow
                            ),
                          ],

                        ),
                        child: ElevatedButton(
                          onPressed: () => data.createMeet(context),
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            // padding: EdgeInsets.symmetric(vertical: 5)
                          ),
                          child: const Text("I'm ready to meet!"),
                        ),
                      )
                    ],
                  ),
                )
            );
          }
      ),
    );
  }



}


class OutlineBorderTextFormField extends StatefulWidget {
  const OutlineBorderTextFormField({
    Key? key,
    required this.labelText,
    this.autofocus  = false,
    required this.tempTextEditingController,
    required this.myFocusNode,
    required this.inputFormatters,
    required this.keyboardType,
    required this.textInputAction,
    required this.validation,
    this.checkOfErrorOnFocusChange = false
  }) : super(key: key);

  final FocusNode myFocusNode;
  final TextEditingController tempTextEditingController;
  final String labelText;
  final TextInputType keyboardType;
  final bool autofocus;
  final TextInputAction textInputAction;
  final List<TextInputFormatter> inputFormatters;
  final Function validation;
  final bool checkOfErrorOnFocusChange;//If true validation is checked when evre focus is changed

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _OutlineBorderTextFormField();
  }
}

class _OutlineBorderTextFormField extends State<OutlineBorderTextFormField> {
  bool isError = false;
  String errorString = "";

  getLabelTextStyle(color) {
    return TextStyle(
        fontSize: 12.0, color: color
    );
  } //label text style

  getTextFieldStyle() {
    return const TextStyle(
      fontSize: 12.0,
      color: Colors.black,
    );
  } //textfield style

  getErrorTextFieldStyle() {
    return const TextStyle(
      fontSize: 10.0,
      color: Colors.red,
    );
  }// Error text style

  getBorderColor(isfous) {
    return isfous
        ? Colors.deepPurple
        : Colors.black54;
  }//Border colors according to focus

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 15.0, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FocusScope(
            child: Focus(
              onFocusChange: (focus) {
                //Called when ever focus changes
                print("focus: $focus");
                setState(() {
                  getBorderColor(focus);
                  if (widget.checkOfErrorOnFocusChange &&
                      widget
                          .validation(widget.tempTextEditingController.text)
                          .toString()
                          .isNotEmpty) {
                    isError = true;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  } else {
                    isError = false;
                    errorString = widget
                        .validation(widget.tempTextEditingController.text);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(Radius.circular(
                        6.0) //                 <--- border radius here
                    ),
                    border: Border.all(
                      width: 1,
                      style: BorderStyle.solid,
                      color: isError
                          ? Colors.red
                          : getBorderColor(widget.myFocusNode.hasFocus),
                    )),
                child: TextFormField(
                  focusNode: widget.myFocusNode,
                  controller: widget.tempTextEditingController,
                  style: getTextFieldStyle(),
                  autofocus: widget.autofocus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  inputFormatters: widget.inputFormatters,
                  validator: (string) {
                    if (widget
                        .validation(widget.tempTextEditingController.text)
                        .toString()
                        .isNotEmpty) {
                      setState(() {
                        isError = true;
                        errorString = widget
                            .validation(widget.tempTextEditingController.text);
                      });
                      return "";
                    } else {
                      setState(() {
                        isError = false;
                        errorString = widget
                            .validation(widget.tempTextEditingController.text);
                      });
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: widget.labelText,
                      labelStyle: isError
                          ? getLabelTextStyle(
                          Colors.red)
                          : getLabelTextStyle(Colors.deepPurple),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 16),
                      fillColor: Colors.grey[200],
                      filled: true,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      border: InputBorder.none,
                      errorStyle: const TextStyle(height: 0),
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      floatingLabelBehavior: FloatingLabelBehavior.auto),
                ),
              ),
            ),
          ),
          Visibility(
              visible: isError ? true : false,
              child: Container(
                  padding: const EdgeInsets.only(left: 15.0, top: 2.0),
                  child: Text(
                    errorString,
                    style: getErrorTextFieldStyle(),
                  ))),
        ],
      ),
    );
    ;
  }
}
