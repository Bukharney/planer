import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static const Color bluishClr = Color(0xFF4e5ae8);
  static const Color yellowClr = Color(0xFFFFB746);
  static const Color pinkClr = Color(0xFFff4667);
  static const Color white = Colors.white;
  static const Color darkGreyClr = Color(0xFF121212);
  static const Color darkHeaderClr = Color(0xFF424242);
  static const primaryClr = bluishClr;

  static final dark = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: darkGreyClr,
      elevation: 0,
    ),
    backgroundColor: darkGreyClr,
    primaryColor: primaryClr,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkGreyClr,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkGreyClr,
      selectedItemColor: primaryClr,
      unselectedItemColor: white,
    ),
  );

  static final light = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
    ),
    backgroundColor: Colors.white,
    primaryColor: primaryClr,
    brightness: Brightness.light,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: white,
      selectedItemColor: primaryClr,
      unselectedItemColor: darkHeaderClr,
    ),
  );
}

TextStyle get subHeadingStyle => GoogleFonts.lato(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.grey,
    );

TextStyle get headingStyle => GoogleFonts.lato(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    );

TextStyle get titleStyle => GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

TextStyle get hintStyle => GoogleFonts.lato(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
