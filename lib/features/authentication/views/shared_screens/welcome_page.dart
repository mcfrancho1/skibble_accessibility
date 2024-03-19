import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../../controllers/auth_provider.dart';
import '../user/user_auth_page.dart';


class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late ImageProvider image1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // image1 = const AssetImage('assets/images/skibble_group_photo_0.jpg');

  }
  @override
  void didChangeDependencies() {
    // precacheImage(image1, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var image = Provider.of<AppData>(context, listen: false).welcomePageImage;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              // height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: image,
                    fit: BoxFit.cover
                  )
              ),
            ),

            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      colors: [
                        kPrimaryColor.withOpacity(0.8),
                        kPrimaryColor.withOpacity(0.0),
                        //Colors.black.withOpacity(0.0)
                      ]
                  ),
                ),
              ),
            ),

            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(0.8),
                        Colors.black.withOpacity(0.0),
                        //Colors.black.withOpacity(0.0)
                      ]
                  ),
                ),
              ),
            ),

            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Icon(
                SkibbleIcons.skibble_wordmark_light,
                color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kLightSecondaryColor,
                size: 70,
              ),
            ),

            const Positioned(
              top: 130,
              right: 10,
              left: 10,

              child: Text('Connect. Eat. Share', textAlign: TextAlign.center, style: TextStyle(color: kLightSecondaryColor, fontWeight: FontWeight.bold),

              ),
            ),

            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),

                ),
                child: Column(
                  children: [
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 50,
                      onPressed: () {

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFoodPreferencesView()));

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegisterPage()));
                        context.read<SkibbleAuthProvider>().isOnSignUpPage = true;

                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserAuthPage()));

                      },
                      color: kPrimaryColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Text("Start Skibbling!", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: kLightSecondaryColor
                      ),),
                    ),

                    // const SizedBox(height: 20,),
                    TextButton(onPressed: () {
                      context.read<SkibbleAuthProvider>().isOnSignUpPage = false;
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UserAuthPage()));

                    }, child: const Text('Already have an account? Sign In', style: TextStyle(color:kLightSecondaryColor, decoration: TextDecoration.underline, decorationColor: kLightSecondaryColor),
                    ), ),

                    // RichText(
                    //     text: TextSpan(
                    //       children: const [
                    //         TextSpan(
                    //           text: 'Already have an account? '
                    //         ),
                    //         TextSpan(
                    //             text: 'Sign In',
                    //
                    //         ),
                    //
                    //      ],
                    //     style: const TextStyle(decoration: TextDecoration.underline),
                    //     recognizer: TapGestureRecognizer()..onTap = () {
                    //
                    //       //pop the context
                    //       // Navigator.pop(context);
                    //     }),
                    //
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}