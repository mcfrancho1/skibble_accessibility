import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skibble/custom_icons/chef_icons_icons.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/chef.dart';
import 'package:skibble/services/firebase/database/other_database.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/shared/dialogs.dart';
import 'package:skibble/shared/shimmer.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/currency_formatter.dart';
import 'package:skibble/utils/current_theme.dart';

import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import '../../../../../../services/maps_services/geo_locator_service.dart';
import '../../../../../../shared/custom_multi_select_form_field.dart';
import '../../../../../../utils/custom_pickers/custom_pickers.dart';
import '../../../../../../utils/decimal_formatter.dart';
import '../../../../../../utils/food_options_form_field.dart';
import '../../../controllers/auth_provider.dart';
import 'chef_register_page.dart';

class ChefAccountDetails extends StatefulWidget {
  const ChefAccountDetails({Key? key}) : super(key: key);

  @override
  State<ChefAccountDetails> createState() => _ChefAccountDetailsState();
}

class _ChefAccountDetailsState extends State<ChefAccountDetails> {
  String dropdownChargeType = 'per meal';
  String? chefDescription = '';

  int deliveryOptions = 0;

  late final List<String> _chefDeliveryOptionList;


  TextEditingController priceController = TextEditingController(text: '');

  Future? _allTagsFuture;
  List? tags = [];

  @override
  void initState() {
    // TODO: implement initState

    _chefDeliveryOptionList = [
      'Delivery',
      'Pickup',
      'Delivery & Pickup'
    ];

    super.initState();
  }

  Future<Address?> getCurrencyBasedOnLocation() async{
    return await GeoLocatorService().getCurrentPositionAddress(context);
  }

  @override
  Widget build(BuildContext context) {
    var userChef = context.read<SkibbleAuthProvider>().signUpChef;
    // var address = Provider.of<AppData>(context,).userCurrentLocation;

    // print(_userSelectedTags);
    return Column(
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
                      'This section helps your potential customers know more about you and your kitchen. You can always change the information here in your account settings.',
                      style: TextStyle(color: Colors.grey),
                    ),

                    SizedBox(height: 10,),
                    Divider(),
                    SizedBox(height: 15,),


                    // Text('Your Preferred Title', style: TextStyle(fontSize: 16),),
                    // SizedBox(height: 5,),
                    // Text(
                    //   'Choose your preferred title.',
                    //   style: TextStyle(color: Colors.grey, fontSize: 12),
                    // ),
                    //
                    // SizedBox(height: 10,),
                    //
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   decoration: ShapeDecoration(
                    //     shape: RoundedRectangleBorder(
                    //       side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                    //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //     ),
                    //   ),
                    //   child: DropdownButtonHideUnderline(
                    //     child: DropdownButton<String>(
                    //       onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                    //       value: title,
                    //       // isExpanded: true,
                    //       icon: const Icon(Icons.expand_more_rounded),
                    //       iconSize: 24,
                    //       elevation: 16,
                    //       isExpanded: true,
                    //       dropdownColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                    //       style: TextStyle(fontFamily: 'Brand Regular', color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                    //       onChanged: (String? newValue) {
                    //         setState(() {
                    //           title = newValue!;
                    //         });
                    //         userChef!.chef!.isAChef = newValue == "Chef";
                    //       },
                    //       items: <String>['Chef', 'Cook',]
                    //           .map<DropdownMenuItem<String>>((String value) {
                    //         return DropdownMenuItem<String>(
                    //           value: value,
                    //           child: Text(value, ),
                    //         );
                    //       }).toList(),
                    //     ),
                    //   ),
                    // ),
                    //
                    // SizedBox(height: 10,),
                    //
                    // Divider(),
                    // SizedBox(height: 10,),



                    //Description
                    Text('About me', style: TextStyle(fontSize: 16),),
                    SizedBox(height: 5,),
                    Text(
                      'Write a short bio about yourself and your cooking skills.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),

                    SizedBox(height: 10,),


                    Container(
                      // margin: EdgeInsets.all(10.0),
                      child: Scrollbar(
                        child: TextFormField(
                          initialValue: chefDescription,
                            maxLines: 7,
                            onSaved: (value) {
                              chefDescription = value;
                            },
                            onChanged: (value) {
                              userChef!.chef!.description = value;
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'e.g I make the best tasty meals.',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: Theme.of(context).backgroundColor,
                                      width: 1
                                  )
                              ),
                            )
                        ),
                      ),
                    ),
                    //End of Description


                    SizedBox(height: 20,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Food Specialties', style: TextStyle(fontSize: 16),),
                        SizedBox(height: 5,),
                        Text(
                          'Let your customers find you with the type of meals you cook.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),

                        SizedBox(height: 10,),

                        //food specialties
                        FoodOptionsFormField(hintText: 'What type of meals do you make?',),
                      ],
                    ),

                    ///
                    // InkWell(
                    //   borderRadius: BorderRadius.circular(10),
                    //   onTap: () {},
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         border: Border.all(color: Colors.grey)
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         Icon(ChefIcons.chef_and_spoon),
                    //         SizedBox(width: 15,),
                    //         Text('No tags selected yet. Tap to select', style: TextStyle(color: Colors.grey, fontSize: 16),)
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    SizedBox(height: 20,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Text('Your Average Price', style: TextStyle(fontSize: 16),),
                        SizedBox(height: 5,),
                        Text(
                          'How much is the average price of your meals?',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),

                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                // margin: EdgeInsets.only(left: 15),
                                child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.numberWithOptions(
                                      decimal: true,
                                      signed: false,
                                    ),
                                    controller: priceController,
                                    validator: _validateCharge,
                                    onChanged: (value) {
                                      String formattedPrice = priceController.text;
                                      formattedPrice = value.replaceAll(',', '');
                                      if(formattedPrice.isNotEmpty) {
                                        userChef!.chef!.chargeRate = double.parse(formattedPrice);
                                        userChef.chef!.chargeRateType = dropdownChargeType;
                                        userChef.chef!.chargeRateString = '${priceController.text} $dropdownChargeType';
                                      }
                                    },
                                    inputFormatters: [
                                      ThousandsFormatter(allowFraction: true),

                                      DecimalTextInputFormatter(decimalRange: 2),
                                      // FilteringTextInputFormatter.digitsOnly

                                    ],
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          CupertinoIcons.money_dollar_circle,
                                          color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,),
                                        prefixText: '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(userChef?.chef!.serviceLocation!.countryCode ?? 'CA')}',
                                        enabled: true,
                                        hintText: '0',
                                        prefixStyle: TextStyle(fontSize: 16),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.grey)
                                        )
                                    )
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 1.0, style: BorderStyle.solid, color: Colors.grey),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                                  value: dropdownChargeType,
                                  // isExpanded: true,
                                  icon: const Icon(Icons.expand_more_rounded),
                                  iconSize: 24,
                                  elevation: 16,
                                  dropdownColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                                  style: TextStyle(color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownChargeType = newValue!;
                                    });
                                    userChef!.chef!.chargeRateString = '${priceController.text} $newValue';
                                    userChef.chef!.chargeRateType = newValue;
                                  },
                                  items: <String>['per meal',]
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            )
                          ],
                        ),


                        SizedBox(height: 20,),

                        //charge negotiable
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'How would you like to deliver orders to your customers?',
                              style: TextStyle(
                                  fontSize: 17
                              ),
                            ),

                            Column(
                              children: List.generate(
                                  _chefDeliveryOptionList.length,
                                      (index) => Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: RadioListTile<int>(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(width: 1, color: Colors.grey)
                                    ),
                                    activeColor: kPrimaryColor,
                                    value: index,
                                    selected: deliveryOptions == index,
                                    title: Text(_chefDeliveryOptionList[index],),
                                    groupValue: deliveryOptions,
                                    onChanged: (value) {
                                      switch(index) {
                                        case 0:
                                          userChef?.chef!.deliveryOption = FoodDeliveryOption.delivery;
                                          break;

                                        case 1:
                                          userChef?.chef!.deliveryOption = FoodDeliveryOption.pickup;
                                          break;

                                        case 2:
                                          userChef?.chef!.deliveryOption = FoodDeliveryOption.deliveryAndPickup;
                                          break;
                                      }

                                      setState(() {
                                        deliveryOptions = value!;
                                      });
                                    }
                                ),
                              )
                              ),
                            ),

                          ],
                        ),

                        Divider(),
                      ],
                    ),

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
            var accountDetails = {
              'foodSpecialtyList': context.read<FoodOptionsPickerData>().userChoices,
              'description': chefDescription,
              'chargeRate': userChef?.chef!.chargeRate,
              'chargeRateString': userChef?.chef!.chargeRateString,
              'chargeRateType': userChef?.chef!.chargeRateType,
              'deliveryOption': userChef?.chef!.deliveryOption.name,
            };

            if(userChef != null) {
              var res = await UserDatabaseService().updateChefAccountDetails(userChef.userId!, accountDetails);
              return res;

            }
            return 'error';
          },
        )

      ],
    );
  }

  String? _validateCharge(String? value) {
    if(value!.isEmpty) {
      return 'Please enter your standard charge';
    }
    return null;
  }
}
