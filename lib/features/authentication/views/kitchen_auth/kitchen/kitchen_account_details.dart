import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:provider/provider.dart';
import 'package:skibble/models/address.dart';
import 'package:skibble/models/kitchen.dart';
import 'package:skibble/services/firebase/database/user_database.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/currency_formatter.dart';
import 'package:skibble/utils/current_theme.dart';

import '../../../../../../services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import '../../../../../../services/maps_services/geo_locator_service.dart';
import '../../../../../../utils/decimal_formatter.dart';
import '../../../../../../utils/food_options_form_field.dart';
import '../../../controllers/auth_provider.dart';
import 'kitchen_register_page.dart';

class UserKitchenAccountDetails extends StatefulWidget {
  const UserKitchenAccountDetails({Key? key}) : super(key: key);

  @override
  State<UserKitchenAccountDetails> createState() => _UserKitchenAccountDetailsState();
}

class _UserKitchenAccountDetailsState extends State<UserKitchenAccountDetails> {
  String dropdownChargeType = 'per meal';
  String? kitchenDescription = '';

  int deliveryOptions = 0;

  late final List<String> _kitchenDeliveryOptionList;

  TextEditingController priceController = TextEditingController(text: '');

  Future? _allTagsFuture;
  List? tags = [];

  @override
  void initState() {
    // TODO: implement initState

    _kitchenDeliveryOptionList = [
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
    var userChef = context.read<SkibbleAuthProvider>().signUpUserKitchen;
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
                    //         userChef!.kitchen!.isAChef = newValue == "Chef";
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
                          initialValue: kitchenDescription,
                            maxLines: 7,
                            onSaved: (value) {
                              kitchenDescription = value;
                            },
                            onChanged: (value) {
                              userChef!.kitchen!.description = value;
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
                    //         Icon(ChefIcons.kitchen_and_spoon),
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
                                        userChef!.kitchen!.chargeRate = double.parse(formattedPrice);
                                        userChef.kitchen!.chargeRateType = dropdownChargeType;
                                        userChef.kitchen!.chargeRateString = '${priceController.text} $dropdownChargeType';
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
                                        prefixText: '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(userChef?.kitchen!.serviceLocation!.countryCode ?? 'CA')}',
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
                                    userChef!.kitchen!.chargeRateString = '${priceController.text} $newValue';
                                    userChef.kitchen!.chargeRateType = newValue;
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
                                  _kitchenDeliveryOptionList.length,
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
                                    title: Text(_kitchenDeliveryOptionList[index],),
                                    groupValue: deliveryOptions,
                                    onChanged: (value) {
                                      switch(index) {
                                        case 0:
                                          userChef?.kitchen!.deliveryOption = FoodDeliveryOption.delivery;
                                          break;

                                        case 1:
                                          userChef?.kitchen!.deliveryOption = FoodDeliveryOption.pickup;
                                          break;

                                        case 2:
                                          userChef?.kitchen!.deliveryOption = FoodDeliveryOption.deliveryAndPickup;
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
              'description': kitchenDescription,
              'chargeRate': userChef?.kitchen!.chargeRate,
              'chargeRateString': userChef?.kitchen!.chargeRateString,
              'chargeRateType': userChef?.kitchen!.chargeRateType,
              'deliveryOption': userChef?.kitchen!.deliveryOption.name,
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
