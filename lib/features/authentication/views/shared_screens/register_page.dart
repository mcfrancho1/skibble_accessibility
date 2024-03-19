import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../../models/address.dart';
import '../../../../../models/kitchen.dart';
import '../../../../../models/skibble_user.dart';
import '../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../services/maps_services/geo_locator_service.dart';
import '../../../../../shared/fade_animation.dart';
import '../../../../shared/dialogs.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';
import '../chef_auth/chef/chef_basic_details.dart';
import '../kitchen_auth/kitchen/kitchen_primary_contact_details.dart';
import '../user/user_register_page.dart';



class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(1, const Text("Choose an Option.", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30
                  ),)),
                  const SizedBox(height: 20,),
                  FadeAnimation(1.2, Text("Ready to be a skibbler? Start by choosing a sign up option below.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 15
                    ),)),
                ],
              ),
              FadeAnimation(1.4, Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/food_bg.png')
                    )
                ),
              )),
              Column(
                children: <Widget>[
                  FadeAnimation(1.5, Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),

                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {

                        // Navigator.push(context, MaterialPageRoute(builder: (context) => UserFoodPreferencesView()));
                        // context.read<StartViewCubit>().showRegisterPage();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UserRegisterPage()));
                      },
                      color: kPrimaryColor,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)
                      ),
                      child: const Text("Sign up as a User", style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        color: kLightSecondaryColor
                      ),),
                    ),
                  )),
                  const SizedBox(height: 20,),

                  FadeAnimation(
                    1.6,
                      MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () async{
                          var address = Provider
                              .of<AppData>(context, listen: false)
                              .userCurrentLocation;
                          if(address == null) {
                            var userAddress = await GeoLocatorService().getCurrentPositionAddress(context);

                          }
                          else {

                          }

                        },
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                            ),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Register your food business",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18
                              ),
                            ),
                            SizedBox(width: 10,),
                            Icon(Iconsax.shop)
                          ],
                        ),
                      )
                  ),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}