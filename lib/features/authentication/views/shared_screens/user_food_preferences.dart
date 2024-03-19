import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import '../../../../../models/skibble_user.dart';
import '../../../../services/change_data_notifiers/picker_data/food_options_picker_data.dart';
import '../../../../shared/loading_spinner.dart';
import '../../../../utils/constants.dart';
import '../../controllers/auth_provider.dart';
import '../components/food_options_picker_view.dart';


/**
 * This is used when a new user signs up
 */
class UserFoodPreferencesView extends StatefulWidget {
  const UserFoodPreferencesView({
    Key? key,
    this.isStartScreen = false
  }) : super(key: key);

  final bool isStartScreen;


  @override
  State<UserFoodPreferencesView> createState() => _UserFoodPreferencesViewState();
}

class _UserFoodPreferencesViewState extends State<UserFoodPreferencesView> {

  // List<String> foodPrefs = [];
  List<String> cuisines = [];
  List<String> mealSpecific = [];
  List<String> cookingStyle = [];
  List<String> dietPrescriptions = [];
  List<String> custom = [];

  // List<String> selectFoodPrefs = [];

  int maxChoice = 20;

  @override
  void initState() {
    // foodPrefs.addAll(FoodPreferencesData.foodPreferences);
    // foodPrefs.sort((a, b) => a.compareTo(b));



    Provider.of<FoodOptionsPickerData>(context, listen: false).initNewChoices();

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
                            "Choose your food interests.",
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
                      "We\'d use your selections to suggest skibs, recipes, foodies and those secret yummy spots in your city.",
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
                        'Cuisines',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedFoodOptions(optionString: 'cuisines', limit: maxChoice,),



                      SizedBox(height: 30),

                      //meal specific
                      Text(
                        'Meal-Specific',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedFoodOptions(optionString: 'mealSpecific', limit: maxChoice),


                      SizedBox(height: 30),

                      //cooking style
                      Text(
                        'Cooking Style',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedFoodOptions(optionString: 'cookingStyle', limit: maxChoice),

                      SizedBox(height: 30),

                      //diet prescriptions
                      Text(
                        'Diet Prescriptions',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedFoodOptions(optionString: 'dietPrescriptions', limit: maxChoice),


                      SizedBox(height: 30),
                      //custom
                      Text(
                        'Custom',
                        style: TextStyle(fontSize: 22, fontWeight:  FontWeight.bold),),

                      SizedBox(height: 10,),

                      WrappedFoodOptions(optionString: 'custom', limit: maxChoice)

                    ],
                  ),

                ],
              ),
            ),
          ),
        ),

        //button
        Consumer<FoodOptionsPickerData>(
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
