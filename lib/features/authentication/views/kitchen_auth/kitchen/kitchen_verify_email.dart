import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/skibble_user.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/firebase/auth.dart';
import '../../../../../../services/firebase/auth_services/skibble_auth_service.dart';
import '../../../../../../services/firebase/database/user_database.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/helper_methods.dart';
import '../../../../../../utils/size_config.dart';
import '../../../controllers/auth_provider.dart';
import 'kitchen_reset_basic_details.dart';


class ChefVerifyEmail extends StatefulWidget {
  const ChefVerifyEmail({
    Key? key,
    this.userName,
     this.email,
    this.user,
    this.isStartScreen = false
  }) : super(key: key);

  final String? userName;
  final String? email;
  final SkibbleUser? user;
  final bool isStartScreen;

  @override
  State<ChefVerifyEmail> createState() => _ChefVerifyEmailState();
}

class _ChefVerifyEmailState extends State<ChefVerifyEmail> {

  final FirebaseAuth _auth = FirebaseAuth.instance;


  Timer? timer;
  AuthService authService = AuthService();
  User? user;

  final GlobalKey<ScaffoldState> _verifyEmailKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var authService = Provider.of<SkibbleAuthProvider>(context, listen: false);

    // initDynamicLinks();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkIfUserEmailIsVerified(authService.authService);

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer!.cancel();
  }


  Future<void> checkIfUserEmailIsVerified(SkibbleAuthService authService) async {

    await authService.reload(context);

    var user = await authService.currentUser();

    if(user!.isEmailVerified!) {
      //TODO:Save user to Stripe Connect
      await UserDatabaseService().updateUserIsEmailVerified(user.userId!);
      //TODO:Save user to Stripe Connect
      timer!.cancel();
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => UserFoodPreferencesView(user: user,)));

    }
  }

  bool showSignUPAgain = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var userChef = Provider.of<AppData>(context,).currentUserChef;


    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                              "Almost Done!", style: TextStyle(
                            fontSize: getProportionateScreenWidth(20),
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                            height: 1.5,
                          )),
                          SizedBox(height: 10,),

                          //TODO: Change this Image
                          Text(
                              "We promise this is the last step and you\'re good to go.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)
                          ),


                          SizedBox(height: SizeConfig.screenHeight * 0.02),

                          //TODO: Change the image here to verify email
                          Container(
                            width: double.infinity,
                            height: size.height / 6,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/verify_email.png'
                                    )
                                )
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight * 0.05),

                          SizedBox(height: SizeConfig.screenHeight * 0.01),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Text(

                              'A verification email was automatically sent to ${HelperMethods().obfuscateEmailPartially(widget.email != null ? widget.email! : userChef!.userEmailAddress!)}.' ,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Brand Regular',
                                  color: Colors.grey
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight * 0.04),

                          Text(

                            'You\'ll be automatically redirected to the home page once you verify.',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Brand Regular',
                                color: Colors.grey
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                              ),
                              onPressed: () async{
                                user =  _auth.currentUser;
                                await user!.sendEmailVerification();

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: kPrimaryColor,
                                      content: widget.email != null? Text(
                                        'A verification link has been sent to ${HelperMethods().obfuscateEmailPartially(widget.email != null ? widget.email! : userChef!.userEmailAddress!)}.Please click the link to verify your email.',
                                      )
                                          :
                                      Text(
                                        'A verification link has been sent to you. Please click the link to verify your email.',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ));

                                Future.delayed(Duration(seconds: 10), () {
                                  setState(() {
                                    showSignUPAgain = true;
                                  });
                                });

                              },
                              child: Text(
                                'Resend Email',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: kLightSecondaryColor
                                ),
                              ),
                            ),
                          ),
                          // SizedBox(height: 60,),

                          SizedBox(height: SizeConfig.screenHeight * 0.03),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                    'Didn\'t receive any email ? Check your spam folder' ,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey),)),
                              SizedBox(height: SizeConfig.screenHeight * 0.02),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Divider(
                                      thickness: 1.0,
                                    ),
                                  ),
                                  SizedBox(width: 8,),

                                  Text('OR', style: TextStyle(color: Colors.grey)),

                                  SizedBox(width: 8,),

                                  SizedBox(
                                    width: 100,
                                    child: Divider(
                                      thickness: 1.0,
                                    ),
                                  ),

                                ],
                              ),

                              SizedBox(height: SizeConfig.screenHeight * 0.005),

                              Center(
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      primary: kPrimaryColor,
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                                  ),
                                  onPressed: () {
                                    //TODO: Work on the logic here to send user to the appropriate page based on their registration choice
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
                                      return ChefResetBasicDetails(customUser: userChef,);
                                    }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Edit Login Details.', ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ),
          ),
        ),
      ],
    );
  }
}
