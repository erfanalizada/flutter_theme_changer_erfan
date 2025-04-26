import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(ThemeData.light());

  void updateTheme(Color color) {
    state = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      // Make AppBar use the primary color
      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: ThemeData.estimateBrightnessForColor(color) == Brightness.light 
            ? Colors.black 
            : Colors.white,
      ),
      // Make the navigation bar more visible
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: color,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
