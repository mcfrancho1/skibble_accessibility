import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

final appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  backgroundColor: kLightSecondaryColor,
);

ThemeData darkThemeData(BuildContext context) {
  // By default, flutter provides us light and dark theme
  // we just modify it as our need
  return ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kBackgroundColorDarkTheme,
      appBarTheme: appBarTheme.copyWith(backgroundColor: kDarkSecondaryColor),
      iconTheme: IconThemeData(color: kContentColorLightTheme),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: kContentColorLightTheme),
      colorScheme: ColorScheme.dark().copyWith(
        primary: kPrimaryColor,
        secondary: kLightSecondaryColor,
        error: kErrorColor,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
          color: kDarkSecondaryColor
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: kDarkSecondaryColor),

      cardTheme: CardTheme(color: kDarkSecondaryColor),
      chipTheme: ChipThemeData(backgroundColor: kDarkSecondaryColor),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kBackgroundColorDarkTheme,
        selectedItemColor: Colors.white70,
        unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: kPrimaryColor),
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white

      ),
      dialogTheme: DialogTheme(
          backgroundColor: kBackgroundColorDarkTheme
      )

  );
}