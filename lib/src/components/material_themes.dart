import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;

ThemeData materialThemes() {
  return ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
        color: evmColor.backgroundColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'NanumSquare',
      ),
      iconTheme: IconThemeData(color: evmColor.backgroundColor),
      actionsIconTheme: IconThemeData(color: evmColor.backgroundColor),
      elevation: 0.0,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: evmColor.backgroundColor,
      backgroundColor: Colors.white,
      splashColor: Colors.black.withOpacity(0.25),
    ),
    fontFamily: 'NanumSquare',
  );
}
