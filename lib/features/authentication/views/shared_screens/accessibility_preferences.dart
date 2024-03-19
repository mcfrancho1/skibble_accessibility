import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/change_data_notifiers/picker_data/accessibility_options_picker_data.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/size_config.dart';
import '../../controllers/auth_provider.dart';
import '../components/food_options_picker_view.dart';



/**
 * This is used when a new user signs up
 */
class AccessibilityPreferencesView extends StatefulWidget {
  const AccessibilityPreferencesView({
    Key? key,
    this.isStartScreen = false
  }) : super(key: key);

  final bool isStartScreen;


  @override
  State<AccessibilityPreferencesView> createState() => _AccessibilityPreferencesViewState();
}

class _AccessibilityPreferencesViewState extends State<AccessibilityPreferencesView> {

  // List<String> foodPrefs = [];
  List<String> parking = [];
  List<String> entrance = [];
  List<String> seating = [];
  List<String> menu = [];
  List<String> restroom = [];

  // List<String> selectFoodPrefs = [];

  int maxChoice = 20;

  @override
  void initState() {
    // foodPrefs.addAll(FoodPreferencesData.foodPreferences);
    // foodPrefs.sort((a, b) => a.compareTo(b));



    Provider.of<AccessibilityOptionsPickerData>(context, listen: false).initNewChoices();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 60, bottom: 90),
              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  // SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                            "Accessibility Preferences.",
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(23),
                              fontWeight: FontWeight.bold,
                              // color: Colors.black,
                              height: 1.5,
                            )),
                      ),

                    ],
                  ),

                  const SizedBox(height: 10,),

                  const Text(
                      "We\'d use your selections to suggest the best restaurants in your city that meet your accessibility needs.",
                      // textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey)
                  ),

                  SizedBox(height: SizeConfig.screenHeight * 0.025),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Select a maximum of 20",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey)
                      ),


                      // Text(
                      //     "${selectFoodPrefs.length}",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(color: Colors.grey)
                      // ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Divider(),

                  // SizedBox(height: SizeConfig.screenHeight * 0.03),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),

                      //cuisines
                      Text(
                        'Parking',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedAccessibilityOptions(optionString: 'parking', limit: maxChoice,),



                      SizedBox(height: 30),

                      //meal specific
                      Text(
                        'Entrance',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedAccessibilityOptions(optionString: 'entrance', limit: maxChoice),


                      SizedBox(height: 30),

                      //cooking style
                      Text(
                        'Seating',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedAccessibilityOptions(optionString: 'seating', limit: maxChoice),

                      SizedBox(height: 30),

                      //diet prescriptions
                      Text(
                        'Restrooms',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedAccessibilityOptions(optionString: 'restroom', limit: maxChoice),


                      SizedBox(height: 30),
                      //custom
                      Text(
                        'Menus',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedAccessibilityOptions(optionString: 'menu', limit: maxChoice)

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),

        //button
        Consumer<AccessibilityOptionsPickerData>(
            builder: (context, data, child) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 80,
                child: Container(
                  decoration: BoxDecoration(
                      color: kContentColorLightTheme,
                      border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5))
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      RichText(text: TextSpan(
                          children: [
                            TextSpan(
                                text: "${data.newUserChoices.length}",
                                style: const TextStyle(color: kDarkSecondaryColor, fontSize: 17, fontWeight: FontWeight.bold)
                            ),
                            const TextSpan(
                                text: " / ",
                                style: TextStyle(color: kDarkSecondaryColor)
                            ),
                            const TextSpan(
                                text: "20",
                                style: TextStyle(color: kDarkSecondaryColor, fontSize: 15)
                            ),

                            const TextSpan(
                                text: " selected",
                                style: TextStyle(color: kDarkSecondaryColor, fontSize: 15)
                            )
                          ]
                      )),

                      SizedBox(
                        height: 30,
                        child: ElevatedButton(
                          onPressed:
                          data.newUserChoices.isNotEmpty ? () async{
                            var functions = context.read<SkibbleAuthProvider>().authFlowFunctions!.values.toList();
                            var functionValue = await functions[context.read<SkibbleAuthProvider>().currentPage]();

                          } : null,

                          style: ElevatedButton.styleFrom(
                            // padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30))
                            ),
                            backgroundColor: kPrimaryColor,
                            elevation: 0,
                          ),

                          child: Consumer<LoadingController>(
                              builder: (context, loading, child) {
                                return loading.isLoading ? const LoadingSpinner(color: kLightSecondaryColor, size: 15,) : const Text(
                                  'Done',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kLightSecondaryColor),
                                );
                              }
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              );
            }
        ),


      ],
    );
  }
}
