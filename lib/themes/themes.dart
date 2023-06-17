import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    //brightness: Brightness.light,
    primaryColor: const Color(0xff22BB9C),
    canvasColor: const Color(0xff22BB9C),
    focusColor: const Color(0xff22BB9C).withOpacity(0.1),
    dividerColor: const Color(0xffBBBBBB),
    hintColor: Colors.white,
    splashColor: Colors.white,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: Color(0xff22BB9C),
      secondary: Color(0xff22BB9C),
      shadow: Colors.black,
      error: Colors.red,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.black)),
      displayMedium: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.black87)),
      displaySmall: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.black54)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        shadowColor: const Color(0xff22BB9C),
        backgroundColor: const Color(0xff22BB9C),
        textStyle: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
      )
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      shadowColor: Colors.black,
      color: Colors.white,
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    disabledColor: const Color(0xff909090),
    shadowColor: Colors.black54,
  );

  static ThemeData darkTheme = ThemeData(
    //brightness: Brightness.light,
    primaryColor: const Color(0xff22BB9C),
    canvasColor: const Color(0xff22BB9C),
    focusColor: const Color(0xff22BB9C).withOpacity(0.1),
    dividerColor: const Color(0xffBBBBBB),
    hintColor: const Color(0xff35383F),
    splashColor: const Color(0xff181A20),
    colorScheme: const ColorScheme.light(
      background: Color(0xff181A20),
      primary: Color(0xff22BB9C),
      secondary: Color(0xff22BB9C),
      shadow: Colors.white60,
      error: Colors.red,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
      displayMedium: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white70)),
      displaySmall: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white60)),
      titleLarge: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
      titleMedium: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white70)),
      titleSmall: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white60)),
      bodyLarge: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
      bodyMedium: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white70)),
      bodySmall: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white60)),
      labelLarge: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          shadowColor: const Color(0xff22BB9C),
          backgroundColor: const Color(0xff22BB9C),
          textStyle: GoogleFonts.roboto(textStyle: const TextStyle(color: Colors.white)),
        )
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      shadowColor: Colors.white60,
      color: const Color(0xff35383F),
    ),
    dialogTheme: const DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      elevation: 10,
      backgroundColor: Color(0xff35383F),
    ),
    scaffoldBackgroundColor: const Color(0xff181A20),
    disabledColor: const Color(0xff828282),
    shadowColor: Colors.white70,
  );

}