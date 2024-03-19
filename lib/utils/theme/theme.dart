// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:skibble/utils/constants.dart';
//
//
// // This is our  main focus
// // Let's apply light and dark theme on our app
//
// ThemeData lightThemeData(BuildContext context) {
//   return ThemeData.light().copyWith(
//     brightness: Brightness.light,
//       primaryColor: kPrimaryColor,
//       scaffoldBackgroundColor: kContentColorLightTheme,
//       appBarTheme: appBarTheme.copyWith(systemOverlayStyle: lightOverlayStyle),
//       iconTheme: IconThemeData(color: kBackgroundColorDarkTheme),
//       textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//           .apply(bodyColor: kBackgroundColorDarkTheme),
//       colorScheme: ColorScheme.light(
//         primary: kPrimaryColor,
//         secondary: kLightSecondaryColor,
//         error: kErrorColor,
//       ),
//       bottomAppBarTheme: BottomAppBarTheme(
//           color: kContentColorLightTheme
//       ),
//       chipTheme: ChipThemeData(backgroundColor: kPrimaryColor),
//       cardTheme: CardTheme(color: kLightSecondaryColor),
//       bottomSheetTheme: BottomSheetThemeData(backgroundColor: kLightSecondaryColor),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: Colors.white,
//         selectedItemColor: kBackgroundColorDarkTheme.withOpacity(0.7),
//         unselectedItemColor: kBackgroundColorDarkTheme.withOpacity(0.32),
//         selectedIconTheme: IconThemeData(color: kPrimaryColor),
//         showUnselectedLabels: true,
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//           backgroundColor: kPrimaryColor,
//           foregroundColor: Colors.white
//
//       ),
//     dialogTheme: DialogTheme(
//       backgroundColor: kContentColorLightTheme
//     )
//   );
// }
//
// ThemeData darkThemeData(BuildContext context) {
//   // By default, flutter provides us light and dark theme
//   // we just modify it as our need
//   return ThemeData.dark().copyWith(
//     brightness: Brightness.dark,
//       primaryColor: kPrimaryColor,
//       scaffoldBackgroundColor: kBackgroundColorDarkTheme,
//       appBarTheme: appBarTheme.copyWith(backgroundColor: kDarkSecondaryColor, systemOverlayStyle: darkOverlayStyle),
//       iconTheme: IconThemeData(color: kContentColorLightTheme),
//       textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//           .apply(bodyColor: kContentColorLightTheme),
//       colorScheme: ColorScheme.dark().copyWith(
//         primary: kPrimaryColor,
//         secondary: kLightSecondaryColor,
//         error: kErrorColor,
//       ),
//       bottomAppBarTheme: BottomAppBarTheme(
//         color: kDarkSecondaryColor
//       ),
//       bottomSheetTheme: BottomSheetThemeData(backgroundColor: kDarkSecondaryColor),
//
//       cardTheme: CardTheme(color: kDarkSecondaryColor),
//       chipTheme: ChipThemeData(backgroundColor: kDarkSecondaryColor),
//       bottomNavigationBarTheme: BottomNavigationBarThemeData(
//         backgroundColor: kBackgroundColorDarkTheme,
//         selectedItemColor: Colors.white70,
//         unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
//         selectedIconTheme: IconThemeData(color: kPrimaryColor),
//         showUnselectedLabels: true,
//       ),
//       floatingActionButtonTheme: FloatingActionButtonThemeData(
//           backgroundColor: kPrimaryColor,
//           foregroundColor: Colors.white
//
//       ),
//       dialogTheme: DialogTheme(
//           backgroundColor: kBackgroundColorDarkTheme
//       )
//
//   );
// }
// final lightOverlayStyle = SystemUiOverlayStyle(
//   // Status bar color
//   // statusBarColor: Colors.red,
//
//   // Status bar brightness (optional)
//   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
//   statusBarBrightness: Brightness.light, // For iOS (dark icons)
// );
//
// final darkOverlayStyle = SystemUiOverlayStyle(
//   // Status bar color
//   // statusBarColor: Colors.red,
//
//   // Status bar brightness (optional)
//   statusBarIconBrightness: Brightness.light, // For Android (dark icons)
//   statusBarBrightness: Brightness.light, // For iOS (dark icons)
// );


// final appBarTheme = AppBarTheme(
//   centerTitle: false,
//   elevation: 0,
//   backgroundColor: kContentColorLightTheme,
//   // systemOverlayStyle: SystemUiOverlayStyle(
//   //   // Status bar color
//   //   // statusBarColor: Colors.red,
//   //
//   //   // Status bar brightness (optional)
//   //   statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
//   //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
//   // ),
// );