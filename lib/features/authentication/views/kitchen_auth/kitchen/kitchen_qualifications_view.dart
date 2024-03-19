import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:info_popup/info_popup.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/file_controller.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/location_picker_data.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/utils/custom_pickers/custom_pickers.dart';
import 'package:skibble/utils/files_handler.dart';

import '../../../../../../models/address.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/size_config.dart';
import '../../../../../../utils/validators.dart';
import '../../../controllers/auth_provider.dart';
import 'kitchen_register_page.dart';
class UserKitchenQualificationsDetailsView extends StatefulWidget {
  const UserKitchenQualificationsDetailsView({Key? key}) : super(key: key);

  @override
  State<UserKitchenQualificationsDetailsView> createState() => _UserKitchenQualificationsDetailsViewState();
}

class _UserKitchenQualificationsDetailsViewState extends State<UserKitchenQualificationsDetailsView> {


  String? foodHandlerCertification;
  String? foodLicense;
  @override
  void initState() {
    // TODO: implement initState

    var userChef = context.read<SkibbleAuthProvider>().signUpUserKitchen;

    // if(Provider.of<AppData>(context, listen: false).userCurrentLocation != null) {
    //   _currencyFuture = Future.value(Provider.of<AppData>(context, listen: false).userCurrentLocation);
    // }
    // else {
    //   _currencyFuture = getCurrencyBasedOnLocation();
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userChef = context.read<SkibbleAuthProvider>().signUpUserKitchen;
    var address = Provider.of<AppData>(context,).userCurrentLocation;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),

                    Text(
                      'This section helps us know if you have undergone a food hygiene training program in your city and if you have a government approved food license.',
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 15,),

                    //Kitchen name
                    Text(
                      'Upload Documents',
                      style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                    ),

                    SizedBox(height: getProportionateScreenHeight(25)),


                    Consumer<FilePickerController>(
                        builder: (context, data, child) {
                          var pickedFiles = data.pickedFiles;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [
                                  Text(
                                    'Food Handler\'s Certification',
                                    style: TextStyle(color: kDarkSecondaryColor, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),

                                  SizedBox(width: 6,),
                                  InfoPopupWidget(
                                    // contentTitle: 'A food handlers certification is a document or card that verifies an individual has completed a training program on safe food handling practices.',
                                    customContent: Container(
                                      width: 180,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 10),

                                      child: Text(
                                        'A food handlers certification is a document or card that verifies an individual has completed a training program on safe food handling practices.',
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                    arrowTheme: InfoPopupArrowTheme(
                                        color: Colors.grey.shade200
                                    ),
                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 3,),

                              Text(
                                'Upload a .pdf or .jpeg file of your food handler certificate.',
                                style: TextStyle(color: Colors.grey, fontSize: 13, ),
                              ),

                              SizedBox(height: 10,),

                              GestureDetector(
                                onTap: () async{

                                  if(pickedFiles['foodHandlerCertificate'] == null) {
                                    await data.pickFile('foodHandlerCertificate', ['jpg', 'pdf']);

                                  }
                                  else {
                                    data.removeFile('foodHandlerCertificate');
                                  }

                                },
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade200
                                  ),
                                  child: Stack(
                                    children: [
                                      if(pickedFiles['foodHandlerCertificate'] != null)
                                        Positioned(
                                            bottom: 20,
                                            right: 20,
                                            top: 20,
                                            left: 20,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Icon(Iconsax.document_1, color: Colors.grey.shade300, size: 50,),
                                                  Text(
                                                    pickedFiles['foodHandlerCertificate']!.first.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: Colors.grey),)
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            )
                                        ),


                                      Positioned(
                                          bottom: 4,
                                          right: 4,
                                          child: Container(
                                            child: pickedFiles['foodHandlerCertificate'] != null  ? Icon(Iconsax.trash, color: kErrorColor,) : Icon(Iconsax.document_1, color: kPrimaryColor,),
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: pickedFiles['foodHandlerCertificate'] == null  ? kPrimaryColor : kErrorColor, width: 1.5),

                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 30,),

                              ///Food license
                              Row(
                                children: [
                                  Text(
                                    'Food License/Permit',
                                    style: TextStyle(color: kDarkSecondaryColor, fontSize: 15, fontWeight: FontWeight.w600),
                                  ),

                                  SizedBox(width: 6,),
                                  InfoPopupWidget(
                                    // contentTitle: 'A food handlers certification is a document or card that verifies an individual has completed a training program on safe food handling practices.',
                                    customContent: Container(
                                      width: 180,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 10),

                                      child: Text(
                                        'A food license or permit is a document issued by a government agency that allows a business to legally operate and sell food products. It is not required in some countries.',
                                        style: TextStyle(color: Colors.blueGrey),
                                      ),
                                    ),
                                    arrowTheme: InfoPopupArrowTheme(
                                        color: Colors.grey.shade200
                                    ),
                                    child: Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.grey,
                                      size: 22,
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 3,),
                              Text(
                                'Upload a .pdf or .jpeg file of your food license.',
                                style: TextStyle(color: Colors.grey, fontSize: 13, ),
                              ),
                              SizedBox(height: 10,),

                              GestureDetector(
                                onTap: () async{

                                  if(pickedFiles['foodLicense'] == null) {
                                    await data.pickFile('foodLicense', ['jpg', 'pdf']);

                                  }
                                  else {
                                    data.removeFile('foodLicense');
                                  }

                                },
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.grey.shade200
                                  ),
                                  child: Stack(
                                    children: [
                                      if(pickedFiles['foodLicense'] != null)
                                        Positioned(
                                            bottom: 20,
                                            right: 20,
                                            top: 20,
                                            left: 20,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Icon(Iconsax.document_1, color: Colors.grey.shade300, size: 50,),
                                                  Text(
                                                    pickedFiles['foodLicense']!.first.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: Colors.grey),)
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            )
                                        ),

                                      Positioned(
                                          bottom: 4,
                                          right: 4,
                                          child: Container(
                                            child: pickedFiles['foodLicense'] != null  ? Icon(Iconsax.trash, color: kErrorColor,) : Icon(Iconsax.document_1, color: kPrimaryColor,),
                                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(color: pickedFiles['foodLicense'] == null  ? kPrimaryColor : kErrorColor, width: 1.5),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                    )
                  ],
                ),
              ),
            ),
          ),
        ),

        ControlButtons(
          onBackPressed: () {

          },
          onSkipPressed: () {

          },
          onNextPressed: () async{
            // print(userChef?.kitchen!.serviceLocation);
            if(userChef != null) {

              var res = await UserDatabaseService().updateChefQualificationDocuments(userChef.userId!, context.read<FilePickerController>().pickedFiles);
              if(res != null) {
                userChef.kitchen?.foodLicenseOrPermitDocUrl = res['foodLicense'];
                userChef.kitchen?.foodHandlerCertificationDocUrl = res['foodHandlerCertificate'];

                return 'success';
              }
              return 'error';
            }

            return 'error';

          },
        )

      ],
    );
  }
}
