import 'package:flutter/material.dart';

import 'color_schemes.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    // brightness: Brightness.light,
    colorSchemeSeed: Color.fromARGB(255, 253, 93, 0),
    // colorScheme: lightColorScheme,
    iconTheme: IconThemeData(color: lightColorScheme.onPrimaryContainer));
ThemeData darkthemes = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Color.fromARGB(255, 253, 93, 0),
    brightness: Brightness.dark,
    // colorScheme: darkColorScheme,
    iconTheme: IconThemeData(color: darkColorScheme.onPrimaryContainer));