import 'package:flutter/material.dart';
import 'package:skibble/models/skibble_user.dart';

import '../../../../../../utils/size_config.dart';


class ChefResetBasicDetails extends StatelessWidget {
  const ChefResetBasicDetails({Key? key, this.customUser}) : super(key: key);

 final SkibbleUser? customUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10,),

                  Text("Reset Signup Details", style: TextStyle(
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                    height: 1.5,
                  )),

                  SizedBox(height: 10,),

                  Text(
                      "Get started by creating an account and completing the fields below.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.02),

                ],
              ))),
    );
  }
}
