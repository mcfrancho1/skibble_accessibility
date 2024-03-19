import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:skibble/models/contact_us_model.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/features/customer_support/services/customer_support_database.dart';
import 'package:skibble/shared/custom_app_bar.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/utils/constants.dart';

import '../../localization/app_translation.dart';
import '../../services/change_data_notifiers/app_data.dart';
import '../../utils/validators.dart';

class SharedCustomeSupportInquiryView extends StatefulWidget {
  const SharedCustomeSupportInquiryView({Key? key, required this.contactType}) : super(key: key);
  final CustomerSupportInquiryType contactType;

  @override
  State<SharedCustomeSupportInquiryView> createState() => _SharedCustomeSupportInquiryViewState();
}

class _SharedCustomeSupportInquiryViewState extends State<SharedCustomeSupportInquiryView> {


  String message = '';
  String title = '';


  late final Map<String, String> hintMessage;
  late final Map<String, String> titleMessage;
  late final Map<String, String> appBarTitles;

  late final TextEditingController titleController;
  late final TextEditingController messageController;


  @override
  void initState() {
    titleController = TextEditingController();
    messageController = TextEditingController();

    appBarTitles = {
      CustomerSupportInquiryType.help.name: tr.help,
      CustomerSupportInquiryType.privacyQuestion.name: tr.privacyQuestion,
      CustomerSupportInquiryType.suggestion.name: tr.suggestion,
      CustomerSupportInquiryType.bug.name: tr.discoveredProblem,
      CustomerSupportInquiryType.featureRequest.name: tr.featureRequest,

    };

    titleMessage = {
      CustomerSupportInquiryType.help.name: tr.whatDoYouNeedHelpWith,
      CustomerSupportInquiryType.privacyQuestion.name: tr.whatPrivacyQuestionDoYouHaveForUs,
      CustomerSupportInquiryType.suggestion.name: tr.whatSuggestionsDoYouHaveForUs,
      CustomerSupportInquiryType.bug.name: tr.describeTheProblemYouDiscovered,
      CustomerSupportInquiryType.featureRequest.name: tr.whatFeatureWouldYouLikeUsToInclude,

    };

    hintMessage = {
      CustomerSupportInquiryType.help.name: tr.pleaseProvideADescriptionOfWhatYouNeedHelpWith,
      CustomerSupportInquiryType.privacyQuestion.name: tr.enterYourPrivacyQuestionHere,
      CustomerSupportInquiryType.suggestion.name: tr.tellUsAboutYourSuggestions,
      CustomerSupportInquiryType.bug.name: tr.pleaseProvideADescriptionOfTheProblem,
      CustomerSupportInquiryType.featureRequest.name: tr.describeTheFeaturesYouWantOnSkibble,

    };
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    messageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Scaffold(
      appBar: CustomAppBar(
        title: appBarTitles[widget.contactType.name]!,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const SizedBox(height: 20,),

                  const Text(
                    'Title',
                    style: TextStyle(
                        fontSize: 18
                    ),
                  ),

                  const SizedBox(height: 15,),


                  // title
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (newValue) => title = newValue!,
                    controller: titleController,
                    maxLines: 1,
                    validator: (value) => Validator().validateText(value, 'Please enter a title'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                              width: 1
                          )
                      ),
                      hintText: 'e.g Account Recovery',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // suffixIcon: Icon(Iconsax.user),
                    ),
                  ),


                  const SizedBox(height: 20,),

                  Text(
                    titleMessage[widget.contactType.name]!,
                    style: const TextStyle(
                        fontSize: 18
                    ),
                  ),

                  const SizedBox(height: 15,),

                  // description
                  TextFormField(
                    keyboardType: TextInputType.text,
                    onSaved: (newValue) => message = newValue!,
                    controller: messageController,
                    maxLines: 10,
                    validator: (value) => Validator().validateText(value, 'Please enter a message'),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: Theme.of(context).backgroundColor,
                              width: 1
                          )
                      ),
                      hintText: hintMessage[widget.contactType.name]!,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      // suffixIcon: Icon(Iconsax.user),
                    ),
                  ),

                  const SizedBox(height: 20,),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async{
                        if(_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          CustomBottomSheetDialog.showProgressSheet(context);

                          CustomerSupportInquiry inquiry = CustomerSupportInquiry(
                              customerSupportInquiryType: widget.contactType,
                              userId: currentUser.userId!,
                              description: message,
                              title: title,
                              timestamp: DateTime.now().millisecondsSinceEpoch, skibbleUser: currentUser
                          );

                          var result = await ContactDatabaseService().sendCustomerSupportMessage(inquiry, context);

                          Navigator.of(context).pop();

                          if(result) {

                            titleController.clear();
                            messageController.clear();
                            await CustomDialog(context).showCustomMessage(
                                tr.success,
                                '${tr.thankYouForContactingUs}!\n\n${tr.weWillLookIntoYourRequestAndContactYouAsSoonAsPossible}.',

                            );



                          }

                          else {
                            await CustomDialog(context).showErrorDialog(tr.error, '${tr.unableToSentRequestMessage}.');

                          }
                        }
                      },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                      child: Text(tr.submit.toUpperCase(), style: const TextStyle(color: kLightSecondaryColor),)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
