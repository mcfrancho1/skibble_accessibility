import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:skibble_accessibility/routing/route_generator.dart';
import 'package:skibble_accessibility/services/firebase/auth_services/skibble_auth_service.dart';
import 'package:skibble_accessibility/services/preferences/theme_preferences.dart';
import 'package:skibble_accessibility/utils/constants.dart';
import 'package:skibble_accessibility/utils/theme/dark_theme.dart';
import 'package:skibble_accessibility/utils/theme/light_theme.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'features/authentication/controllers/auth_service_adapter.dart';
import 'features/authentication/controllers/email_link_handler.dart';
import 'features/authentication/controllers/email_secure_storage.dart';
import 'features/authentication/views/auth_widget.dart';
import 'features/authentication/views/auth_widget_builder.dart';
import 'models/skibble_user.dart';
import 'navigator_provider.dart';

class NewSkibbleApp extends StatefulWidget {
  const NewSkibbleApp({  Key? key}) : super(key: key);
  // static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  @override
  State<NewSkibbleApp> createState() => _NewSkibbleAppState();
}

class _NewSkibbleAppState extends State<NewSkibbleApp> {

  late UniqueKey _materialKey;
  @override
  void initState() {
    // TODO: implement initState
    // Only after at least the action method is set, the notification events are delivered

    // final router = FluroRouter();
    // Routes.configureRoutes(router);
    // ApplicationRouter.router = router;

    NotificationController.initializeNotificationsEventListeners();

    _materialKey = UniqueKey();
    super.initState();

  }


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        // Provider<AppleSignInAvailable>.value(value: appleSignInAvailable),
        Provider<SkibbleAuthService>(
            create: (_) => AuthServiceAdapter(initialAuthServiceType: AuthServiceType.firebase, context: context),
            dispose: (_, SkibbleAuthService authService) => authService.dispose()
        ),
        Provider<EmailSecureStore>(
          create: (_) => EmailSecureStore(
            flutterSecureStorage: FlutterSecureStorage(),
          ),
        ),
        ProxyProvider2<SkibbleAuthService, EmailSecureStore, FirebaseEmailLinkHandler>(
          update: (_, SkibbleAuthService authService, EmailSecureStore storage, __) =>
          FirebaseEmailLinkHandler(
            auth: authService,
            emailStore: storage,
            firebaseDynamicLinks: FirebaseDynamicLinks.instance,
          )..init(),
          dispose: (_, linkHandler) => linkHandler.dispose(),
        ),
        // ChangeNotifierProvider(create: (context) => AppData(),),

      ],
      child: AuthWidgetBuilder(
        builder: (BuildContext context, AsyncSnapshot<SkibbleUser?> snapshot,) {
          // print('lol');
          return MaterialApp(
            key: _materialKey,

            navigatorKey: AppNavigator.instance.navigatorKey,
            // routeInformationParser: goRouter.routeInformationParser,
            // routerDelegate: goRouter.routerDelegate,
            // routeInformationProvider: goRouter.routeInformationProvider,
            // onGenerateInitialRoutes: onGenerateInitialRoutes,
            onGenerateRoute: RouteGenerator.onGenerateRoute,
            // onGenerateRoute: ApplicationRouter.router.generator,
            // routes: materialRoutes,
            title: 'Skibble',
            // localizationsDelegates: context.localizationDelegates,
            // supportedLocales: context.supportedLocales,
            //   locale: const Locale("en"),
            // supportedLocales: AppLocalizations.supportedLocales,
            // localizationsDelegates: [
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            //   AppLocalizations.delegate
            // ],
            // localizationsDelegates: AppLocalizations.localizationsDelegates,
            // locale: data.locale,

            // initialBinding: InitialBinding(),
            themeMode: ThemeController.getThemeController().themeStateFromHiveSettingBox,
            theme: lightThemeData(context).copyWith(
              extensions: [
                WoltModalSheetThemeData(
                    // topBarShadowColor: kErrorColorDark,
                    topBarElevation: 0
                ),
              ]
            ),

            darkTheme: darkThemeData(context),
            debugShowCheckedModeBanner: false,

            // translations: LocalizationService(),
            // locale: LocalizationService().getCurrentLocale(),
            initialRoute: '/',
            // onGenerateInitialRoutes: ( String initialRouteName) {
            //   return [
            //     RouteGenerator.onGenerateRoute(RouteSettings(name:RouteGenerator.homePage, arguments: snapshot)),
            //   ];
            // },

            home: AuthWidget(userSnapshot: snapshot!,),
            ///
            // FutureBuilder<bool>(
            //   future: VersioningService().checkVersionWithBackend('1'),
            //   builder: (context, vSnapshot) {
            //
            //     switch(vSnapshot.connectionState) {
            //
            //       case ConnectionState.none:
            //       case ConnectionState.waiting:
            //        return const LoadingPage();
            //       case ConnectionState.active:
            //       case ConnectionState.done:
            //       if(vSnapshot.hasData) {
            //         return AuthWidget(userSnapshot: snapshot,);
            //       }
            //       else {
            //         //update flutter app
            //         return Scaffold(
            //           body:  Center(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.center,
            //               children: [
            //                 Text('App out of Date', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: kDarkSecondaryColor),),
            //
            //                 SizedBox(height: 10,),
            //                 Text('Please upgrade your app version to continue.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
            //
            //
            //                 SizedBox(height: 30,),
            //
            //
            //                 Center(
            //                   child: ElevatedButton(
            //                     onPressed: () async{
            //                       VersioningService().openAppStoreForUpdate();
            //                       // await data.deleteMeet( _navigator.context,  widget.meet, scoreToDeduct);
            //
            //                     },
            //                     style: ElevatedButton.styleFrom(
            //                         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            //                         shape: const RoundedRectangleBorder(
            //                             borderRadius: BorderRadius.all(Radius.circular(30))
            //                         ),
            //                         backgroundColor: kDarkSecondaryColor,
            //                         elevation: 0
            //                     ),
            //                     child: const Text(
            //                       'Update App',
            //                       style: TextStyle(
            //                           fontWeight: FontWeight.bold,
            //                           fontSize: 14
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         );
            //       }
            //     }
            //   }
            // ),

            ///
            builder: (context, child) {

              //catching errors
              Widget error = const Text('Oops! Something went wrong...', style: TextStyle(color: kDarkSecondaryColor, fontWeight: FontWeight.bold),);

              // if (child is Scaffold || child is Navigator) {
                error = Scaffold(body: Center(child: error));
              // }
              ErrorWidget.builder = (errorDetails) => error;

              if (child != null) {
                return child;
              }
              else {
                throw ('something went wrong');
              }
            },

            // home: EmailLinkErrorPresenter.create(context, child: AuthWidget(userSnapshot: snapshot,)),
            // translations: LocalizationService(),
            // fallbackLocale: Locale('en', 'US'),

            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (locale.languageCode == deviceLocale!.languageCode &&
                    locale.countryCode == deviceLocale.countryCode) {
                  return deviceLocale;
                }
              }
              return supportedLocales.first;
            },
          );
        },
      ),
    );
  }
}
