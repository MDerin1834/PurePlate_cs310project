import 'package:flutter/material.dart';

final purePlateTheme = ThemeData(
  primaryColor: const Color(0xFF2D6A4F),
  scaffoldBackgroundColor: const Color(0xFFF7F9F7),
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF2D6A4F),
    secondary: const Color(0xFFD8F3DC),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
    ),
    prefixIconColor: const Color(0xFF2D6A4F),
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(color: Colors.grey[600]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2D6A4F),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFF2D6A4F),
      side: const BorderSide(color: Color(0xFF2D6A4F), width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
  ),
);
