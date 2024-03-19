import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skibble/services/change_data_notifiers/picker_data/location_picker_data.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/bottom_sheet_dialogs.dart';
import 'package:skibble/utils/custom_pickers/custom_pickers.dart';

import '../../../../../../models/address.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/firebase/database/other_database.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/currency_formatter.dart';
import '../../../../../../utils/current_theme.dart';
import '../../../../../../utils/custom_pickers/location_picker_view.dart';
import '../../../../../../utils/decimal_formatter.dart';
import '../../../../../../utils/food_options_form_field.dart';
import '../../../../../../utils/size_config.dart';
import '../../../../../../utils/validators.dart';
import '../../../controllers/auth_provider.dart';
import 'kitchen_register_page.dart';


class UserKitchenDetailsView extends StatefulWidget {
  const UserKitchenDetailsView({Key? key}) : super(key: key);

  @override
  State<UserKitchenDetailsView> createState() => _UserKitchenDetailsViewState();
}

class _UserKitchenDetailsViewState extends State<UserKitchenDetailsView> {

  String? kitchenName, kitchenUserName;


  TextEditingController streetNumberController = TextEditingController(text: '');
  TextEditingController streetNameController = TextEditingController(text: '');
  TextEditingController cityController = TextEditingController(text: '');
  TextEditingController stateOrProvinceController = TextEditingController(text: '');
  TextEditingController postalCodeController = TextEditingController(text: '');

  TextEditingController countryController = TextEditingController(text: '');

  final GlobalKey<FormState> _userKitchenDetailsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState

    // if(Provider.of<AppData>(context, listen: false).userCurrentLocation != null) {
    //   _currencyFuture = Future.value(Provider.of<AppData>(context, listen: false).userCurrentLocation);
    // }
    // else {
    //   _currencyFuture = getCurrencyBasedOnLocation();
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var userChef = context.read<AuthProvider>().signUpUserKitchen;
    // var address = Provider.of<AppData>(context,).userCurrentLocation;

    return Form(
      key: _userKitchenDetailsFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),

                      // Text(
                      //   'Profile Info',
                      //   style: TextStyle(fontSize: 30),
                      // ),
                      // SizedBox(height: 10,),
                      Text(
                        'This section will be visible to other users. Once your account gets created, you can always make changes in your profile settings.',
                        style: TextStyle(color: Colors.grey),
                      ),

                      SizedBox(height: 10,),
                      Divider(),
                      SizedBox(height: 15,),

                      //Kitchen name
                      Text(
                        'Kitchen Name',
                        style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      SizedBox(height: 10),


                      //Kitchen name
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (newValue) => kitchenName = newValue,
                        onChanged: (value) {
                        },
                        validator: (value) =>  Validator().validateText(value, 'Please enter your kitchen name'),
                        decoration: InputDecoration(
                          // labelText: "Full Name",
                            hintText: "Sasha\'s Kitchen",
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
                      SizedBox(height: getProportionateScreenHeight(25)),

                      ///userName

                       Text(
                        'Kitchen Username',
                        style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),

                      SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        onSaved: (newValue) => kitchenUserName = newValue,
                        onChanged: (value) {

                        },
                        validator: Validator().validateUserName,

                        decoration: InputDecoration(
                            hintText: "sasha-kitchen",
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
                      SizedBox(height: getProportionateScreenHeight(25)),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kitchen Address',
                            style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(height: 4),

                          Text(
                            'Enter the location where your kitchen is/will be located.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),

                      Divider(),
                      SizedBox(height: 10),

                      Consumer<LocationPickerData>(
                          builder: (context, data, child) {
                            Address? address;

                            if(data.pickedLocation != null) {
                              address =  data.pickedLocation;
                            }
                            else {
                              address = Provider.of<AppData>(context, listen: false).userCurrentLocation;
                            }

                            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                              streetNumberController.text = address?.streetNumber ?? '';
                              streetNameController.text = address?.streetName ?? '';
                              cityController.text = address?.city ?? '';
                              stateOrProvinceController.text = address?.stateOrProvince ?? '';
                              postalCodeController.text = address?.postalCode ?? '';
                              countryController.text = address?.country ?? '';
                            });

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Street number
                                Text(
                                  'Street No.',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //Street No.
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: streetNumberController,
                                  // onSaved: (newValue) => fullName = newValue,

                                  onChanged: (value) {
                                  },
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);

                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Enter your street number'),
                                  decoration: InputDecoration(
                                      hintText: "",
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

                                //Street name
                                Text(
                                  'Street Name',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //Street Name
                                TextFormField(
                                  controller: streetNameController,

                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);

                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Enter your street name'),
                                  decoration: InputDecoration(
                                      hintText: "",
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

                                //city
                                Text(
                                  'City',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //City
                                TextFormField(
                                  controller: cityController,
                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);
                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Please enter your city'),
                                  decoration: InputDecoration(
                                      hintText: "",
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


                                //state/province
                                Text(
                                  'State or province',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //postal code
                                TextFormField(
                                  controller: stateOrProvinceController,

                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);

                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Please, enter your postal code'),
                                  decoration: InputDecoration(
                                      hintText: "",
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

                                //state/province
                                Text(
                                  'Postal Code',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //state or province
                                TextFormField(
                                  controller: postalCodeController,

                                  keyboardType: TextInputType.text,
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);

                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Please, enter your state or province'),
                                  decoration: InputDecoration(
                                      hintText: "",
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


                                //country
                                Text(
                                  'Country',
                                  style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),

                                SizedBox(height: 10),

                                //country
                                TextFormField(
                                  controller: countryController,

                                  keyboardType: TextInputType.text,
                                  // onSaved: (newValue) => fullName = newValue,
                                  readOnly: true,
                                  onTap: () {
                                    CustomPickers().showLocationPickerSheet(context, restrictedCountries: data.skibbleChefCountries);

                                  },
                                  validator: (value) =>  Validator().validateText(value, 'Please enter country.'),
                                  decoration: InputDecoration(
                                    // labelText: "Full Name",
                                      hintText: "",
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


                                SizedBox(height: 20,),

                              ],
                            );
                          }
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),

          ControlButtons(
            onBackPressed: () {

            },
            onNextPressed: () async{

              final form = _userKitchenDetailsFormKey.currentState;

              if(form!.validate()) {
                form.save();
                var userChef = context.read<SkibbleAuthProvider>().signUpUserKitchen;

                if(userChef != null) {
                  // var res = await Future.delayed(Duration(seconds: 1), () {
                  //   return 'success';
                  // });

                  context.read<SkibbleAuthProvider>().signUpUserKitchen!.kitchen!.kitchenName = kitchenName;
                  context.read<SkibbleAuthProvider>().signUpUserKitchen!.kitchen!.serviceLocation = context.read<LocationPickerData>().pickedLocation;

                    var res = await UserDatabaseService().updateChefKitchenDetails(userChef.userId!, {
                      'kitchenName': kitchenName,
                      'kitchenUserName': kitchenUserName,
                      'serviceLocation': context.read<LocationPickerData>().pickedLocation?.toMap()
                    });
                  //
                  if(res == 'kitchen-username-exists') {
                    CustomBottomSheetDialog.showErrorSheet(context, 'This kitchen username already exists! Please choose another name.', onButtonPressed: () {
                      Navigator.pop(context);
                    });
                  }
                  return res;
                }
              }
              return 'error';

            },
          )

        ],
      ),
    );
  }
}
