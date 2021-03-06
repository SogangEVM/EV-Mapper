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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
            (states) => evmColor.foregroundColor),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => Colors.black,
        ),
      ),
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
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: evmColor.backgroundColor,
      modalBackgroundColor: evmColor.backgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: evmColor.backgroundColor,
      backgroundColor: Colors.white,
      splashColor: Colors.black.withOpacity(0.25),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
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
