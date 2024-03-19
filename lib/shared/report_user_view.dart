import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/report_user.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/custom_app_bar.dart';

import '../localization/app_translation.dart';
import '../services/change_data_notifiers/app_data.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import 'dialogs.dart';

class ReportUserView extends StatefulWidget {
  const ReportUserView({Key? key, required this.reportedUserId}) : super(key: key);
  final String reportedUserId;

  @override
  State<ReportUserView> createState() => _ReportUserViewState();
}

class _ReportUserViewState extends State<ReportUserView> {
  int choice = 0;
  final _formKey = GlobalKey<FormState>();
  String message = '';

  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Report User',
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 15, bottom: 0, right: 20),
                child: Text(
                  'Reason for reporting',
                  style: TextStyle(fontSize: 20),
                ),
              ),

              const Divider(),

              RadioListTile<int>(
                  value: 0,
                  activeColor: kPrimaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  isThreeLine: true,
                  subtitle: const Text('Includes sexually explicit content, violence, hate, illegal activity, advertising, and so on.', style: TextStyle(color: Colors.grey),),

                  groupValue: choice,

                  title: const Text('Inappropriate Content'),
                  onChanged:(value) {
                    if(value != choice) {
                      setState(() {
                        choice = value!;
                        message = 'Inappropriate Content';
                      });

                    }
                  }),

              RadioListTile<int>(
                  value: 1,
                  activeColor: kPrimaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  isThreeLine: true,
                  subtitle: const Text('Includes offensive use of words, hate speech, harmful words, and so on.', style: TextStyle(color: Colors.grey),),
                  groupValue: choice,

                  title: const Text('Abusive Language'),
                  onChanged:(value) {
                    if(value != choice) {
                      setState(() {
                        choice = value!;
                        message = 'Abusive Language';

                      });

                    }
                  }),

              RadioListTile<int>(
                  value: 2,
                  activeColor: kPrimaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  isThreeLine: true,
                  subtitle: const Text('I think this user is not a real person.', style: TextStyle(color: Colors.grey),),

                  groupValue: choice,

                  title: const Text('User is a bot'),
                  onChanged:(value) {
                    if(value != choice) {
                      setState(() {
                        choice = value!;
                        message = 'User is a bot';
                      });

                    }
                  }),

              RadioListTile<int>(
                  value: 3,
                  activeColor: kPrimaryColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  isThreeLine: true,
                  subtitle: const Text('My reason for reporting this user was not listed above.', style: TextStyle(color: Colors.grey),),

                  groupValue: choice,

                  title: const Text('Other'),
                  onChanged:(value) {
                    if(value != choice) {
                      setState(() {
                        choice = value!;
                      });

                    }
                  }),

             choice == 3 ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (newValue) => message = newValue!,
                      maxLines: 8,
                      validator: (value) => Validator().validateText(value, 'Please enter a message'),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Theme.of(context).backgroundColor,
                                width: 1
                            )
                        ),
                        hintText: 'Enter your reason for reporting this user here',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        // suffixIcon: Icon(Iconsax.user),
                      ),
                    ),

                    const SizedBox(height: 20,),
                  ],
                ),
              ) : Container(),


              Center(
                child: ElevatedButton(
                    onPressed: () async{
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        CustomDialog(context).showProgressDialog(context, tr.sending);

                        ReportUser report = ReportUser(
                            reasonForReport: message,
                            reportedUserId: widget.reportedUserId,
                            reporterId: currentUser.userId!,
                            reportId: '',
                            timeReported: DateTime.now().millisecondsSinceEpoch
                        );

                        var result = await UserDatabaseService().reportUser(report);

                        if(result) {
                          Navigator.of(context).pop();

                          CustomDialog(context).showCustomMessage(tr.success, '${tr.thankYouForReportingThisUser}!\n\n${tr.weWillLookIntoYourReportAndTakeTheNecessaryActions}');

                        }

                        else {
                          Navigator.of(context).pop();

                          CustomDialog(context).showErrorDialog(tr.error, '${tr.unableToSentRequestMessage}.');

                        }
                      }
                    },

                    child: Text(tr.submit.toUpperCase(), style: const TextStyle(color: kLightSecondaryColor))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
