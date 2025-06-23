import 'package:flutter/material.dart';
import 'package:todo_app/configs/app_colors.dart';

class CustomTheme {
  CustomTheme._(); // Private constructor to prevent instantiation

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColor.blue10,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.blue60,
      foregroundColor: AppColor.blue10,
      elevation: 0,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColor.blue60,
      brightness: Brightness.light,
      surface: AppColor.blue60,
      error: AppColor.red40,
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
  );
}
