import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/certificationsController.dart';
import 'package:skibble/models/skibble_user.dart';

import '../../../../../../models/work_experience_controller_model.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../utils/constants.dart';
import 'kitchen_register_page.dart';

class ChefQualificationsDetails extends StatefulWidget {
  const ChefQualificationsDetails({Key? key}) : super(key: key);

  @override
  State<ChefQualificationsDetails> createState() => _ChefQualificationsDetailsState();
}

class _ChefQualificationsDetailsState extends State<ChefQualificationsDetails> {

  List<WorkExperienceView> workExperienceList = [];
  List<CertificationView> certificationsList = [];

  List<WorkExperienceControllerModel> workExperienceListControllers = [];
  List<CertificationsController> certificationsListControllers = [];

  String backgroundCheck = 'Yes, I agree to have a background check.';

  @override
  void initState() {
    // TODO: implement initState
    var userChef = Provider.of<AppData>(context, listen: false).currentUserChef;

    backgroundCheck = userChef!.chef!.agreedBackgroundCheck == true ? 'Yes, I agree to have a background check.' : 'No, I do not want a background check.';
    if(userChef.chef!.workExperienceListControllers != null) {
      userChef.chef!.workExperienceListControllers!.forEach((controller) {
        // WorkExperienceControllerModel controllerModel = WorkExperienceControllerModel(
        //     whereController: TextEditingController(text: map['Where']),
        //     jobTitleController: TextEditingController(text: map['JobTitle']),
        //     startDate: TextEditingController(text: map['StartDate']),
        //     endDate: TextEditingController(text: map['EndDate'])
        // );
        workExperienceListControllers.add(controller);
        workExperienceList.add(WorkExperienceView(workExperienceController: controller));
      });
    }

    if(userChef.chef!.certificationsListControllers != null) {
      userChef.chef!.certificationsListControllers!.forEach((controller) {
        // CertificationsController controllerModel = CertificationsController(
        //     nameController: TextEditingController(text: map['Name']),
        //     countryIssued: TextEditingController(text: map['CountryIssued']),
        //     dateIssued: TextEditingController(text: map['DateIssued']),
        // );
        certificationsListControllers.add(controller);
        certificationsList.add(CertificationView(certificationsController: controller));
      });
    }

    super.initState();
  }


  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   workExperienceListControllers.forEach((controller) {
  //     controller.whereController.dispose();
  //     controller.jobTitleController.dispose();
  //     controller.startDate.dispose();
  //     controller.endDate.dispose();
  //   });
  //
  //   certificationsListControllers.forEach((controller) {
  //     controller.nameController.dispose();
  //     controller.dateIssued.dispose();
  //     controller.countryIssued.dispose();
  //   });
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    var userChef = Provider.of<AppData>(context, listen: false).currentUserChef;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),

                  // Text(
                  //   'Kitchen Skills',
                  //   style: TextStyle(fontSize: 30),
                  // ),
                  // SizedBox(height: 10,),
                  Text(
                    'It\'s time to tell us about those exceptional kitchen knife skills!',
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 10,),
                  Divider(),
                  SizedBox(height: 15,),

                  Text('Your Average Rating', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'On a scale of 1 - 5, how perfect are you in the kitchen?\nThis is a one-time rating.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  SizedBox(height: 10,),

                  Center(
                    child: RatingBar.builder(
                      initialRating: userChef!.chef!.averageRatings! as double,
                      minRating: 1.0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemSize: 30,
                      unratedColor: Colors.grey.shade400,
                      itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star_rounded,
                        color: kPrimaryColor,
                      ),
                      onRatingUpdate: (rating) {
                        userChef.chef!.averageRatings = rating;
                      },
                    ),
                  ),

                  SizedBox(height: 10,),

                  Divider(),

                  SizedBox(height: 20,),

                  Text('Kitchen Skills', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'Rate yourself based on these essential skills. Your potential clients will also have a chance to rate you too.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  SizedBox(height: 10,),

                  KitchenSkillsView(skills: userChef.chef!.kitchenSkillsRating!,),

                  SizedBox(height: 10,),

                  Divider(),

                  SizedBox(height: 20,),

                  Text('Experience', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'Let\'s know about the restaurants you have worked at. This field is optional.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                 SizedBox(height: 10,),

                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: List.generate(
                     workExperienceList.length, (index) =>  WorkExperienceView(
                     workExperienceController: workExperienceListControllers[index],
                     onRemoveTap: () {
                       setState(() {
                         workExperienceListControllers.removeAt(index);
                         workExperienceList.removeAt(index);
                       });
                       // userChef.chef!.workExperienceList!.removeAt(index);
                   },
                   ),
                   ),
                 ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: workExperienceList.isEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                      children: [
                        workExperienceList.isEmpty ? Expanded(
                          child: Text(
                              'Click the "Add New" button to add a new work experience.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ) : Container(),
                        SizedBox(width: 20,),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                WorkExperienceControllerModel controller = WorkExperienceControllerModel(whereController: TextEditingController(), jobTitleController: TextEditingController(), startDate: TextEditingController(), endDate: TextEditingController());
                                workExperienceListControllers.add(controller);
                                workExperienceList.add(WorkExperienceView(workExperienceController: controller,));
                              });


                              Map<String, dynamic> workExperience = {

                              };
                              // userChef.chef!.workExperienceList!.add(workExperience);
                            },
                            child: Text(
                              'Add New',
                              style: TextStyle(
                                color: kLightSecondaryColor
                              ),
                            )
                          )
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Divider(),

                  SizedBox(height: 20,),

                  Text('Certifications', style: TextStyle(fontSize: 16),),
                  SizedBox(height: 5,),
                  Text(
                    'Got any culinary certifications you might want to share? This field is optional.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                      certificationsList.length, (index) =>  CertificationView(
                      certificationsController: certificationsListControllers[index],
                      onRemoveTap: () {
                      setState(() {
                        certificationsList.removeAt(index);
                        certificationsListControllers.removeAt(index);
                      });
                    },),),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: certificationsList.isEmpty ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                      children: [
                        certificationsList.isEmpty ? Expanded(
                          child: Text(
                            'Click the "Add New" button to add a new certification.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ) : Container(),
                        SizedBox(width: 20,),
                        Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                                onPressed: () => setState(()   {
                                  CertificationsController certController = CertificationsController(nameController: TextEditingController(), countryIssued: TextEditingController(), dateIssued: TextEditingController());
                                  certificationsListControllers.add(certController);
                                  certificationsList.add(CertificationView(certificationsController: certController,));
                                }),
                                child: Text(
                                  'Add New',
                                  style: TextStyle(
                                      color: kLightSecondaryColor
                                  ),
                                )
                            )
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 10,),

                  Divider(),

                  SizedBox(height: 10,),

                  ///background check
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     // Container(
                  //     //   child: Text(
                  //     //     'Background Check',
                  //     //     style: TextStyle(
                  //     //         fontSize: 17
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //
                  //     // SizedBox(height: 8,),
                  //
                  //     // Container(
                  //     //   child: Text(
                  //     //     'In as much as we care about your safety, we also care about the safety of your potential clients. Therefore, we need your consent to run a background check on you.',
                  //     //     style: TextStyle(
                  //     //         fontSize: 13,
                  //     //       color: Colors.grey
                  //     //     ),
                  //     //   ),
                  //     // ),
                  //     //
                  //     // Container(
                  //     //   margin: EdgeInsets.symmetric(vertical: 10),
                  //     //   child: RadioListTile<String>(
                  //     //       contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //     //       shape: RoundedRectangleBorder(
                  //     //           borderRadius: BorderRadius.circular(10),
                  //     //           side: BorderSide(width: 1, color: Colors.grey)
                  //     //       ),
                  //     //       value: 'Yes, I agree to have a background check.',
                  //     //       title: Text('Yes, I agree to have a background check.', style: TextStyle(fontFamily: 'Brand Regular'),),
                  //     //       groupValue: backgroundCheck,
                  //     //       onChanged: (value) {
                  //     //         setState(() {
                  //     //           backgroundCheck = value!;
                  //     //         });
                  //     //         userChef.chef!.agreedBackgroundCheck = true;
                  //     //       }
                  //     //   ),
                  //     // ),
                  //     //
                  //     // Container(
                  //     //   margin: EdgeInsets.only(top: 5, bottom: 15,),
                  //     //   child: RadioListTile<String>(
                  //     //       contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  //     //       shape: RoundedRectangleBorder(
                  //     //           borderRadius: BorderRadius.circular(10),
                  //     //           side: BorderSide(width: 1, color: Colors.grey)
                  //     //       ),
                  //     //       value: 'No, I do not want a background check.',
                  //     //       title: Text('No, I do not want a background check.', style: TextStyle(fontFamily: 'Brand Regular'),),
                  //     //       groupValue: backgroundCheck,
                  //     //       onChanged: (value) {
                  //     //         setState(() {
                  //     //           backgroundCheck = value!;
                  //     //         });
                  //     //         userChef.chef!.agreedBackgroundCheck = false;
                  //     //
                  //     //       }
                  //     //   ),
                  //     // ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),

        ControlButtons(
          onBackPressed: () async{
            retrieveDataAndStoreData(userChef);

          },
          onNextPressed: () async{
            retrieveDataAndStoreData(userChef);
          },
        )
      ],
    );
  }

  retrieveDataAndStoreData(SkibbleUser userChef) {
    // workExperienceListControllers.forEach((workExperience) {
      // Map<String, dynamic> expMap = {
      //   'Where': workExperience.whereController.text,
      //   'JobTitle': workExperience.jobTitleController.text,
      //   'StartDate': workExperience.startDate.text,
      //   'EndDate': workExperience.endDate.text,
      // };

      userChef.chef!.workExperienceListControllers = workExperienceListControllers;
    // });
    // certificationsListControllers.forEach((certifications) {
    //   Map<String, dynamic> expMap = {
    //     'Name': certifications.nameController.text,
    //     'CountryIssued': certifications.countryIssued.text,
    //     'DateIssued': certifications.dateIssued.text
    //   };

      // userChef.chef!.certificationsList!.add(expMap);
      userChef.chef!.certificationsListControllers = certificationsListControllers;
    // });
  }
}

class WorkExperienceView extends StatelessWidget {
  const WorkExperienceView({Key? key, this.onRemoveTap, required this.workExperienceController,}) : super(key: key);
  final Function()? onRemoveTap;
  final WorkExperienceControllerModel workExperienceController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1)
          ),
          child: Column(
            children: [


              Row(
                children: [

                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Where'),
                          TextField(
                            controller: workExperienceController.whereController,
                            decoration: InputDecoration(hintText: 'e.g Mia\'s Cafe'),
                          )
                        ],
                      ),
                    ),
                  ),


                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Title'),
                          TextField(
                            controller: workExperienceController.jobTitleController,
                            decoration: InputDecoration(hintText: 'e.g Sous-Chef'),

                          )
                        ],
                      ),
                    ),
                  ),
                  //
                  // Column(
                  //   children: [
                  //     Text('Where'),
                  //     TextField()
                  //   ],
                  // )
                ],
              ),

              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date'),
                          Text('(mm/yyyy)', style: TextStyle(color: Colors.grey),),
                          DatePickerField(dateController: workExperienceController.startDate)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('End Date'),
                          Text('(mm/yyyy)', style: TextStyle(color: Colors.grey),),
                          DatePickerField(dateController: workExperienceController.endDate)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          right: 0,
          // top: 2,
          child: InkWell(
            onTap: onRemoveTap!,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kErrorColor,
              ),
              child: Icon(Icons.remove_rounded, color: kLightSecondaryColor,),),
          ))
      ],
    );
  }
}

class CertificationView extends StatelessWidget {
  const CertificationView({Key? key, this.onRemoveTap, required this.certificationsController}) : super(key: key);
  final Function()? onRemoveTap;
  final CertificationsController certificationsController;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 1)
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Certification Name'),
                    TextField(controller: certificationsController.nameController,)
                  ],
                ),
              ),

              SizedBox(height: 10,),

              Row(
                children: [

                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Country of Issuance'),
                          TextField(
                            readOnly: true,
                            onTap: () async{
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                showWorldWide: false,
                                onSelect: (Country country) {
                                  certificationsController.countryIssued.text = country.name;
                                },
                                // Optional. Sets the theme for the country list picker.
                                countryListTheme: CountryListThemeData(
                                  // Optional. Sets the border radius for the bottomsheet.
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40.0),
                                    topRight: Radius.circular(40.0),
                                  ),
                                  // Optional. Styles the search field.
                                  inputDecoration: InputDecoration(
                                    labelText: 'Search',
                                    hintText: 'Start typing to search',
                                    prefixIcon: const Icon(Icons.search),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: const Color(0xFF8C98A8).withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            controller: certificationsController.countryIssued,),
                        ],
                      ),
                    ),
                  ),


                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date(mm/yyyy)'),
                          DatePickerField(dateController: certificationsController.dateIssued)
                          // DatePickerField(dateController: dateController)
                        ],
                      ),
                    ),
                  ),
                  //
                  // Column(
                  //   children: [
                  //     Text('Where'),
                  //     TextField()
                  //   ],
                  // )
                ],
              ),
            ],
          ),
        ),

        Positioned(
            right: 0,
            // top: 2,
            child: InkWell(
              onTap: onRemoveTap!,
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kErrorColor,
                ),
                child: Icon(Icons.remove_rounded, color: kLightSecondaryColor,),),
            ))
      ],
    );
  }
}

class DatePickerField extends StatefulWidget {
  const DatePickerField({Key? key, required this.dateController}) : super(key: key);
  final TextEditingController dateController;

  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: widget.dateController,
        readOnly: true,
        onTap: () {
          _showDatePicker(context);
        },
      ),
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime date = DateTime.now().subtract(Duration(days: 21900));
    DateTime? dateTimePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: date,
        lastDate: DateTime.now());
    if (dateTimePicked != null) {
      //eturn dateTimePicked;
      // onChanged(DateTime(dateTimePicked.year, dateTimePicked.month,
      //     dateTimePicked.day, time.hour, time.minute));
      DateTime newDateTime = DateTime(dateTimePicked.year, dateTimePicked.month, dateTimePicked.day, 23, 59);
      // applicationDeadlineDateTime = newDateTime;
      widget.dateController.text = DateFormat('MMMM d, yyyy').format(dateTimePicked);
    }
  }
}



class KitchenSkillsView extends StatelessWidget {
  KitchenSkillsView({Key? key, required this.skills, this.ignoreGestures = false,}) : super(key: key);

  final Map<String, dynamic> skills;
  final bool ignoreGestures;
  @override
  Widget build(BuildContext context) {
    var userChef = Provider.of<AppData>(context, listen: false).currentUserChef;

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(skills.length, (index) =>
          Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Chip(
              label: Text(skills.keys.toList()[index]),
              labelStyle: TextStyle(color: kLightSecondaryColor),
            ),
            RatingBar.builder(
              initialRating: skills.values.toList()[index],
              minRating: 1.0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              ignoreGestures: ignoreGestures,
              itemSize: 30,
              unratedColor: Colors.grey.shade400,
              itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
              itemBuilder: (context, _) => Icon(
                Icons.star_rounded,
                color: kPrimaryColor,
              ),
              onRatingUpdate: (rating) {
                userChef!.chef!.kitchenSkillsRating![skills.keys.toList()[index]] = rating;
              },
            )
          ],
        ),)
      ),
    );
  }
}


///This is redundant
///Just using for a test. Will remove in the future;
class ProfileKitchenSkillsView extends StatelessWidget {
  ProfileKitchenSkillsView({Key? key, required this.skills, this.ignoreGestures = false, required this.onRatingUpdate}) : super(key: key);

  final Map<String, dynamic> skills;
  final bool ignoreGestures;
  final Function(double, int) onRatingUpdate;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(skills.length, (index) =>
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(skills.keys.toList()[index]),
                    labelStyle: TextStyle(color: kLightSecondaryColor),
                  ),
                  RatingBar.builder(
                    initialRating: skills.values.toList()[index],
                    minRating: 1.0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ignoreGestures: ignoreGestures,
                    itemSize: 30,
                    unratedColor: Colors.grey.shade400,
                    itemPadding: EdgeInsets.symmetric(horizontal: 5.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star_rounded,
                      color: kPrimaryColor,
                    ),
                    onRatingUpdate: (rating) => onRatingUpdate(rating, index)
                  )
                ],
              ),)
      ),
    );
  }
}



