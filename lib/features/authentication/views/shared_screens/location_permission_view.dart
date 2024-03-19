import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';


import '../../../../shared/loading_spinner.dart';
import '../../../../utils/constants.dart';
import '../../controllers/auth_provider.dart';

class LocationPermissionView extends StatelessWidget {
  const LocationPermissionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor),
              ) ,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: kPrimaryColor.withOpacity(0.5))
                  ) ,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kPrimaryColor.withOpacity(0.3)),

                        ) ,
                        child: const Center(child: Icon(Iconsax.location, color: kPrimaryColor, size: 40,))
                    ),
                  ),
                ),
              ),
            ),
          ),


          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SafeArea(
                  child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                  child: Column(
                    children: [
                      Text('Ready to Connect? Turn On Location Services Now!', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),

                      SizedBox(height: 8,),
                      Text('We use your location to suggest friends, nearby meets, and the best places to eat.', textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.grey),)

                    ],
                  ),
                )),


              ],
            ),
          ),

          // SizedBox(height: MediaQuery.of(context).size.height / 3,),


          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: ElevatedButton(
                          onPressed: () async{
                            var functions = context.read<SkibbleAuthProvider>().authFlowFunctions!.values.toList();
                            var functionValue = await functions[context.read<SkibbleAuthProvider>().currentPage]();

                            if(functionValue == true) {
                              context.read<SkibbleAuthProvider>().nextPage();
                            }
                          },
                          child: Consumer<LoadingController>(
                            builder: (context, data, child) {
                              return data.isLoadingSecond ? LoadingSpinner(color: kLightSecondaryColor, size: 20,) :Text('Enable location services', style: TextStyle(fontWeight: FontWeight.bold));
                            }
                          ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextButton(
                      onPressed: () async{
                        context.read<SkibbleAuthProvider>().nextPage();

                      },
                      child: Consumer<LoadingController>(
                          builder: (context, data, child) {
                            return data.isLoadingSecond ? LoadingSpinner(color: kLightSecondaryColor, size: 20,) :Text('Not now', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),);
                          }
                      ),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
