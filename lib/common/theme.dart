import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get_storage/get_storage.dart';

import 'color_pallete.dart';

ThemeMode getThemeMode() {
  String? _themeMode = GetStorage().read<String>('theme_mode');
  switch (_themeMode) {
    case 'ThemeMode.light':
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: Colors.white),
      );
      return ThemeMode.light;
    case 'ThemeMode.dark':
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark
            .copyWith(systemNavigationBarColor: Colors.black87),
      );
      return ThemeMode.dark;
    case 'ThemeMode.system':
      return ThemeMode.system;
    default:
      // if (setting.value.defaultTheme == "dark") {
      //   SystemChrome.setSystemUIOverlayStyle(
      //     SystemUiOverlayStyle.dark.copyWith(systemNavigationBarColor: Colors.black87),
      //   );
      //   return ThemeMode.dark;
      // } else {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light
            .copyWith(systemNavigationBarColor: Colors.white),
      );
      return ThemeMode.light;
    // }
  }
}

ThemeData getThemeData() {
  // var primary = Ui.parseColor("#FFDE30");
  var primary = ColorPallete.primary;
  var secondary = ColorPallete.secondary;
  var accent = ColorPallete.accent;
  return ThemeData(
    fontFamily: GoogleFonts.montserrat().fontFamily,
    primaryColor: secondary,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 0, foregroundColor: Colors.white),
    brightness: Brightness.light,
    dividerColor: primary.withOpacity(0.1),
    focusColor: accent,
    hintColor: accent,
    scaffoldBackgroundColor: primary,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: secondary),
    ),
    cardColor: secondary,
    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w700,
          color: primary,
          height: 1.2),
      headlineSmall: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
          color: secondary,
          height: 1.2),
      headlineMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w400,
          color: primary,
          height: 1.3),
      displaySmall: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          color: secondary,
          height: 1.3),
      displayMedium: TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w300,
          color: primary,
          height: 1.4),
      displayLarge: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w700,
          color: secondary,
          height: 1.4),
      // subtitle2: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600, color: Ui.parseColor(setting.value.secondColor), height: 1.2),
      // subtitle1: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w400, color: Ui.parseColor(setting.value.mainColor), height: 1.2),
      bodyMedium: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          color: primary,
          height: 1.4),
      bodyLarge: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
          color: primary,
          height: 1.2),
      bodySmall: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
          color: primary,
          height: 1.4),
    ),
  );
}
