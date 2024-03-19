import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/services/change_data_notifiers/app_data.dart';
import 'package:skibble/services/firebase/auth.dart';
import 'package:skibble/services/preferences/preferences.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/splash_screen.dart';
import 'package:skibble/features/authentication/controllers/auth_provider.dart';

import '../../../../../config.dart';
import '../../../../../shared/custom_web_view.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/current_theme.dart';
import '../../../../../utils/size_config.dart';
import '../../../../../utils/validators.dart';
import '../../controllers/email_secure_storage.dart';
import '../chef_auth/components/default_button.dart';
import '../shared_screens/reset_password_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var authService = context.read<AuthProvider>();

    // SizeConfig().init(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign In"),
      // ),
      body: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight * 0),
        child: Body(),
      ),
    );
  }
}


class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome!",
                  style: TextStyle(
                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                    fontSize: getProportionateScreenWidth(30),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10,),
                const Text(
                  "Sign in with the email and password associated with your account.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.06),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: [
                          TextSpan(
                              text:  "By clicking the \"Sign In\" button, you agree to our ",
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
                              style: const TextStyle(color: kPrimaryColor)
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
                              style: const TextStyle(color: kPrimaryColor)
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

                    Text('Or Sign In with', style: TextStyle(color: Colors.grey)),

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
                          primary: Colors.white,
                          // backgroundColor: Colors.blueAccent,
                        ),
                        onPressed: () async {
                          await AuthService().signOut();
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
                            const SizedBox(width: 10,),
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
                  ],
                ),

                SizedBox(height: 10),

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
                      "Don’t have an account? ",
                      style: TextStyle(fontSize: getProportionateScreenWidth(16)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Provider.of<AuthProvider>(context, listen: false).isLoggingIn = false;
                        context.read<SkibbleAuthProvider>().isOnSignUpPage = true;
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserRegisterPage()));
                      },
                      child: Text(
                        "Sign Up",
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

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _signInFormKey = GlobalKey<FormState>();

  String? email;
  String? password;
  bool _isObscureText = true;

  bool? remember = false;
  final List<String?> errors = [];
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signInFormKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              // if (value.isNotEmpty) {
              //   removeError(error: 'kEmailNullError');
              // } else if (EmailValidator.validate(value)) {
              //   removeError(error: 'kInvalidEmailError');
              // }
              // return null;
            },
            validator: Validator().validateEmail,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomSuffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          TextFormField(
            obscureText: _isObscureText,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              // if (value.isNotEmpty) {
              //   removeError(error: 'Password cannot be empty');
              // } else if (value.length >= 8) {
              //   removeError(error: 'Password cannot be less than 8 characters');
              // }
              // return null;
            },
            validator: Validator().validatePassword,
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onTap: () {
                  setState(() {
                    _isObscureText = !_isObscureText;
                  });
                },
                child: Icon(
                  _isObscureText ? Icons.visibility_off :
                  Icons.visibility,
                  color: _isObscureText ? Colors.grey : kPrimaryColor,
                ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ForgotPasswordView()));
              },
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                    color: kPrimaryColor
                ),
              ),
            ),
          ),
          // FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          Consumer<LoadingController>(
            builder: (context, data, child) {
              return DefaultButton(
                text: "Sign In",
                isPressed: data.isLoading,
                press: () async {
                  await loginUser();
                },
              );
            }
          ),
        ],
      ),
    );
  }

  loginUser() async {
    final form = _signInFormKey.currentState;

    var auth = context.read<SkibbleAuthProvider>();

    if (form!.validate()) {
      form.save();
      context.read<LoadingController>().isLoading = true;

      var emailSecureStore = Provider.of<EmailSecureStore>(context, listen: false);
      await emailSecureStore.setEmail(email!);

      dynamic result = await AuthService().signInWithEmailAndPassword(email!, password!);

      if (result == 'Not-Found') {
        context.read<LoadingController>().isLoading = false;

        // Navigator.of(context).pop();
        CustomDialog(context).showErrorDialog(
            'User Not Found', 'This user was not found in our database.');
      }

      else if (result == 'Wrong-Password') {
        context.read<LoadingController>().isLoading = false;

        // Navigator.of(context).pop();
        CustomDialog(context).showErrorDialog(
            'Incorrect Password', 'The password you provided is incorrect.');

      }

      else if (result == null) {
        context.read<LoadingController>().isLoading = false;

        // Navigator.of(context).pop();
        CustomDialog(context).showErrorDialog('Unable to Login',
            'Unable to login into your account at the moment. Please try again later.');
      }

      else {
        // Navigator.of(context).pop();
        await Preferences.getInstance().setCurrentUserIdKey(result.uid);
        // Navigator.of(context).pop();

        // if(mounted) {
        //   Provider.of<AuthProvider>(context, listen: false).isLoading = false;
        // }
        // Get.offAll(() => SplashScreen());
        // await Phoenix.rebirth(context);
      }
    }
  }
}
