// ignore_for_file: file_names

import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  late ThemeData themeData;
  AppTheme(context) {
    themeData = getCurrentTheme(context);
  }
  largeTextSize(context) {
    return MediaQuery.of(context).size.height / 30;
  }

  mediumTextSize(context) {
    return MediaQuery.of(context).size.height / 60;
  }

  smallTextSize(context) {
    return MediaQuery.of(context).size.height / 70;
  }

  static getTextStyle(height, color, fontSize, fontWeight, spacing, decoration,
      [shadows]) {
    return TextStyle(
        height: height,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: spacing,
        decoration: decoration,
        shadows: shadows);
  }

  nonStaticGetTextStyle(
      height, color, fontSize, fontWeight, spacing, decoration,
      [shadows]) {
    return getTextStyle(
        height, color, fontSize, fontWeight, spacing, decoration, shadows);
  }

  ThemeData getCurrentTheme(context) {
    return getLightTheme(context);
  }

  ThemeData getLightTheme(context) {
    return ThemeData(
        primaryColor: const Color.fromRGBO(246, 246, 252, 1.0),
        canvasColor: const Color.fromRGBO(240, 227, 202, 1.0),
        shadowColor: Colors.black.withOpacity(0.5),
        highlightColor: Colors.grey.shade50,
        primaryTextTheme: TextTheme(
          displayLarge: getTextStyle(
            1.0,
            Colors.amber[300],
            largeTextSize(context) * 2,
            FontWeight.bold,
            1.0,
            TextDecoration.none,
          ),
          displayMedium: getTextStyle(
            1.0,
            Colors.amber[300],
            largeTextSize(context) * 1.5,
            FontWeight.w600,
            1.0,
            TextDecoration.none,
          ),
          displaySmall: getTextStyle(
            1.0,
            Colors.amber[300],
            largeTextSize(context),
            FontWeight.bold,
            1.0,
            TextDecoration.none,
          ),
          headlineMedium: getTextStyle(
            1.0,
            const Color.fromRGBO(38, 92, 126, 1.0),
            mediumTextSize(context),
            FontWeight.w400,
            1.0,
            TextDecoration.none,
          ),
          headlineSmall: getTextStyle(
              1.0,
              Colors.black,
              mediumTextSize(context),
              FontWeight.normal,
              1.0,
              TextDecoration.none),
          bodyLarge: getTextStyle(
              1.0,
              Colors.amber[300],
              mediumTextSize(context),
              FontWeight.normal,
              1.0,
              TextDecoration.none),
          bodyMedium: getTextStyle(1.0, Colors.white, mediumTextSize(context),
              FontWeight.normal, 1.0, TextDecoration.none),
          titleMedium: getTextStyle(1.0, Colors.grey, smallTextSize(context),
              FontWeight.w300, 1.0, TextDecoration.none),
          titleSmall: getTextStyle(
            1.0,
            Colors.grey.withOpacity(0.5),
            smallTextSize(context),
            FontWeight.w300,
            1.0,
            TextDecoration.none,
          ),
        ),
        appBarTheme: AppBarTheme(
            elevation: 0.0,
            backgroundColor: const Color.fromRGBO(247, 148, 29, 1.0),
            titleTextStyle: getTextStyle(
              1.0,
              const Color.fromRGBO(255, 255, 255, 1.0),
              20.0,
              FontWeight.normal,
              1.0,
              TextDecoration.none,
            ),
            iconTheme: IconThemeData(color: Colors.amber[300])),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        cardColor: Colors.white,
        toggleButtonsTheme: ToggleButtonsThemeData(
            disabledColor: Colors.grey[400], selectedColor: Colors.amber),
        dropdownMenuTheme: DropdownMenuThemeData(
            menuStyle: MenuStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.grey.shade50)))
        // buttonColor: Colors.white
        );
  }
}
