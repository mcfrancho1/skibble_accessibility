import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:skibble/services/firebase/skibble_functions_handler.dart';
import 'package:skibble/utils/constants.dart';
import 'package:skibble/utils/current_theme.dart';

import '../models/booking.dart';
import '../models/skibble_user.dart';

class PaymentsService {
  String url ='https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';

  final testKey = 'pk_test_51Hc2GWGzwgI7GwVIokfHPHfMcq6e4HkMm7xKJWlyAQqKDkroTNOMSwKNLShOWS0B1yNeroTCkTDyAaLklVJzsjCc00b11cmFh9';
  // final liveKey = 'pk_live_51Hc2GWGzwgI7GwVIFunWcziCIOBtFyA873VQD6GdyNbywjkJXa2weIYPrdLS4y75pIyMhP2VUxecB5kVw2ZC2JRz000fa8iGXK';


  Future<bool> initializePaymentSheet(double subTotal, double total, double taxRate, SkibbleUser chef, SkibbleUser user, context) async {
    try {
      var result = await SkibbleFirebaseFunctions().callFunction(
          'startPaymentProcessing',
          data:  {
            'subTotal': subTotal,
            'total': total,
            'receiverId': chef.userId,
            'taxRate': taxRate
          });



      if(result != null) {
        // Stripe.publishableKey = testKey;

        BillingDetails details = BillingDetails(
          name: user.fullName,
          email: user.userEmailAddress,
          // address: Address(
          //   city: 'Houston',
          //   country: 'US',
          //   line1: '1459  Circle Drive',
          //   line2: '',
          //   state: 'Texas',
          //   postalCode: '77063',
          // ),
        );

        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              // applePay: true,
              // googlePay: true,
              // testEnv: true,
              merchantDisplayName: 'Skibble',
              billingDetails: details,
              // merchantCountryCode: 'CA',
              appearance: PaymentSheetAppearance(
                shapes: PaymentSheetShape(
                  borderWidth: 2,
                  // shadow: PaymentSheetShadowParams(color: Colors.red),
                ),
                colors: PaymentSheetAppearanceColors(
                  background: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                  componentBackground: CurrentTheme(context).isDarkMode ? kDarkSecondaryColor : kLightSecondaryColor,
                  componentBorder: Colors.grey,
                  componentDivider: Colors.grey,
                  componentText: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                  secondaryText: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                  placeholderText: Colors.grey,
                  icon: CurrentTheme(context).isDarkMode ? kLightSecondaryColor : kDarkSecondaryColor,
                )
                // primaryButton: PaymentSheetPrimaryButtonAppearance(
                //   colors: PaymentSheetPrimaryButtonTheme(
                //     dark:
                //   ),
                // )
              ),
              paymentIntentClientSecret: result['paymentIntent'],
              customerEphemeralKeySecret: result['ephemeralKey'],
              customerId: result['customer'],
        ));
        //

        return true;
      }

      else {
        return false;
      }
    }
    catch(e) { return false;}
  }


  Future<String> displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      return 'success';

    } on Exception catch (e) {
      if (e is StripeException) {
       return '${e.error.localizedMessage}';
      }
      else {
       return 'unknown';
      }
    }
  }

  // Future<bool> saveChefToStripeConnect(String email) async{
  //   try {
  //
  //     var result = await SkibbleFirebaseFunctions().callFunction('createChefAccountOnStripe', data: {'email': email});
  //   }
  //   catch(e) {}
  // }
}