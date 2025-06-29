import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
  ),
  useMaterial3: true,
);

final ThemeData navyDarkTheme = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF0A1128), // deep navy blue
  scaffoldBackgroundColor: const Color(0xFF0A1128),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0D1B2A),
    foregroundColor: Colors.white,
    elevation: 4,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF001F54),
    secondary: Color(0xFF133C55),
    surface: Color(0xFF1C2541),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF133C55),
    foregroundColor: Colors.white,
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.white,
    displayColor: Colors.white70,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.white, // icon + text color
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      textStyle: const TextStyle(fontSize: 12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // backgroundColor: Colors.green.shade700,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
);