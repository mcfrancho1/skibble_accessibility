import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble_accessibility/features/authentication/views/shared_screens/update_email_address.dart';



import '../../../../../services/firebase/auth_services/skibble_auth_service.dart';
import '../../../../services/change_data_notifiers/app_data.dart';
import '../../../../services/firebase/auth.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import '../../controllers/auth_provider.dart';
import '../../controllers/email_link_handler.dart';


class VerifyUserEmailView extends StatefulWidget {
  //

  const VerifyUserEmailView({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyUserEmailView> createState() => _VerifyUserEmailViewState();
}

class _VerifyUserEmailViewState extends State<VerifyUserEmailView> {

  Timer? timer;
  // final GlobalKey<ScaffoldState> _verifyEmailKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // initDynamicLinks();
    context.read<SkibbleAuthProvider>().initVerifyEmailTimer(context);
    // timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //     context.read<SkibbleAuthProvider>().checkIfUserEmailIsVerified(context);
    //
    // });

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // context.read<SkibbleAuthProvider>().cancelVerifyEmailTimer(context);
  }




  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser!;
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20,),
                      Center(
                        child: Text(
                            'Verify your email address',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                          fontSize: getProportionateScreenWidth(24),

                          fontWeight: FontWeight.bold,
                          // color: Colors.black,
                          height: 1.5,
                        )),
                      ),
                      const SizedBox(height: 30,),


                      //TODO: Change the image here to verify email
                      Container(
                        width: double.infinity,
                        height: size.height / 4.7,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/verify_email.png'
                                )
                            )
                        ),
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.05),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Center(
                          child: Text(
                            'A verification email was automatically sent to ${HelperMethods().obfuscateEmailPartially(currentUser.userEmailAddress ??currentUser.userEmailAddress!)}.' ,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'Brand Regular',
                                color: Colors.grey
                            ),
                            // textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: SizeConfig.screenHeight * 0.04),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(

                          'You\'ll be automatically redirected once you verify.',
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Brand Regular',
                              color: Colors.grey
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 10,),

                      Center(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: kDarkColor,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            onPressed: () async{
                              await AuthService().sendEmailVerification();

                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: kPrimaryColor,
                                    content: currentUser.userEmailAddress != null? Text(
                                      'A verification link has been sent to ${HelperMethods().obfuscateEmailPartially(currentUser.userEmailAddress!)}.Please click the link to verify your email.',
                                    )
                                        :
                                    const Text(
                                      'A verification link has been sent to you. Please click the link to verify your email.',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ));

                              // Future.delayed(const Duration(seconds: 10), () {
                              //   setState(() {
                              //     showSignUPAgain = true;
                              //   });
                              // });

                            },
                            child: const Text(
                              'Resend Email',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: kLightSecondaryColor
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 60,),

                      SizedBox(height: SizeConfig.screenHeight * 0.03),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                              child: Text(
                                'Didn\'t receive any email ? Check your spam folder' ,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),)),
                          SizedBox(height: SizeConfig.screenHeight * 0.02),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Divider(
                                  thickness: 0.5,
                                  // color: kGreyColor,

                                ),
                              ),
                              SizedBox(width: 8,),

                              Text('OR', style: TextStyle(color: Colors.grey)),

                              SizedBox(width: 8,),

                              SizedBox(
                                width: 100,
                                child: Divider(
                                  thickness: 0.5,
                                  // color: kGreyColor,
                                ),
                              ),

                            ],
                          ),

                          SizedBox(height: SizeConfig.screenHeight * 0.005),

                          Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  primary: kPrimaryColor,
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20)
                              ),
                              onPressed: () async{
                                var result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return const UpdateEmailAddressView();
                                }));

                                if(result != null) {
                                  setState(() {

                                  });
                                }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Change your email address', ),
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
          ),
        ),
      ),
    );
  }
}
