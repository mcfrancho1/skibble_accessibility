import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';


// This is our  main focus
// Let's apply light and dark theme on our app


final appBarTheme = const AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: kContentColorLightTheme,
);

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: kPrimaryColor,
      useMaterial3: false,
      scaffoldBackgroundColor: kContentColorLightTheme,
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: kBackgroundColorDarkTheme),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: kBackgroundColorDarkTheme),
      colorScheme: const ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kContentColorLightTheme,
        error: kErrorColor,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
          color: kLightSecondaryColor
      ),
      chipTheme: ChipThemeData(backgroundColor: kPrimaryColor),
      cardTheme: CardTheme(color: kLightSecondaryColor),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: kLightSecondaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: kBackgroundColorDarkTheme.withOpacity(0.7),
        unselectedItemColor: kBackgroundColorDarkTheme.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: kPrimaryColor),
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white

      ),
      dialogTheme: DialogTheme(
          backgroundColor: kContentColorLightTheme
      )
  );
}