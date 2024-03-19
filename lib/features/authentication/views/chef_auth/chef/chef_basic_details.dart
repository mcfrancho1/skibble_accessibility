import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'dart:math' as math;
import '../../../../../../custom_icons/chef_icons_icons.dart';
import '../../../../../../custom_icons/custom_icons_icons.dart';
import '../../../../../../models/chef.dart';
import '../../../../../../models/skibble_user.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/change_data_notifiers/picker_data/location_picker_data.dart';
import '../../../../../../shared/dialogs.dart';
import '../../../../../../shared/loading_spinner.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/custom_data.dart';
import '../../../../../../utils/size_config.dart';
import '../../../../../../utils/validators.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/auth_provider.dart';
import 'chef_register_page.dart';


class ChefBasicDetails extends StatefulWidget {
  const ChefBasicDetails({Key? key,}) : super(key: key);

  @override
  State<ChefBasicDetails> createState() => _ChefBasicDetailsState();
}

class _ChefBasicDetailsState extends State<ChefBasicDetails> {
  final GlobalKey<FormState> _chefSignUpFormKey = GlobalKey<FormState>();
  //
  // String? email = "";
  // String? fullName = "";
  // String? userName = "";
  // String? password = "";
  // String? phoneNumber = "";
  // bool remember = false;
  // String? userNameErrorText;
  //
  // bool _isObscureText = true;
  // bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userChef = Provider.of<AppData>(context, listen: false).currentUserChef;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Consumer<SkibbleAuthProvider>(
            builder: (context, data, child) {
              return Column(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Form(
                          key: _chefSignUpFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(height: 20,),

                                  Center(
                                    child: Icon(
                                      ChefIcons.chef_and_spoon,
                                      size: 100,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                  Center(
                                    child: Text("Join Skibble Kitchen.", style: TextStyle(
                                      fontSize: getProportionateScreenWidth(28),
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.black,
                                      height: 1.5,
                                    )),
                                  ),


                                  SizedBox(height: 10,),


                                  Divider(),

                                  SizedBox(height: 10,),

                                  Text(
                                    'Primary Contact',
                                    style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 19),
                                  ),

                                  SizedBox(height: 4,),
                                  Text(
                                    'Provide information that you will use to login into your account after creation.',
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey, fontSize: 13),
                                  ),
                                  SizedBox(height: 20,),

                                  Text(
                                    'Full Name',
                                    style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),

                                  SizedBox(height: 10),

                                  //fullName
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    onSaved: (newValue) => data.fullName = newValue,
                                    onChanged: (value) {
                                      // userChef!.fullName = value;
                                      // if (value.isNotEmpty) {
                                      //   removeError(error: 'kEmailNullError');
                                      // } else if (EmailValidator.validate(value)) {
                                      //   removeError(error: 'kInvalidEmailError');
                                      // }
                                      // return null;
                                    },
                                    validator: Validator().validateFullName,
                                    decoration: InputDecoration(
                                      // labelText: "Full Name",
                                      hintText: "Sasha Foodie",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      // suffixIcon: Icon(Iconsax.user),
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.grey.shade400)
                                      ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade400)
                                        ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100
                                    ),
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(20)),

                                  Text(
                                    'User Name',
                                    style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  SizedBox(height: 10),

                                  //userName
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    onSaved: (newValue) => data.userName = newValue,
                                    onChanged: (value) {
                                      // userChef!.userName = value;

                                      // if (value.isNotEmpty) {
                                      //   removeError(error: 'kEmailNullError');
                                      // } else if (EmailValidator.validate(value)) {
                                      //   removeError(error: 'kInvalidEmailError');
                                      // }
                                      // return null;
                                    },
                                    validator: Validator().validateUserName,

                                    decoration: InputDecoration(
                                        hintText: "foodie",
                                        errorText: context.read<SkibbleAuthProvider>().userNameErrorText,

                                        hintStyle: TextStyle(color: Colors.grey),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        // suffixIcon: Icon(Iconsax.user),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade400)
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade400)
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100
                                    ),
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(20)),
                                  Text(
                                    'Email',
                                    style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),

                                  SizedBox(height: 10,),

                                  //email
                                  TextFormField(
                                    // initialValue: email,
                                    keyboardType: TextInputType.emailAddress,
                                    onSaved: (newValue) => data.email = newValue,
                                    onChanged: (value) {
                                      // userChef!.userEmailAddress = value;

                                      // if (value.isNotEmpty) {
                                      //   removeError(error: 'kEmailNullError');
                                      // } else if (EmailValidator.validate(value)) {
                                      //   removeError(error: 'kInvalidEmailError');
                                      // }
                                      // return null;
                                    },
                                    validator: Validator().validateEmail,
                                    decoration: InputDecoration(
                                        hintText: "foodie@skibble.app",
                                        hintStyle: TextStyle(color: Colors.grey),
                                        floatingLabelBehavior: FloatingLabelBehavior.always,
                                        // suffixIcon: Icon(Iconsax.user),
                                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade400)
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey.shade400)
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade100
                                    ),
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(20)),

                                  Text(
                                    'Phone Number',
                                    style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),

                                  SizedBox(height: 10,),
                                  //phone number
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400
                                      ),
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: InternationalPhoneNumberInput(
                                      countries: ['CA', 'NG'],
                                      onInputChanged: (PhoneNumber number) {
                                        // data.phoneNumber = number.phoneNumber;
                                      },
                                      onInputValidated: (bool value) {
                                      },
                                      selectorConfig: SelectorConfig(
                                        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),
                                      ignoreBlank: true,
                                      autoValidateMode: AutovalidateMode.disabled,
                                      selectorTextStyle: TextStyle(color: Colors.black),
                                      // initialValue: number,
                                      // textFieldController: controller,
                                      formatInput: true,
                                      validator: (value) => Validator().validatePhone(value),
                                      keyboardType: TextInputType.phone,
                                      inputDecoration: InputDecoration.collapsed(
                                          hintText: 'Phone Number'
                                      ),

                                      // InputDecoration(
                                      //   labelText: 'Phone Number',
                                      //   labelStyle: TextStyle(
                                      //     decoration: TextDecoration.none
                                      //   ),
                                      // ),
                                      onSaved: (PhoneNumber number) {
                                        data.phoneNumber = number.phoneNumber;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: getProportionateScreenHeight(20)),

                                  Text(
                                    'Password',
                                    style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                  ),

                                  SizedBox(height: 10,),
                                  //password
                                  TextFormField(
                                    // initialValue: password,
                                    obscureText: data.isPasswordObscured,
                                    onSaved: (newValue) => data.password = newValue,
                                    onChanged: (value) {
                                      // userChef!.userPassword = value;

                                      // if (value.isNotEmpty) {
                                      //   removeError(error: 'kPassNullError');
                                      // } else if (value.length >= 8) {
                                      //   removeError(error: 'kShortPassError');
                                      // }
                                      // password = value;
                                    },
                                    validator: Validator().validatePassword,

                                    decoration: InputDecoration(
                                      hintText: "********",
                                      hintStyle: TextStyle(color: Colors.grey),

                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      // suffixIcon: Icon(Iconsax.user),
                                      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: Colors.grey.shade400)
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: Colors.grey.shade400)
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey.shade100,
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
                                ],
                              ),

                              SizedBox(height: 20,),
                              Center(
                                child: Consumer<LoadingController>(
                                    builder: (context, loadingData, child) {
                                      return SizedBox(
                                        width: double.infinity,
                                        height: getProportionateScreenHeight(40),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                          child: ElevatedButton(
                                            onPressed: () async{
                                              final form = _chefSignUpFormKey.currentState;

                                              if(form!.validate()) {
                                                form.save();
                                                int timestamp = DateTime.now().millisecondsSinceEpoch;

                                                SkibbleUser newSwiftMenuUser = SkibbleUser(
                                                  fullName:  context.read<SkibbleAuthProvider>().fullName,
                                                  userName:  context.read<SkibbleAuthProvider>().userName?.toLowerCase(),
                                                  userEmailAddress:  context.read<SkibbleAuthProvider>().email,
                                                  userPassword:  context.read<SkibbleAuthProvider>().password,
                                                  isActive: true,
                                                  userPhoneNumber: context.read<SkibbleAuthProvider>().phoneNumber,
                                                  timeLastActive: timestamp,
                                                  accountCreatedAt: timestamp,
                                                  lastLoginTimeStamp: timestamp,
                                                  userCustomColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                  chef: Chef(
                                                      kitchenSkillsRating: CustomSharedData().kitchenSkillsRating(),
                                                      ratingGroup: CustomSharedData().ratingGroup(),
                                                      serviceLocation: context.read<LocationPickerData>().pickedLocation,
                                                      workExperienceList: [],
                                                      certificationsList: [],
                                                  ),
                                                  accountType: AccountType.chef,
                                                  isASkibbleRegisteredChef: true,

                                                );

                                                await AuthController().createUserAccountWithEmailAndPassword(newSwiftMenuUser, context, formState: _chefSignUpFormKey.currentState);

                                              }
                                              },
                                            child: loadingData.isLoading ?
                                            LoadingSpinner()
                                                :
                                            Text(
                                              'Continue',
                                              style: TextStyle(color: kLightSecondaryColor, fontSize: 20),),
                                            style: ElevatedButton.styleFrom(
                                                primary: kPrimaryColor,

                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(30)
                                                )
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                ),
                              ),

                              SizedBox(height: 20,)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
