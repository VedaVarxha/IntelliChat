import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData.light().copyWith(
    colorScheme: const ColorScheme.light().copyWith(
      primary: const Color(0xFFF6F5F2),
      secondary: const Color(0xFFF6F5F2),
      surface: const Color(0xFF03AED2),
      background: Colors.white,
      onBackground: const Color(0xFF03AED2),
    ),
    scaffoldBackgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Color(0xFF3A98B9)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Color(0xFF3A98B9)),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Color(0xFF3A98B9)),
      titleMedium: TextStyle(color: Color(0xFF3A98B9)),
      titleSmall: TextStyle(color: Color(0xFF3A98B9)),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 13, 13, 13)),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 15, 15, 15)),
      bodySmall: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
    ),
  );
}

ThemeData darkTheme() {
  return ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark().copyWith(
      primary: const Color(0xFF222831),
      secondary: const Color(0xFF76ABAE),
      surface: Colors.black87,
      background: Colors.black87,
      onBackground: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    iconTheme: const IconThemeData(color: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.white),
    ),
  );
}
