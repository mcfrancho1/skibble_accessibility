import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:skibble/shared/type_ahead_field.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';
import 'package:skibble/utils/validators.dart';
import 'package:uuid/uuid.dart';

import '../localization/app_translation.dart';
import '../models/address.dart';
import '../models/ingredient.dart';
import '../models/menu_models/menu.dart';
import '../models/menu_models/food_menu_item.dart';
import '../models/pop_up_item.dart';
import '../models/skibble_user.dart';
import '../models/suggestion.dart';
import '../services/change_data_notifiers/app_data.dart';
import '../services/maps_services/map_requests.dart';
import '../features/profile/chef/bottom_sheet/chef_menu/create_menu_item_view.dart';
import '../utils/currency_formatter.dart';
import 'custom_file_picker/lib/drishya_picker.dart';

class CustomDialog {

  final BuildContext context;
  CustomDialog(this.context);

  Future<void> showRequiredDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: false,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(tr.requiredOptions),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(tr.requiredMessage),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> showOpenSettingsDialog(String title, String message, {required Function() onConfirm}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: false,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: ElevatedButton(
                  child: const Text('Open Settings', style: TextStyle(color: kLightSecondaryColor),),

                  onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showConfirmationDialog(String title, String message, {required Function() onConfirm}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.no),
                onPressed: () {
                  Navigator.pop(context);
                }
            ),
            ElevatedButton(
                child: Text(tr.yes, style: const TextStyle(color: kLightSecondaryColor),),

                onPressed: onConfirm
            ),
          ],
        );
      },
    );
  }

  Future<void> showProgressDialog(BuildContext context, String message,
      {bool isDissimissible = true}) async {
    return showDialog(
        context: context,

        //TODO:change to false
        barrierDismissible: isDissimissible,
        useRootNavigator: false,
        builder: (context) => SimpleDialog(
          backgroundColor: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor: kLightSecondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor: kDarkSecondaryColor,
                fontFamily: 'Brand Regular'
              //fontSize: 10.0
            ),
          ),
          children: const [
            Center(child: Text('Please wait...', style: TextStyle(color: Colors.grey),)),

            SizedBox(height: 20,),
            Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor), strokeWidth: 1,)),
          ],

        )
    );
  }

  Future<void> showErrorDialog(String title, String message) async {
    showDialog(
        context: context,

        //TODO:change to false
        barrierDismissible: true,
        useRootNavigator: false,

        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title, style: const TextStyle(color: kErrorColor),),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message,),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        )
    );
  }

  Future<void> showCustomMessage(String title, String message, {Function()? onOkayPressed}) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: false,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  if(onOkayPressed != null) {
                    onOkayPressed();
                  }
                  else {
                    Navigator.of(context).pop();
                  }
                }
            ),
          ],
        );
      },
    );
  }
  Future<void> showFoodInterestsDialog(List<String> currentUserFoodInterests, List<String> foodInterests) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: false,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: const Text('Food Interests'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Wrap(
                  runSpacing: 5,
                  spacing: 5,
                  children: foodInterests.map((food) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: currentUserFoodInterests.contains(food.capitalizeFirst!) ? kPrimaryColor : CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: currentUserFoodInterests.contains(food.capitalizeFirst!) ? kPrimaryColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,)
                    ),
                    child: Text(
                      food.capitalizeFirst!,
                      style: TextStyle(
                          color: currentUserFoodInterests.contains(food.capitalizeFirst!) ? kLightSecondaryColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor
                      ),
                    ),
                  ),).toList(),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> showWelcomeMessage(String title, String message,) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      useRootNavigator: false,

      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    'assets/images/celebrate.png',
                    width: 100,
                    height: 100,
                    // fit: BoxFit.cover,
                  ),
                ),
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> showWelcomeMessageWithEmail(String title, String message,) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(tr.welcome),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(
                  'assets/images/celebrate.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                const Text('Thank you for registering on Skibble. You can get started by adding a profile photo so that your skibblers can find you.\n\n Hope you have the best food experiences ever!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }

  Future<void> showPercentageDialog(String title, Widget slider) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
               slider
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(tr.okay),
                onPressed: () async {
                  Navigator.of(context).pop();
                }
            ),
          ],
        );
      },
    );
  }


  Future<File?> showPhotoSelectionDialog(RequestType type, String? photoUrl, File? currentPhoto, {String mediaType= 'Photo', bool showDelete = true, required Function() onCameraSelected, required Function() onGallerySelected, required Function() onRemoveMedia, required Function() onDeleteCurrentPhoto, index}) async{
    return await showDialog<File>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: const Text('Select an Option'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.camera),
                    title: const Text('Camera'),
                    onTap: onCameraSelected
                  ),

                  ListTile(
                    leading: const Icon(Iconsax.gallery),
                    title: const Text('Select from Gallery'),
                    onTap: onGallerySelected
                  ),

                  showDelete ? currentPhoto == null ? photoUrl != null ?
                  ListTile(
                      leading: const Icon(Iconsax.trash),
                      title: Text('Delete $mediaType'),
                      onTap: onDeleteCurrentPhoto
                  )
                      :
                  Container()
                      :
                  ListTile(
                    leading: const Icon(Iconsax.trash),
                    title: const Text('Remove Media'),
                    onTap: onRemoveMedia
                  ) : Container(),
                ],
              ),
            ),
          );
        });
  }


  Future<List<File>?> showPhotoMultiSelectionDialog(RequestType type, String? photoUrl, File? currentPhoto, {required Function() onCameraSelected, required Function() onGallerySelected, required Function() onRemoveMedia, required Function() onDeleteCurrentPhoto, index}) async{
    return await showDialog<List<File>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: const Text('Select an Option'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                      leading: const Icon(Iconsax.camera),
                      title: const Text('Camera'),
                      onTap: onCameraSelected
                  ),

                  ListTile(
                      leading: const Icon(Iconsax.gallery),
                      title: const Text('Select from Gallery'),
                      onTap: onGallerySelected
                  ),

                  currentPhoto == null ? photoUrl != null ?
                  ListTile(
                      leading: const Icon(Iconsax.trash),
                      title: const Text('Delete Photo'),
                      onTap: onDeleteCurrentPhoto
                  )
                      :
                  Container()
                      :
                  ListTile(
                      leading: const Icon(Iconsax.trash),
                      title: const Text('Remove Media'),
                      onTap: onRemoveMedia
                  ),
                ],
              ),
            ),
          );
        });
  }


  Future<List<File>?> showMediaSelectionDialog(RequestType type, BuildContext context, {required Function() onCameraSelected, required Function() onGallerySelected,}) async{
    return await showDialog<List<File>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            title: const Text('Select an Option'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                      leading: const Icon(Iconsax.camera),
                      title: const Text('Camera'),
                      onTap: onCameraSelected
                  ),

                  ListTile(
                      leading: const Icon(Iconsax.gallery),
                      title: const Text('Select from Gallery'),
                      onTap: onGallerySelected
                  ),

                ],
              ),
            ),
          );
        });
  }



  Future<String?> showTextInputDialog(String title, String hintText, {String? initialValue, String? Function(String)? validator}) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    String? formValue;
    return await showDialog<String?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: initialValue,
                onChanged: (value) {
                  formValue = value;
                },
                validator: (value) => validator != null ? validator(value!) : Validator().validateText(value, 'This field is empty'),
                // controller: _textFieldController,
                decoration: InputDecoration(hintText: hintText),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(

                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  primary: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), )
                ),
                child: const Text('OK'),
                onPressed: () {
                  final form = _formKey.currentState;
                  if(form!.validate()) {
                    Navigator.of(context).pop(formValue);
                  }
                  // setState(() {
                  //   codeDialog = valueText;
                  //   Navigator.pop(context);
                  // });
                },
              ),
            ],
          );
        });
  }


  Future<Map<String, dynamic>?> showRecipeSourceDialog(Map<String, dynamic> sourceMap) async {
    final GlobalKey<FormState> _formKey = GlobalKey();

    String? _name;
    String? _link;
    return await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Ingredient'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Source Name',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 10,),


                    TextFormField(
                      initialValue: sourceMap['sourceName'],
                      // onChanged: (value) {
                      //   _name = value;
                      // },
                      onSaved: (value) => _name = value,
                      validator: (value) => Validator().validateText(value, 'Enter the source name'),
                      // controller: _textFieldController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "e.g Skibble"),
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'URL Link',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    TextFormField(
                      initialValue: sourceMap['urlLink'],
                      // onChanged: (value) {
                      //   measurement = double.tryParse(value);
                      // },
                      onSaved: (value) => _link = value,
                      validator: (value) => Validator().validateUrl(value, 'Enter a url link to the recipe.'),

                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          prefixText: 'https://'),
                    ),

                    const SizedBox(height: 5,),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(

                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), )
                ),
                child: const Text('OK'),
                onPressed: () {
                  final form = _formKey.currentState;
                  if(form!.validate()) {
                    form.save();
                    Map<String, dynamic> result = {
                      'sourceName': _name,
                      'urlLink': _link!.replaceAll('https://', '').replaceAll('http://', '')
                    };
                    Navigator.of(context).pop(result);
                  }

                },
              ),
            ],
          );
        });
  }

  Future<FoodMenuItem?> showAddItemDialog({Menu? menu, FoodMenuItem? menuItem}) async{
    FoodMenuItem? item = await showModalBottomSheet(
        context: context,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(15), topLeft: Radius.circular(10))
        ),
        isScrollControlled: true,
        builder: (context) {
          return EditMenuItemCard(menu: menu!, menuItem: menuItem,);
        }
    );

    return item;
  }


  Future showTotalAmountInfo(int numGuests,int numHours, double total, Map<String, FoodMenuItem> foodItems, Map<String, int> itemsQuantity, SkibbleUser userChef) async {
    return await showDialog<Ingredient?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Fees Breakdown'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                userChef.chef!.chargeRateType == 'per guest' ?  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        maxLines: 1,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Guests',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,

                                  )
                              ),

                              TextSpan(
                                  text: ' x $numGuests',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13,
                                    color: Colors.grey,

                                  )
                              ),
                            ]
                        )),
                    Text(
                      '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromUserAddress(userChef)}${userChef.chef!.chargeRate * numGuests}',

                    ),

                  ],) : userChef.chef!.chargeRateType == 'per hour' ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        maxLines: 1,
                        text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Hours',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,

                                  )
                              ),

                              TextSpan(
                                  text: ' x $numHours',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13,
                                    color: Colors.grey,

                                  )
                              ),
                            ]
                        )),
                    Text(
                      '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromUserAddress(userChef)}${userChef.chef!.chargeRate * numHours}',

                    ),

                  ],) : Container(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: foodItems.keys.map((key) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: foodItems[key]!.title!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16,
                                    color: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,

                                  )
                                ),

                                TextSpan(
                                    text: ' x ${itemsQuantity[key]}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 13,
                                      color: Colors.grey,

                                    )
                                ),
                              ]
                          )),
                        ),
                      Text(
                        '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromUserAddress(userChef)}${foodItems[key]!.cost * itemsQuantity[key]!}',

                      ),

                    ],),
                  )).toList()
                ),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tr.total,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),

                    Text(
                      '${CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromUserAddress(userChef)}$total',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),

                    ),

                  ],
                )
              ],
            ),
          );
        }
    );
}

  Future<Ingredient?> showIngredientDialog(Ingredient ingredient) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final _session = const Uuid().v4();
    Address? ingredientLocation;
    TextEditingController ingredientLocationController = TextEditingController();

    ingredientLocation = ingredient.ingredientLocationAddress;
    ingredientLocationController.text = ingredient.canBeFoundAtAnyGroceryStore! ? '' : ingredient.ingredientLocationAddress != null ? ingredient.ingredientLocationAddress!.placeName! : '';
    String? _name;
    double? measurement;
    String? measurementString;

    return await showDialog<Ingredient?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Ingredient'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Name',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 10,),


                    TextFormField(
                      initialValue: ingredient.name,
                      // onChanged: (value) {
                      //   _name = value;
                      // },
                      onSaved: (value) => _name = value,
                      validator: (value) => Validator().validateText(value, 'Enter an ingredient name'),
                      // controller: _textFieldController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        hintText: "e.g Milk"),
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'Measurement',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: ingredient.measurementValue != null ? '${ingredient.measurementValue}' : '',
                            // onChanged: (value) {
                            //   measurement = double.tryParse(value);
                            // },
                            onSaved: (value) => measurement = double.tryParse(value!),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            // controller: _textFieldController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: "e.g 0.5"),
                          ),
                        ),
                        const SizedBox(width: 10,),

                        Expanded(
                          flex: 2,
                          child: TextFormField(
                          initialValue: ingredient.ingredientMeasurement != null ? '${ingredient.ingredientMeasurement}' : '',
                          // onChanged: (value) {
                          //   measurementString = value;
                          // },
                            onSaved: (value) => measurementString = value,
                          // validator: (value) => Validator().validateText(value, 'Enter an ingredient name'),
                          // controller: _textFieldController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              hintText: "e.g tablespoon"),
                        ),)
                      ],
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'Location',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    const Text(
                        'Where can skibblers find this ingredient?',
                        style: TextStyle(color: Colors.grey, fontSize: 13,)
                    ),
                    const Text(
                        'Leave blank if this can be found at any grocery store',
                        style: TextStyle(color: Colors.grey, fontSize: 10,)
                    ),
                    const SizedBox(height: 10,),
                    //location
                    CustomTypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: ingredientLocationController,
                        onChanged: (value) {
                          if(value.trim().isEmpty) {
                            ingredientLocationController.text = '';
                            ingredientLocation = null;
                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: const Icon(Iconsax.location),
                            hintText: 'e.g Walmart'
                        ),
                      ),
                      containerDecoration: const BoxDecoration(),
                      containerMargin: EdgeInsets.zero,
                      onSuggestionSelected: (Suggestion suggestion) async{
                        // setState(() {
                          ingredientLocationController.text = suggestion.title + ", " + suggestion.subTitle!;
                          ingredientLocation = new Address(googlePlaceId: suggestion.id, placeName: suggestion.title, formattedAddress: suggestion.subTitle );
                        // });
                      },
                      suggestionCallback: (pattern) async {

                        return GoogleMapsService().getPlaceSuggestions(pattern, _session);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(

                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), )
                ),
                child: const Text('OK'),
                onPressed: () {
                  final form = _formKey.currentState;
                  if(form!.validate()) {
                    form.save();
                    Ingredient newIngredient = Ingredient(
                      name: _name!,
                      canBeFoundAtAnyGroceryStore: ingredientLocation != null ? false : true,
                      ingredientLocationAddress: ingredientLocation,
                      measurementValue: measurement,
                      ingredientMeasurement: measurementString
                    );
                    Navigator.of(context).pop(newIngredient);
                  }
                  // setState(() {
                  //   codeDialog = valueText;
                  //   Navigator.pop(context);
                  // });
                },
              ),
            ],
          );
        });
  }

  Future<Ingredient?> showIngredientDialogForShoppingList(String listId,
      {Ingredient? ingredient}) async {
    final GlobalKey<FormState> _formKey = GlobalKey();
    final _session = const Uuid().v4();
    Address? ingredientLocation;
    TextEditingController ingredientLocationController = TextEditingController();
    String? _name;
    num? measurement;
    double? estimatedCost;
    String measurementString = '';

    var userLocation = Provider.of<AppData>(context, listen:  false).userCurrentLocation;

    if(ingredient != null) {
      ingredientLocation = ingredient.ingredientLocationAddress;
      ingredientLocationController.text = ingredient.canBeFoundAtAnyGroceryStore! ? '' : ingredient.ingredientLocationAddress != null ? ingredient.ingredientLocationAddress!.placeName! : '';
      _name = ingredient.name;
      estimatedCost = ingredient.estimatedCost != null ? ingredient.estimatedCost : 0;
      measurement = ingredient.measurementValue != null ? ingredient.measurementValue! : 0;
      measurementString =  ingredient.ingredientMeasurement != null ? '${ingredient.ingredientMeasurement}' : '';
    }

    return await showDialog<Ingredient?>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(ingredient != null ? 'Edit Item' : 'Add Item'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                        'Name',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 10,),


                    TextFormField(
                      initialValue: _name,
                      // onChanged: (value) {
                      //   _name = value;
                      // },
                      onSaved: (value) => _name = value,
                      validator: (value) => ingredient != null ? Validator().validateText(value, 'This field cannot be empty') : Validator().validateItemInList(value, 'Enter an item name', context, listId),
                      // controller: _textFieldController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "e.g Milk"),
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'Estimated Cost (Optional)',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    TextFormField(
                      initialValue: '${estimatedCost != null ? estimatedCost : ''}',
                      // onChanged: (value) {
                      //   measurement = double.tryParse(value);
                      // },
                      onSaved: (value) => estimatedCost = double.parse(value!),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      // controller: _textFieldController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          prefixText: '${userLocation != null ? CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(userLocation.countryCode!) : ''}',
                          hintText: "e.g 3.45"),
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'Quantity (Optional)',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: '${measurement != null ? measurement : ''} ',
                            // onChanged: (value) {
                            //   measurement = double.tryParse(value);
                            // },
                            onSaved: (value) => measurement = double.parse(value!),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            // controller: _textFieldController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: "e.g 1"),
                          ),
                        ),
                        const SizedBox(width: 10,),

                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: measurementString,
                            // onChanged: (value) {
                            //   measurementString = value;
                            // },
                            onSaved: (value) => measurementString = value!,
                            // validator: (value) => Validator().validateText(value, 'Enter an ingredient name'),
                            // controller: _textFieldController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                hintText: "e.g bag"),
                          ),)
                      ],
                    ),

                    const SizedBox(height: 20,),

                    const Text(
                        'Location (Optional)',
                        style: TextStyle(fontSize: 17,)
                    ),

                    const SizedBox(height: 5,),

                    const Text(
                        'Where do you plan on getting this item?',
                        style: TextStyle(color: Colors.grey, fontSize: 13,)
                    ),
                    const Text(
                        'Leave blank if this can be found at any grocery store',
                        style: TextStyle(color: Colors.grey, fontSize: 10,)
                    ),
                    const SizedBox(height: 10,),
                    //location
                    CustomTypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: ingredientLocationController,
                        onChanged: (value) {
                          if(value.trim().isEmpty) {
                            ingredientLocationController.text = '';
                            ingredientLocation = null;

                          }
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            prefixIcon: const Icon(Iconsax.location),
                            hintText: 'e.g Walmart'
                        ),
                      ),
                      containerDecoration: const BoxDecoration(),
                      containerMargin: EdgeInsets.zero,
                      onSuggestionSelected: (Suggestion suggestion) async{
                        // setState(() {
                        ingredientLocationController.text = suggestion.title + ", " + suggestion.subTitle!;
                        ingredientLocation = new Address(googlePlaceId: suggestion.id, placeName: suggestion.title, formattedAddress: suggestion.subTitle );
                        // });
                      },
                      suggestionCallback: (pattern) async {

                        return GoogleMapsService().getPlaceSuggestions(pattern, _session);
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(

                ),
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), )
                ),
                child: const Text('OK'),
                onPressed: () {
                  final form = _formKey.currentState;
                  if(form!.validate()) {
                    form.save();
                    Ingredient newIngredient = Ingredient(
                      name: _name!,
                      canBeFoundAtAnyGroceryStore: ingredientLocation != null ? false : true,
                      ingredientLocationAddress: ingredientLocation,
                      measurementValue: measurement,
                      ingredientMeasurement: measurementString,
                      estimatedCost: estimatedCost,
                      estimatedCostString: '${userLocation != null ? CurrencyFormatter(context: context, currencyCode: '').getCurrencySymbolFromCountryCode(userLocation.countryCode!) : ''}$estimatedCost',
                      ingredientStatus: IngredientStatus.incomplete,
                      ingredientId: ingredient != null ? ingredient.ingredientId : '${DateTime.now().millisecondsSinceEpoch}'
                    );
                    Navigator.of(context).pop(newIngredient);
                  }
                  // setState(() {
                  //   codeDialog = valueText;
                  //   Navigator.pop(context);
                  // });
                },
              ),
            ],
          );
        });
  }


  Widget showPopupMenu(List<PopUpChoiceItem> popUpChoices, IconData childIcon,
      {required Function(int) onSelected, Color? iconColor, double? iconSize}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<int>(
          color:  CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
          onSelected: onSelected,
          tooltip: 'View Options',
          itemBuilder: (BuildContext context) {

            int index = 0;
            // List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];

            return List.generate(
                popUpChoices.length, (index) =>
                PopupMenuItem<int>(
                  value: index,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        popUpChoices[index].iconData,
                        color:(index == popUpChoices.length - 1) ? kErrorColor :  CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        popUpChoices[index].choiceString!,
                        style: TextStyle(
                          color: (index == popUpChoices.length - 1) ? kErrorColor : CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                      ),),
                    ],
                  ),

                ],
              ),
            )
            );

          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
          ),
          child: Container(
              padding: const EdgeInsets.all(
                  15.0),
              // decoration: BoxDecoration(
              //     shape: BoxShape
              //         .circle,
              // ),
            child: Icon(
              childIcon,
              color: iconColor != null ? iconColor : CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
              size: iconSize != null ? iconSize : null,
            )
          )
        ),
      ),
    );
  }


}