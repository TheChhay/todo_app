import 'package:flutter/material.dart';
import 'package:todo_app/configs/app_colors.dart';

class CustomTheme {
  CustomTheme._(); // Private constructor to prevent instantiation

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.blue10,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.blue60,
      foregroundColor: AppColor.blue10,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColor.blue50,
      brightness: Brightness.light,
      surface: AppColor.blue40,
      error: AppColor.red40,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColor.blue100),
      bodyMedium: TextStyle(color: AppColor.blue100),
      titleLarge: TextStyle(color: AppColor.blue100),
      labelLarge: TextStyle(color: AppColor.blue100),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColor.blue40, // text highlight color
      selectionHandleColor: AppColor.blue40, // draggable handles
      cursorColor: AppColor.blue50, // cursor color
    ),

  );

  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColor.darkBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.blue10,
      foregroundColor: AppColor.blue90,
      elevation: 0,
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColor.blue10,
      brightness: Brightness.dark,
      surface: AppColor.blue10,
      error: AppColor.red40,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColor.blue10),
      bodyMedium: TextStyle(color: AppColor.blue10),
      titleLarge: TextStyle(color: AppColor.blue10),
      labelLarge: TextStyle(color: AppColor.blue10),
    ),
  );
}
