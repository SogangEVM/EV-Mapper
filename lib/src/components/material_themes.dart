import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;

ThemeData materialThemes() {
  return ThemeData(
    brightness: Brightness.light,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: evmColor.backgroundColor,
      backgroundColor: Colors.white,
      splashColor: Colors.black.withOpacity(0.25),
    ),
    fontFamily: 'NanumSquare',
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: evmColor.foregroundColor,
      selectedIconTheme: IconThemeData(
        size: 24.0,
      ),
      unselectedIconTheme: IconThemeData(
        size: 20.0,
      ),
    ),
  );
}

ThemeData materialDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: evmColor.backgroundColor,
      backgroundColor: Colors.white,
      splashColor: Colors.black.withOpacity(0.25),
    ),
  );
}
