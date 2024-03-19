import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as cu;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../services/change_data_notifiers/picker_data/accessibility_options_picker_data.dart';
import '../../../../services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/current_theme.dart';


class FoodOptionsPickerView extends StatefulWidget {
  const FoodOptionsPickerView({Key? key, this.limit = 10}) : super(key: key);
  final int? limit;

  @override
  State<FoodOptionsPickerView> createState() => _FoodOptionsPickerViewState();
}

class _FoodOptionsPickerViewState extends State<FoodOptionsPickerView> {

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FoodOptionsPickerData>(context, listen: false).initNewChoices();

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 35,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10)),
              child: Text('Cancel', style: TextStyle(color: Colors.blueGrey),),
            ),

            Consumer<FoodOptionsPickerData>(
                builder: (context, data, child) {
                  return data.didChoicesChange ? TextButton(
                    onPressed: () {
                      context.read<FoodOptionsPickerData>().saveFinalChoices();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 10)),
                    child: Text('Done', style: TextStyle(color: kPrimaryColor),),
                  ) : Container();
                }
            ),
          ],
        ),


        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10,  bottom: 10, top: 8),
          child: Text(
            'Food Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        ),

        Consumer<FoodOptionsPickerData>(

            builder: (context, data, child) {
              return data.newUserChoices.isEmpty ? Container() : SizedBox(
                height: 25,
                child: ListView.builder(
                  itemCount: data.newUserChoices.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,),
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(20),
                        border:  Border.all(width: 0)
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          data.newUserChoices[index].capitalizeFirst!,
                          style: TextStyle(
                              color: data.newUserChoices.contains(data.newUserChoices[index].capitalizeFirst!) ? kLightSecondaryColor : Colors.blueGrey,
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),
                        ),

                        SizedBox(width: 3,),
                        GestureDetector(
                            onTap: () => data.removeFromNewUserChoiceAtIndex(index),
                            child: Icon(Icons.clear_rounded, size: 16, color: kContentColorLightTheme,))
                      ],
                    ),
                  ),
                ),
              );
            }
        ),


        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10, bottom: 8),
          child: SizedBox(
            height: 34,
            child: TextFormField(
              keyboardType: TextInputType.text,
              controller: controller,
              style: TextStyle(fontSize: 14),
              onFieldSubmitted: (newValue) {
                if(newValue.trim().isNotEmpty) {
                  if(!context.read<FoodOptionsPickerData>().newUserChoices.contains(newValue.capitalizeFirst!)) {
                    context.read<FoodOptionsPickerData>().addToUserChoice(newValue.capitalizeFirst!);
                    controller.clear();

                  }
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,

                ),
                // label: Text('Meal Invite Title'),
                // labelStyle: TextStyle(fontSize: 20.0, height: 0.8),
                // alignLabelWithHint: true,
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.zero,

                // contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                hintText: "Add any specific food you have in mind",
                prefixIcon: Icon(cu.CupertinoIcons.search, size: 20,),
                hintStyle: TextStyle(color: Colors.grey.shade400),

                // If  you are using latest version of flutter then label text and hint text shown like this
                // if you r using flutter less then 1.20.* then maybe this is not working properly
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                // suffixIcon: Icon(Iconsax.user),
              ),

            ),
          ),
        ),


        Expanded(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),

                  //cuisines
                  Text(
                    'Cuisines',
                    style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                  SizedBox(height: 10,),

                  WrappedFoodOptions(optionString: 'cuisines', limit: widget.limit,),



                  SizedBox(height: 30),

                  //meal specific
                  Text(
                    'Meal-Specific',
                    style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                  SizedBox(height: 10,),

                  WrappedFoodOptions(optionString: 'mealSpecific', limit: widget.limit),


                  SizedBox(height: 30),

                  //cooking style
                  Text(
                    'Cooking Style',
                    style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                  SizedBox(height: 10,),

                  WrappedFoodOptions(optionString: 'cookingStyle', limit: widget.limit),

                  SizedBox(height: 30),

                  //diet prescriptions
                  Text(
                    'Diet Prescriptions',
                    style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                  SizedBox(height: 10,),

                  WrappedFoodOptions(optionString: 'dietPrescriptions', limit: widget.limit),


                  SizedBox(height: 30),
                  //custom
                  Text(
                    'Custom',
                    style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                  SizedBox(height: 10,),

                  WrappedFoodOptions(optionString: 'custom', limit: widget.limit)

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}


class WrappedFoodOptions extends StatelessWidget {
  const WrappedFoodOptions({Key? key, required this.optionString, this.limit = 10}) : super(key: key);
  final String optionString;
  final int? limit;
  @override
  Widget build(BuildContext context) {
    return Consumer<FoodOptionsPickerData>(
        builder: (context, data, child) {
          List<String> foodList = [];
          switch(optionString) {
            case 'cuisines':
              foodList = data.cuisines;
              break;
            case 'mealSpecific':
              foodList = data.mealSpecific;
              break;
            case 'dietPrescriptions':
              foodList = data.dietPrescriptions;
              break;
            case 'custom':
              foodList = data.custom;
              break;

            case 'cookingStyle':
              foodList = data.cookingStyle;
              break;
          }

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodList.map((food) =>
                GestureDetector(
                  onTap: () {
                    if(!data.newUserChoices.contains(food.capitalizeFirst!)) {

                      if(limit == null) {
                        data.addToUserChoice(food.capitalizeFirst!);

                      }

                      else if(data.newUserChoices.length < limit!) {
                        data.addToUserChoice(food.capitalizeFirst!);

                      }
                    }
                    else {
                      data.removeFromUserChoice(food.capitalizeFirst!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: data.newUserChoices.contains(food.capitalizeFirst!) ? kPrimaryColor : Colors.grey.shade400)
                    ),
                    child: Text(
                      '${data.getTagEmoji(food)} ${food.capitalizeFirst!}',
                      style: TextStyle(
                          color: data.newUserChoices.contains(food.capitalizeFirst!) ? kBackgroundColorDarkTheme : Colors.blueGrey,
                          fontSize: 13
                      ),
                    ),
                  ),
                )
            ).toList(),
          );
        }
    );
  }
}

class WrappedAccessibilityOptions extends StatelessWidget {
  const WrappedAccessibilityOptions({Key? key, required this.optionString, this.limit = 10}) : super(key: key);
  final String optionString;
  final int? limit;
  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityOptionsPickerData>(
        builder: (context, data, child) {
          List<String> foodList = [];
          switch(optionString) {
            case 'parking':
              foodList = data.parking;
              break;
            case 'seating':
              foodList = data.seating;
              break;
            case 'entrance':
              foodList = data.entrance;
              break;

            case 'restroom':
              foodList = data.restroom;
              break;

            case 'menu':
              foodList = data.menu;
              break;

          // case 'restroom':
          //   foodList = data.re;
          //   break;

          }

          return Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodList.map((food) =>
                GestureDetector(
                  onTap: () {
                    if(!data.newUserChoices.contains(food.capitalizeFirst!)) {

                      if(limit == null) {
                        data.addToUserChoice(food.capitalizeFirst!);

                      }

                      else if(data.newUserChoices.length < limit!) {
                        data.addToUserChoice(food.capitalizeFirst!);

                      }
                    }
                    else {
                      data.removeFromUserChoice(food.capitalizeFirst!);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        color: CurrentTheme(context).isDarkMode ? kBackgroundColorDarkTheme : kContentColorLightTheme,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: data.newUserChoices.contains(food.capitalizeFirst!) ? kPrimaryColor : Colors.grey.shade400)
                    ),
                    child: Text(
                      '${data.getTagEmoji(food)} ${food.capitalizeFirst!}',
                      style: TextStyle(
                          color: data.newUserChoices.contains(food.capitalizeFirst!) ? kBackgroundColorDarkTheme : Colors.blueGrey,
                          fontSize: 13
                      ),
                    ),
                  ),
                )).toList(),
          );
        }
    );
  }
}
