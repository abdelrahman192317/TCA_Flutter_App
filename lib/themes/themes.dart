import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    //brightness: Brightness.light,
    primaryColor: const Color(0xff19A7CE),
    canvasColor: const Color(0xff146C94),
    focusColor: const Color(0xff146C94),
    dividerColor: const Color(0xff000000),
    colorScheme: const ColorScheme.light(
      //brightness: Brightness.light,
      background: Color(0xffF6F1F1),
      primary: Color(0xff19A7CE),
      secondary: Color(0xff146C94),
      shadow: Color(0xff000000),
      error: Colors.red
    ),
    iconTheme: const IconThemeData(color: Color(0xff000000)),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black87),
      displaySmall: TextStyle(color: Colors.black54),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Color(0xff19A7CE),
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8
    )),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: const Color(0xff146C94),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xff416d6d),
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    scaffoldBackgroundColor: const Color(0xffF6F1F1),
    disabledColor: Colors.grey,
    shadowColor: const Color(0xff000000),
  );

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xff044A42),
      canvasColor: const Color(0xff3a9188),
      focusColor: const Color(0xff3A9188),
      dividerColor: Colors.white,
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.light,
        background: Color(0xff062925),
        primary: Color(0xff044a42),
        secondary: Color(0xff3a9188),
        shadow: Colors.white,
        error: Colors.red
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white70),
        displaySmall: TextStyle(color: Colors.white60),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xff3a9188),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8
      )),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 8,
        color: const Color(0xff044a42),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color(0xff3a9188),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      scaffoldBackgroundColor: const Color(0xff062925),
      disabledColor: Colors.grey,
      shadowColor: Colors.white
  );

}