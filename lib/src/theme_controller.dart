import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_createTheme(Colors.blue)) {
    // Load saved theme when initialized
    loadSavedTheme();
  }

  static const String _themeColorKey = 'theme_color';

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
        unselectedItemColor: Colors.white.withValues(alpha: 0.6),
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
        backgroundColor: const WidgetStatePropertyAll(Colors.white),
        surfaceTintColor: WidgetStatePropertyAll(color),
      ),
    );
  }

  Future<void> saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = '#${state.colorScheme.primary.toARGB32().toRadixString(16).padLeft(8, '0')}';
    await prefs.setString(_themeColorKey, colorValue);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString(_themeColorKey);
    if (colorString != null) {
      try {
        final colorValue = int.parse(colorString.substring(1), radix: 16);
        final color = Color(colorValue);
        state = _createTheme(color);
      } catch (e) {
        // If there's an error parsing the color, keep the default theme
      }
    }
  }

  void updateTheme(Color color) {
    state = _createTheme(color);
    saveThemePreference(); // Save the theme whenever it's updated
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
