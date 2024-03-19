import 'dart:io';
import 'dart:math' as math;
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/auth_controllers/sign_up_controller.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/models/skibble_user.dart';
import 'package:skibble/services/firebase/auth.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/features/authentication/controllers/auth_controller.dart';
import 'package:skibble/utils/helper_methods.dart';

import '../../../../../config.dart';
import '../../../../../services/preferences/preferences.dart';
import '../../../../../shared/custom_web_view.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/current_theme.dart';
import '../../../../../utils/size_config.dart';
import '../../../../../utils/validators.dart';
import '../../controllers/auth_provider.dart';
import '../../controllers/email_secure_storage.dart';
import '../chef_auth/components/default_button.dart';
import 'user_login_page.dart';

class UserRegisterPage extends StatelessWidget {
  const UserRegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Create an Account"),
      // ),
      body: Container(
        // margin: EdgeInsets.only(top: kToolbarHeight - 20, bottom: 20),
        child: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                Text("Join Skibble.", style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  fontWeight: FontWeight.bold,
                  // color: Colors.black,
                  height: 1.5,
                )),

                SizedBox(height: 10,),

                const Text(
                  "Get started by creating an account and completing the fields below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey)
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SignUpForm(showContinueButton: true,),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text:  "By clicking the continue button, you agree to our ",
                              style: CurrentTheme(context).isDarkMode ? Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey) : Theme.of(context).textTheme.caption
                          ),
                          TextSpan(
                              text:  "Terms of Use",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return CustomWebView(webUrl: APIKeys.termsOfUse, title: 'Terms of Use',);
                                  }));
                                },
                              style: TextStyle(color: kPrimaryColor)
                          ),
                          TextSpan(
                              text:  " and",

                              style: CurrentTheme(context).isDarkMode ? Theme.of(context).textTheme.caption!.copyWith(color: Colors.grey) : Theme.of(context).textTheme.caption
                          ),

                          TextSpan(
                              text:  " Privacy Policy.",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return CustomWebView(webUrl: APIKeys.privacyPolicy, title: 'Privacy Policy',);
                                  }));
                                },
                              style: TextStyle(color: kPrimaryColor)
                          ),
                        ]
                    )),

                SizedBox(height: SizeConfig.screenHeight * 0.03),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Divider(
                        thickness: 1.0,
                      ),
                    ),
                    SizedBox(width: 8,),

                    Text('Or Sign Up with', style: TextStyle(color: Colors.grey)),

                    SizedBox(width: 8,),

                    SizedBox(
                      width: 100,
                      child: Divider(
                        thickness: 1.0,
                      ),
                    ),

                  ],
                ),

                SizedBox(height: SizeConfig.screenHeight * 0.03),
                SizedBox(
                  // width: double.infinity,
                  height: getProportionateScreenHeight(40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape:
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: kDarkSecondaryColor)
                      ),
                      primary: Colors.white,
                      // backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      var result = await AuthService().signInWithGoogle(context);

                      if(result != null) {
                        //create their full name, username and sign them  up

                        // if(result.)
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/google_icon.svg',
                          width: getProportionateScreenWidth(18),
                          height: getProportionateScreenWidth(18),
                        ),
                        SizedBox(width: 10,),
                        Text(
                          'Google',
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            color: kDarkSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     // SocialCard(
                //     //   icon: "assets/icons/google_icon.svg",
                //     //   press: () async {
                //     //     var result = await AuthService().signInWithGoogle(context);
                //     //
                //     //   },
                //     // ),
                //
                //
                //
                //     ///
                //     // SocialCard(
                //     //   icon: "assets/icons/facebook_icon.svg",
                //     //   press: () {},
                //     // ),
                //     // SocialCard(
                //     //   icon: "assets/icons/apple_icon.svg",
                //     //   press: () {},
                //     // ),
                //   ],
                // ),
                const SizedBox(height: 10),

                const SizedBox(height: 10),

                if(Platform.isIOS)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      SizedBox(
                        // width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape:
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(color: kDarkSecondaryColor)
                            ),
                            primary: kDarkSecondaryColor,
                            // backgroundColor: Colors.blueAccent,
                          ),
                          onPressed: () async {
                            await AuthService().signOut();
                            var result = await AuthService().signInWithApple(context);


                            if(result != null) {
                              //create their full name, username and sign them  up

                              // if(result.)
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/apple_icon.svg',
                                width: getProportionateScreenWidth(18),
                                height: getProportionateScreenWidth(18),
                                color: kLightSecondaryColor,
                              ),
                              const SizedBox(width: 10,),
                              Text(
                                'Apple',
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(18),
                                  color: kLightSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 10,),

                      //apple sign in
                      // SizedBox(
                      //   // width: double.infinity,
                      //   height: getProportionateScreenHeight(56),
                      //   child: TextButton(
                      //     style: TextButton.styleFrom(
                      //       shape:
                      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      //       primary: Colors.white,
                      //       backgroundColor: Colors.black,
                      //     ),
                      //     onPressed: () {},
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         CircleAvatar(
                      //           backgroundColor: kLightSecondaryColor,
                      //           radius: 15,
                      //           child: SvgPicture.asset(
                      //             'assets/icons/apple_icon.svg',
                      //             width: getProportionateScreenWidth(15),
                      //             height: getProportionateScreenWidth(15),
                      //           ),
                      //         ),
                      //         SizedBox(width: 10,),
                      //         Text(
                      //           'Apple',
                      //           style: TextStyle(
                      //             fontSize: getProportionateScreenWidth(18),
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),


                      ///

                      // SocialCard(
                      //   icon: "assets/icons/google_icon.svg",
                      //   press: () async{
                      //     var result = await AuthService().signInWithGoogle(context);
                      //
                      //     if(result != null) {
                      //create their full name, username and sign them  up

                      // if(result.)
                      // }
                      //   },
                      // ),
                      // SocialCard(
                      //   icon: "assets/icons/facebook_icon.svg",
                      //   press: () {},
                      // ),

                      // SocialCard(
                      //   icon: "assets/icons/apple_icon.svg",
                      //   press: () {},
                      // ),


                      const SizedBox(height: 20),

                    ],
                  ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                    ),
                    GestureDetector(
                      onTap: ()
                      {
                        //switch to sign up
                        context.read<SkibbleAuthProvider>().isOnSignUpPage = false;

                        //pop the context
                        // Navigator.pop(context);

                        // Navigator.of(context).pushReplacement(MaterialPageRoute(
                        //     builder: (context) => LoginPage()));
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(16),
                            color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key, required this.showContinueButton}) : super(key: key);
  final bool showContinueButton;

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signUpFormKey,
      child: Consumer<SkibbleAuthProvider>(
        builder: (context, data, child) {
          return Column(
            children: [
              //fullName
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (newValue) => data.fullName = newValue,
                onChanged: (value) {
                  // if (value.isNotEmpty) {
                  //   removeError(error: 'kEmailNullError');
                  // } else if (EmailValidator.validate(value)) {
                  //   removeError(error: 'kInvalidEmailError');
                  // }
                  // return null;
                },
                validator: Validator().validateFullName,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                  // If  you are using latest version of flutter then label text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Iconsax.user),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),

              //userName
              TextFormField(
                keyboardType: TextInputType.text,
                onSaved: (newValue) => data.userName = newValue,

                onChanged: (value) {
                  // if (value.isNotEmpty) {
                  //   removeError(error: 'kEmailNullError');
                  // } else if (EmailValidator.validate(value)) {
                  //   removeError(error: 'kInvalidEmailError');
                  // }
                  // return null;
                },
                validator: Validator().validateUserName,

                decoration: InputDecoration(
                  labelText: "User Name",
                  hintText: "Enter your username",
                  errorText: context.read<SkibbleAuthProvider>().userNameErrorText,

                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Iconsax.user),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(30)),

              //email
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                onSaved: (newValue) => data.email = newValue,
                onChanged: (value) {
                  // if (value.isNotEmpty) {
                  //   removeError(error: 'kEmailNullError');
                  // } else if (EmailValidator.validate(value)) {
                  //   removeError(error: 'kInvalidEmailError');
                  // }
                  // return null;
                },
                validator: Validator().validateEmail,
                decoration: InputDecoration(
                  labelText: "Email",
                  hintText: "Enter your email",
                  // If  you are using latest version of flutter then lable text and hint text shown like this
                  // if you r using flutter less then 1.20.* then maybe this is not working properly
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(
                  height: getProportionateScreenHeight(30)
              ),

              //password
              TextFormField(
                obscureText: data.isPasswordObscured,
                onSaved: (newValue) => data.password = newValue,
                onChanged: (value) {
                  // if (value.isNotEmpty) {
                  //   removeError(error: 'kPassNullError');
                  // } else if (value.length >= 8) {
                  //   removeError(error: 'kShortPassError');
                  // }
                  // password = value;
                },
                validator: Validator().validatePassword,

                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter your password",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: GestureDetector(
                    dragStartBehavior: DragStartBehavior.down,
                    onTap: () {
                      data.isPasswordObscured = !data.isPasswordObscured;
                    },
                    child: Icon(
                      data.isPasswordObscured? Icons.visibility_off:
                      Icons.visibility,
                      color: data.isPasswordObscured ? Colors.grey : kPrimaryColor,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: getProportionateScreenHeight(30)),
              // buildConformPassFormField(),
              SizedBox(height: getProportionateScreenHeight(40)),
             widget.showContinueButton ?
             Consumer<LoadingController>(
               builder: (context, data, child) {
                 return DefaultButton(
                  text: "Continue",
                   isPressed: data.isLoading,
                   press: () async{
                     final form = _signUpFormKey.currentState;

                     if(form!.validate()) {
                         form.save();
                         int timestamp = DateTime.now().millisecondsSinceEpoch;

                         SkibbleUser newSwiftMenuUser = SkibbleUser(
                             fullName:  context.read<SkibbleAuthProvider>().fullName,
                             userName:  context.read<SkibbleAuthProvider>().userName!.toLowerCase(),
                             userEmailAddress:  context.read<SkibbleAuthProvider>().email,
                             userPassword:  context.read<SkibbleAuthProvider>().password,
                             isActive: true,
                             timeLastActive: timestamp,
                             accountCreatedAt: timestamp,
                             lastLoginTimeStamp: timestamp,
                             userCustomColor: HelperMethods().generateRandomColor()
                             // userCustomColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
                         );

                         await AuthController().createUserAccountWithEmailAndPassword(newSwiftMenuUser, context, formState: _signUpFormKey.currentState);
                     }
                      // await createUserAccountWithEmailAndPassword(newSwiftMenuUser);
                    },
                  );
               }
             ) : Container(),
            ],
          );
        }
      ),
    );
  }


  // createUserAccountWithEmailAndPassword(SkibbleUser newSwiftMenuUser) async{
  //   final form = _signUpFormKey.currentState;
  //
  //   if(form!.validate()) {
  //     form.save();
  //     // CustomDialog(context).showProgressDialog('Creating your New Account');
  //     context.read<LoadingController>().isLoading = true;
  //
  //     bool result = await UserDatabaseService().checkIfThereIsAnExistingUserName( context.read<SkibbleAuthProvider>().userName!);
  //
  //     if(result) {
  //       // Navigator.pop(context);
  //       context.read<LoadingController>().isLoading = false;
  //
  //       context.read<SkibbleAuthProvider>().userNameErrorText = 'Username has already been taken. Try another name.';
  //       // CustomDialog(context).showErrorDialog('Username Exists', 'This username has already been taken.');
  //     }
  //     else {
  //       var emailSecureStore = Provider.of<EmailSecureStore>(context, listen: false);
  //       await emailSecureStore.setEmail(context.read<SkibbleAuthProvider>().email!);
  //       dynamic result = await AuthService().registerUserWithEmailAndPassword(newSwiftMenuUser);
  //
  //
  //       if(result == 'Email-Already-In-Use') {
  //         // Navigator.of(context).pop();
  //         context.read<LoadingController>().isLoading = false;
  //
  //         CustomDialog(context).showErrorDialog('Error Creating Account', 'The email you provided has already been used to create an account.');
  //
  //       }
  //
  //       else if(result == null) {
  //         // Navigator.of(context).pop();
  //         context.read<LoadingController>().isLoading = false;
  //
  //         CustomDialog(context).showErrorDialog('Unable to Create Account', 'Unable to create an account at the moment. Try again later.');
  //       }
  //
  //       else {
  //         // Navigator.of(context).pop();
  //         // context.read<LoadingController>().isLoading = false;
  //
  //         var preferences = await Preferences.getInstance();
  //         await preferences.setFirstTimeEmailVerifiedKey(false);
  //         await preferences.setCurrentUserIdKey(result.uid);
  //         // await AuthService().sendEmailVerification();
  //         // await AuthService().signInWithEmailAndPassword(email!, password!);
  //         //
  //
  //         ///calling this sends us to verify email screen
  //         // Navigator.of(context).popUntil((route) => route.isFirst);
  //         // Provider.of<AppData>(context, listen: false).updateUser(newSwiftMenuUser);
  //
  //         // Phoenix.rebirth(context);
  //         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserFoodPreferencesView(user: newSwiftMenuUser,)));
  //
  //         ///Show verify user email
  //
  //
  //
  //         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyUserEmailView(currentUser: newSwiftMenuUser,)));
  //
  //       }
  //     }
  //
  //   }
  // }

}
