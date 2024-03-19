import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/custom_app_bar.dart';


import 'dart:math' as math;

import '../../../../../../models/skibble_user.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/firebase/database/user_database.dart';
import '../../../../../../services/preferences/preferences.dart';
import '../../../../../../shared/dialogs.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/current_theme.dart';
import '../../../../../../utils/validators.dart';
import '../../../controllers/auth_provider.dart';
import '../../../controllers/auth_provider.dart';
import '../../../controllers/auth_provider.dart';
import '../../shared_screens/user_food_preferences.dart';

class SetFullNameUserNameView extends StatefulWidget {
  const SetFullNameUserNameView({Key? key,
    // required this.credential,
    required this.currentUser}) : super(key: key);

  // final UserCredential credential;
  final SkibbleUser currentUser;

  @override
  State<SetFullNameUserNameView> createState() => _SetFullNameUserNameViewState();
}

class _SetFullNameUserNameViewState extends State<SetFullNameUserNameView> {

  String? fullName, userName, userNameErrorText;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    fullName = widget.currentUser.fullName;
    userName =widget.currentUser.userName;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Profile Info', style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const LinearProgressIndicator(value: 0.5,),

            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),

                    const Text(
                      'Almost done! choose your Skibble username.',
                      style: TextStyle(fontSize: 14, color: Colors.blueGrey, fontWeight: FontWeight.w100),),

                    // Text('Full Name', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                    const SizedBox(height: 25,),

                    TextFormField(
                        onSaved: (value) => fullName = value,
                        initialValue: fullName,
                        validator: Validator().validateFullName,
                        //onFieldSubmitted: widget.onFieldSubmitted,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                            fontFamily: 'Brand Regular',
                            fontWeight: FontWeight.w300
                        ),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16, color: Colors.grey),
                          hintText: 'e.g. John Mark',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          // labelStyle: TextStyle(fontWeight: FontWeight.bold,
                          //   fontSize: 20,
                          //   color: kDarkSecondaryColor
                          // ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),

                          labelText: 'Full Name',
                          focusedBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(

                                  color: kPrimaryColor,
                                  width: 1
                              )
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: kDarkSecondaryColor,
                                  width: 1
                              )
                          ),
                          // focusedBorder: ,
                          prefixIcon: const Padding(
                            child: Icon(Iconsax.user, size: 18,),
                            padding: EdgeInsets.only(left: 20, right: 20),
                          ),
                        )

                    ),

                    // SizedBox(height: 25,),
                    //
                    // Text('User Name', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),

                    const SizedBox(height: 20,),

                    TextFormField(
                        onSaved: (value) => userName = value,
                        initialValue: userName,
                        validator: Validator().validateUserName,
                        //onFieldSubmitted: widget.onFieldSubmitted,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(
                            fontFamily: 'Brand Regular',
                            fontWeight: FontWeight.w300
                        ),
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 16, color: Colors.grey),
                          hintText: 'e.g. ${widget.currentUser.fullName != null ? widget.currentUser.fullName!.split(" ")[0].toLowerCase() : 'mark'}',
                          contentPadding: const EdgeInsets.symmetric(vertical: 15),
                          labelText: 'Username',
                          errorText: userNameErrorText,
                          // labelStyle: TextStyle(fontWeight: FontWeight.w300,
                          //     fontSize: 20,
                          //     color: kDarkSecondaryColor
                          // ),
                          focusedBorder: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(

                                  color: kPrimaryColor,
                                  width: 1
                              )
                          ),

                          border: OutlineInputBorder(

                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                  color: kDarkSecondaryColor,
                                  width: 1
                              )
                          ),
                          prefixIcon: const Padding(
                            child: Icon(Icons.alternate_email, size: 18,),
                            padding: EdgeInsets.only(left: 10, right: 10),
                          ),
                        )

                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20,),

            Center(
              child: ElevatedButton(

                onPressed: () async {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();

                    CustomDialog(context).showProgressDialog(context, 'Processing');

                    int timestamp = DateTime.now().millisecondsSinceEpoch;

                    userName = userName!.trim().toLowerCase();

                    bool checkUserName = await UserDatabaseService().checkIfThereIsAnExistingUserName(userName!);

                    if(checkUserName) {
                      Navigator.pop(context);
                      setState(() {
                        userNameErrorText = 'Username has already been taken. Try another name.';

                      });
                      // CustomDialog(context).showErrorDialog('Username Exists', 'This username has already been taken.');
                    }

                    else {
                      widget.currentUser.fullName = fullName;
                      widget.currentUser.userName = userName;
                      var result = await UserDatabaseService().updateUserData(widget.currentUser);

                      if(result == 'success') {

                        var preferences = await Preferences.getInstance();
                        await preferences.setFirstTimeEmailVerifiedKey(false);
                        await preferences.setCurrentUserIdKey(widget.currentUser.userId);

                        Navigator.of(context).pop();
                        Provider.of<AppData>(context, listen: false).updateUser(widget.currentUser);
                        var skibbleAuthProvider = Provider.of<SkibbleAuthProvider>(context, listen: false);
                        await skibbleAuthProvider.authService.reload(context);

                        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserFoodPreferencesView( user: widget.currentUser,)));

                      }
                      else {
                        Navigator.pop(context);
                        CustomDialog(context).showErrorDialog('Oops!', 'We\'re unable to store your information.\n\nTry again later or contact us at hello@skibble.app.');

                      }
                    }

                  }

                },
                child: const Text(
                  'Save profile', style: TextStyle(
                    fontSize: 17,
                    color: kLightSecondaryColor
                ),
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),

                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
