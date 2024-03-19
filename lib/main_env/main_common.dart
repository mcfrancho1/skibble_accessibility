


import 'dart:io';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_editor_sdk/photo_editor_sdk.dart';
import 'package:skibble/features/meets/services/storage/meets_local_storage.dart';
import 'package:skibble/features/notifications/controllers/notifications_controller.dart';
import 'package:skibble/env/env.dart';
import 'package:skibble/utils/environment.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import '../firebase_options.dart';
import '../features/notifications/services/notifications_service.dart';
import '../services/internal_storage.dart';
import '../services/preferences/preferences.dart';
import '../utils/app_config.dart';

Future<void> setupInitializations() async{
  WidgetsBinding widgetsBinding = await WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey ="pk_live_51Hc2GWGzwgI7GwVIFunWcziCIOBtFyA873VQD6GdyNbywjkJXa2weIYPrdLS4y75pIyMhP2VUxecB5kVw2ZC2JRz000fa8iGXK";
  Stripe.merchantIdentifier = "com.mcfranchostudios.skibble";

  // await EasyLocalization.ensureInitialized();
  //used this to solve the Bad State: Stream Already listened to error


  //options: DefaultFirebaseOptions.currentPlatform
  await Firebase.initializeApp().then((value) async{
    registerErrorHandlers();
    ///using future,wait
    // await Future.wait([
    //   Stripe.instance.applySettings(),
    //   GetStorage.init(),
    //   AppEnvironment.init(),
    //   Hive.initFlutter(),
    //   Preferences.init(),
    //   InternalStorageService.init(),
    //   MeetsLocalStorage.init(),
    //   CustomAwesomeNotifications.initialise(),
    //
    //   FirebaseAppCheck.instance.activate(
    //     // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    //     // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    //     // your preferred provider. Choose from:
    //     // 1. Debug provider
    //     // 2. Safety Net provider
    //
    //     // 3. Play Integrity provider
    //     androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    //     // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    //     // your preferred provider. Choose from:
    //     // 1. Debug provider
    //     // 2. Device Check provider
    //     // 3. App Attest provider
    //     // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    //     appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    //   )
    // ]);

    ///
    await Stripe.instance.applySettings();
    await GetStorage.init();
    await AppEnvironment.init();
    await Hive.initFlutter();
    await Preferences.init();
    await InternalStorageService.init();
    await MeetsLocalStorage.init();
    await NotificationController.initialise();
    await NotificationController.interceptInitialCallActionRequest();
    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
    );

    ///
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // if(NavigationService.navigatorKey.currentContext != null) {
    //
    // }



    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   // systemNavigationBarColor: Colors.transparent, // navigation bar color
    //   // statusBarBrightness: Brightness.light,//status bar brightness
    //   // statusBarIconBrightness:Brightness.dark ,
    //   // statusBarColor: Platform.isAndroid ? kPrimaryColor : null,
    //   // systemNavigationBarIconBrightness: Brightness.dark,
    // ));

    // final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();

  });

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);


}

void registerErrorHandlers() async{
  // * Show some error UI if any uncaught exception happens
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    FirebaseCrashlytics.instance.recordFlutterFatalError;
    // debugPrint(details.toString());
  };
  // * Handle errors from the underlying platform/OS
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    debugPrint(error.toString());
    return true;
  };

  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  // if (kReleaseMode) exit(1);

  // * Show some error UI when any widget in the app fails to build
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.red,
  //       title: Text('An error occurred'),
  //     ),
  //     body: Center(child: Text(details.toString())),
  //   );
  // };
}



