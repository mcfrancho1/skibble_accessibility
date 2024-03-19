import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skibble/controllers/loading_controller.dart';
import 'package:skibble/features/authentication/controllers/auth_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:skibble/models/skibble_user.dart';
import '../../../../../../services/change_data_notifiers/app_data.dart';
import '../../../../../../services/change_data_notifiers/picker_data/location_picker_data.dart';
import '../../../../../../shared/loading_spinner.dart';
import '../../../../../../utils/constants.dart';
import '../../../../../../utils/current_theme.dart';
import 'kitchen_account_details.dart';
import 'kitchen_details.dart';
import 'kitchen_qualifications_view.dart';


class UserKitchenRegisterPage extends StatefulWidget {
  const UserKitchenRegisterPage({Key? key}) : super(key: key);

  @override
  State<UserKitchenRegisterPage> createState() => _UserKitchenRegisterPageState();
}

class _UserKitchenRegisterPageState extends State<UserKitchenRegisterPage> {

  // int currentStep = 1;

  List<Widget> views = [

    UserKitchenDetailsView(),
    const UserKitchenQualificationsDetailsView(),
    const UserKitchenAccountDetails(),

  ];

  List<String> title = [
    'Kitchen Info',
    'Documentations',
    'Account Info',
    // 'Food Gallery',
  ];

  late final Future<bool> dataReady;

  @override
  void initState() {
    // TODO: implement initState
    // GeoLocatorService().getCurrentPositionAddress(context);
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) => loadUser(context));

    dataReady = loadUserKitchen(context);
  }

  Future<bool>loadUserKitchen(BuildContext context) async {
    var skibbleUser = Provider.of<AppData>(context, listen: false).skibbleUser!;

    if(skibbleUser.accountType == AccountType.kitchen && (skibbleUser.kitchen?.kitchenName == null || skibbleUser.kitchen?.serviceLocation == null)) {
      context.read<SkibbleAuthProvider>().signUpUserKitchenWithoutNotify = skibbleUser;
      context.read<LocationPickerData>().pickedLocationWithoutNotify = skibbleUser.kitchen?.serviceLocation;
      // context.read<AuthProvider>().currentSignUpStep = 1;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var currentStep = Provider.of<SkibbleAuthProvider>(context).currentSignUpStep;
    print(currentStep);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(preferredSize: const Size(double.infinity, 150),
          child: Container(
            decoration: BoxDecoration(
                color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircularStepProgressIndicator(
                    totalSteps: 3,
                    currentStep: currentStep + 1,
                    stepSize: 8,
                    selectedColor: kPrimaryColor,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 80,
                    height: 80,
                    selectedStepSize: 12,
                    roundedCap: (_, __) => true,
                    child: Center(
                      child: Text(
                        '${currentStep+1}/${views.length}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(title[currentStep], style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      currentStep == 2 ?
                      const Text('Almost Done!', style: TextStyle(fontSize: 15, color: Colors.grey),)
                          :
                      Text('Next: ${title[currentStep + 1]}', style: const TextStyle(fontSize: 15, color: Colors.grey),)
                    ],)
                ],
              ),
            ),
          ),
        ),
        body: views[currentStep]
    );
  }
}


class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key, this.onSkipPressed, required this.onBackPressed, required this.onNextPressed}) : super(key: key);
  final Function() onBackPressed;
  final Future<String?> Function() onNextPressed;
  final  Function()? onSkipPressed;

  @override
  Widget build(BuildContext context) {
    // var currentStep = Provider.of<AppData>(context).currentStep;
    var userChef = Provider.of<AppData>(context).currentUserChef;

    return  Consumer<SkibbleAuthProvider>(
      builder: (context, authData, child) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)
              ),
              color: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               if(onSkipPressed != null)
                 Expanded(
                   flex: 2,
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: ElevatedButton(
                       onPressed: () async{
                         if(authData.currentSignUpStep > 0) {
                           // currentStep -= 1;
                           int newStep = authData.currentSignUpStep;
                           newStep += 1;
                           await onSkipPressed!();
                           // print(currentStep);
                           context.read<SkibbleAuthProvider>().currentSignUpStep = newStep;
                         }
                         else {
                           Navigator.pop(context);
                         }
                       },
                       child: const Text('Skip', style: TextStyle(color: kPrimaryColor, fontSize: 20),),

                       style: ElevatedButton.styleFrom(
                           primary: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                           shape: RoundedRectangleBorder(
                               side: const BorderSide(color: kPrimaryColor),
                               borderRadius: BorderRadius.circular(10)
                           )
                       ),
                     ),
                   ),
                 ),


              Consumer<LoadingController>(
                builder: (context, data, child) {
                  return Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        onPressed: () async{

                          if(authData.currentSignUpStep < 2) {
                            // setState(() {
                            //   currentStep += 1;
                            data.isLoading = true;

                            var res = await onNextPressed!();
                            if(res == 'success') {
                              int newStep = authData.currentSignUpStep;
                              newStep += 1;
                              data.isLoading = false;
                              context.read<SkibbleAuthProvider>().currentSignUpStep = newStep;
                            }
                            else {
                              data.isLoading = false;
                            }
                            // Provider.of<AppData>(context, listen: false).updateCurrentStep(newStep);
                          }
                          else {
                            data.isLoading = true;
                            var res = await onNextPressed();
                            data.isLoading = false;
                            // var authService = Provider.of<AuthProvider>(context, listen: false).authService;
                            await authData.authService.reload(context);

                            // await saveAndUploadData(userChef!, context);
                          }

                        },
                        child: data.isLoading ?
                        const LoadingSpinner()
                            :
                        Text(
                          authData.currentSignUpStep == 2 ? 'Done' : 'Next',
                          style: const TextStyle(color: kLightSecondaryColor, fontSize: 20),),
                        style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,

                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                    ),
                  );
                }
              )

            ],
          ),
        );
      }
    );
  }
}


