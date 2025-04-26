import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_createTheme(Colors.blue));

  static ThemeData _createTheme(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    final contrastColor = brightness == Brightness.light ? Colors.black : Colors.white;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: contrastColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(foregroundColor: color),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: color),
      ),

      inputDecorationTheme: _createInputDecorationTheme(color),
      dropdownMenuTheme: _createDropdownMenuTheme(color),

      appBarTheme: AppBarTheme(
        backgroundColor: color,
        foregroundColor: contrastColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: color,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }

  static InputDecorationTheme _createInputDecorationTheme(Color color) {
    return InputDecorationTheme(
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      iconColor: color,
      focusColor: color,
    );
  }

  static DropdownMenuThemeData _createDropdownMenuTheme(Color color) {
    return DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      menuStyle: MenuStyle(
        backgroundColor: const MaterialStatePropertyAll(Colors.white),
        surfaceTintColor: MaterialStatePropertyAll(color),
      ),
    );
  }

  void updateTheme(Color color) => state = _createTheme(color);
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
