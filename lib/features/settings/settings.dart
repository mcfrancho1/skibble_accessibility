import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skibble/config.dart';
import 'package:skibble/localization_service.dart';
import 'package:skibble/models/contact_us_model.dart';

import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/shared/custom_app_bar.dart';
import 'package:skibble/features/authentication/controllers/auth_controller.dart';
import 'package:skibble/features/settings/notifications_settings_view.dart';
import 'package:skibble/features/settings/shared_customer_support_view.dart';
import 'package:skibble/features/settings/theme_settings.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/custom_navigator.dart';
import 'package:skibble/utils/environment.dart';

import '../../localization/app_translation.dart';
import '../../services/change_data_notifiers/app_data.dart';
import '../../shared/custom_web_view.dart';


class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late final EmojiParser parser;

  NavigatorState? _navigator;
  @override
  void initState() {
    // TODO: implement initState
    parser = EmojiParser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }
  @override
  Widget build(BuildContext context) {
    var currentUser = Provider.of<AppData>(context).skibbleUser;
    return Scaffold(
      appBar: CustomAppBar(title: tr.settings, centerTitle: true,),
      backgroundColor: Colors.grey.shade50,
      body: Container(
        height: double.infinity,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 10),
                  child: Text(
                    tr.account.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor
                    ),
                  ),
                ),

                Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color: kDarkSecondaryColor, width: 0.1)

                  ),
                  color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,

                  child: Column(
                    children: [

                      ListTile(
                        title: const Text(
                          'Edit Profile',
                          style: TextStyle(
                            //color: Colors.black87,
                          ),
                        ),

                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20,),

                        onTap: ()  {
                          //UpdateUserFoodPreferences
                          CustomNavigator().navigateToProfileEdit(context);
                        },
                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),

                      ListTile(
                        title: Text(
                          tr.theme,
                          style: const TextStyle(
                            //color: Colors.black87,
                          ),
                        ),

                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20,),

                        onTap: ()  {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ThemeSettingsView()));
                        },
                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),

                      ListTile(
                          title: Text(
                            tr.notifications,
                            style: const TextStyle(
                              //color: Colors.black87,
                            ),
                          ),

                          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20,),

                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsSettingsView()))
                      ),

                      // Divider(),
                      // ListTile(
                      //   title: Text(
                      //     'changeLanguage'.tr,
                      //     style: TextStyle(
                      //       //color: Colors.black87,
                      //         fontFamily: "Brand Bold"
                      //     ),
                      //   ),
                      //
                      //   onTap: () async {
                      //     showLanguageDialog();
                      //   },
                      // ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 24,),

            //payments

            // if(currentUser.isASkibbleRegisteredChef)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            //         child: Text(
            //           'payments'.tr.toUpperCase(),
            //           style: TextStyle(
            //               fontWeight: FontWeight.bold,
            //               fontSize: 16,
            //               color: kPrimaryColor
            //           ),
            //         ),
            //       ),
            //
            //       Container(
            //         decoration: BoxDecoration(
            //             color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor
            //         ),
            //         child: Column(
            //           children: [
            //
            //             ListTile(
            //                 title: Text(
            //                   'paymentProfile'.tr,
            //                   style: TextStyle(
            //                     //color: Colors.black87,
            //                       fontFamily: "Brand Bold"
            //                   ),
            //                 ),
            //                 onTap: () {
            //                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => PaymentsView()));
            //                 }
            //             ),
            //
            //
            //           ],
            //         ),
            //       ),
            //
            //       SizedBox(height: 10,),
            //     ],
            //   ),
            //
            //


            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(
                    tr.support!.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor
                    ),
                  ),
                ),

                Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color: kDarkSecondaryColor, width: 0.1)

                  ),
                  color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,

                  child: Column(
                    children: [

                      ListTile(
                          title: Text(
                            tr.help,
                            style: const TextStyle(
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SharedCustomeSupportInquiryView(contactType: CustomerSupportInquiryType.help)))
                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),


                      ListTile(
                          title: Text(
                            tr.privacyQuestion,
                            style: const TextStyle(
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SharedCustomeSupportInquiryView(contactType: CustomerSupportInquiryType.privacyQuestion)))

                      ),

                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 24,),
            //feedback
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(
                    tr.feedback!.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor
                    ),
                  ),
                ),

                Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: const BorderSide(color: kDarkSecondaryColor, width: 0.1)

                  ),
                  color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,

                  child: Column(
                    children: [

                      ListTile(
                          title: Text(
                            tr.iWantToMakeASuggestion,
                            style: const TextStyle(
                              //color: Colors.black87,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SharedCustomeSupportInquiryView(contactType: CustomerSupportInquiryType.suggestion)))

                      ),

                      const Divider(color: Colors.grey, thickness: 0.1,),


                      ListTile(
                          title: Text(
                            tr.iDiscoveredAProblem,
                            style: const TextStyle(
                              //color: Colors.black87,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SharedCustomeSupportInquiryView(contactType: CustomerSupportInquiryType.bug)))

                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),


                      ListTile(
                          title: Text(
                            tr.iWantAParticularFeature,
                            style: const TextStyle(
                              //color: Colors.black87,
                            ),
                          ),
                          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SharedCustomeSupportInquiryView(contactType: CustomerSupportInquiryType.featureRequest)))

                      ),

                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 24,),


            //information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Text(
                    tr.information.toUpperCase(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: CurrentTheme(context).isDarkMode ? kContentColorLightTheme : kDarkSecondaryColor
                    ),
                  ),
                ),

                Card(
                  elevation: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      // side: BorderSide(color: kDarkSecondaryColor, width: 0.1)

                  ),
                  color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,

                  child: Column(
                    children: [

                      ListTile(
                        title: Text(
                          tr.privacyPolicy,

                          style: const TextStyle(
                            //color: Colors.black87,
                          ),
                        ),

                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWebView(webUrl: APIKeys.privacyPolicy, title: 'Privacy Policy',)));
                        },
                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),


                      ListTile(
                        title: Text(
                          tr.termsOfService,
                          style: const TextStyle(
                            //color: Colors.black87,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWebView(webUrl: APIKeys.termsOfUse, title: 'Terms of Use',)));

                        },
                      ),

                      const Divider(color: kDarkSecondaryColor, thickness: 0.1,),


                      ListTile(
                        title: const Text(
                          'About Us',
                          style: TextStyle(
                            //color: Colors.black87,
                          ),
                        ),
                        onTap: () async {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomWebView(webUrl: APIKeys.aboutUs, title: 'About Us',)));

                        },
                      ),

                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 24,),


            //sign out
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: kDarkSecondaryColor, width: 0.1)
              ),
              color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,
              child: ListTile(
                title: const Center(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: kDarkSecondaryColor,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                tileColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,
                onTap: () async {
                  await AuthController().signOutUser(context);

                  // context.read<StartViewCubit>().showLoginPage();

                  // await Phoenix.rebirth(context);

                },
              ),
            ),

            const SizedBox(height: 20,),



            Center(
              child: Container(
                height: 40,
                width: 80,
                margin: const EdgeInsets.only(top: 20, ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CurrentTheme(context).isDarkMode ? const AssetImage('assets/images/skibble_wordmark_light.png'): const AssetImage('assets/images/skibble_wordmark_colored.png')
                    )
                ),
                // child: CurrentTheme(context).isDarkMode ? Image.asset('assets/images/skibble_wordmark_light.png'): Image.asset('assets/images/skibble_wordmark_colored.png')
              ),
            ),

            Center(
                child:
                RichText(
                  text:  TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Made with ',
                          style: TextStyle(color: Colors.grey),

                        ),

                        TextSpan(
                          text: parser.get('heart').code,
                          style: const TextStyle(color: kErrorColorDark),

                        ),
                      ]
                  ),
                )
            ),

            // Text('Made with ${parser.get('heart').code}',
            //   style: const TextStyle(color: Colors.grey),
            // )),

            const SizedBox(height: 30,),

            //delete account
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: kDarkSecondaryColor, width: 0.1)

              ),
              color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,

              child: ListTile(
                title: Center(
                  child: Text(
                    tr.deleteMyAccount,
                    style: const TextStyle(
                      color: kErrorColor,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                tileColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kContentColorLightTheme,
                onTap: () async {

                  var res = await CustomBottomSheetDialog.showConfirmationSheet(context, 'Delete Account', 'Are you sure you want to delete your account?\n\nWe really don\'t want to see you leave',
                      'Yes, delete my account',
                      onConfirm: () async{

                      });

                  if(res != null && res)
                    await AuthController().deleteUser(context);


                  // CustomDialog(context).showConfirmationDialog(
                  //     'Delete Account',
                  //     'Are you sure you want to delete your account?\n\nWe really don\'t want to see you leave',
                  //     onConfirm: () async{
                  //       Navigator.pop(context);
                  //
                  //       await AuthController().deleteUser(context);
                  //
                  //     });


                },
              ),
            ),

            const SizedBox(height: 20,),

            Center(
              child: Text(
                'Version ${AppEnvironment.globalPackageInfo?.version}',
                style: const TextStyle(
                  color: kDarkSecondaryColor,
                  // fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height: 10,)

          ],
        ),
      ),
    );
  }

  void showLanguageDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0)
            ),
            content: SizedBox(
              width: MediaQuery.of(this.context).size.width * 0.98,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    tr.changeLanguage,
                    style: TextStyle(
                      // fontFamily: 'NunitoSansBold',
                      color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor: kDarkSecondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  generateLanguageTile(
                      "English",
                      'https://upload.wikimedia.org/wikipedia/commons/a/ae/Flag_of_the_United_Kingdom.svg',
                      'English',
                      context
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 2.0,
                  ),
                  const SizedBox(
                    height: 5,
                  ),

                  generateLanguageTile(
                      "Français",
                      'https://upload.wikimedia.org/wikipedia/commons/c/c3/Flag_of_France.svg',
                      'French',
                      context
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(
                    height: 2.0,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // generateLanguageTile(
                  //     "Español",
                  //     'https://upload.wikimedia.org/wikipedia/commons/9/9a/Flag_of_Spain.svg',
                  //     'Spanish',
                  //     context
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // Divider(
                  //   height: 2.0,
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  // generateLanguageTile(
                  //     "Deutsch",
                  //     'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Flag_of_Germany.svg/800px-Flag_of_Germany.svg.png',
                  //     'Dutch',
                  //     context
                  // ),

                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(tr.close!.toUpperCase(), style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  ListTile generateLanguageTile(String title, String imageURL, String id, BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor: kDarkSecondaryColor,
          //fontFamily: "NunitoSansBold"
        ),
      ),
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Center(child: SvgPicture.network(imageURL)),
      ),
      trailing: Icon(
        LocalizationService().getCurrentLanguage() == id ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: LocalizationService().getCurrentLanguage() == id ? kPrimaryColor : Colors.grey,
      ),
      onTap: () async {
        LocalizationService().changeLocale(id);
        Navigator.of(context).pop();
      },
    );
  }
}





