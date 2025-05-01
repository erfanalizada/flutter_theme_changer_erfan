import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_createTheme(Colors.blue)) {
    // Load saved theme when initialized
    loadSavedTheme();
  }

  // Keep track of the actual selected color
  Color _selectedColor = Colors.blue;
  
  static const String _themeColorKey = 'theme_color';
  static const String _themeBrightnessKey = 'theme_brightness';

  static ThemeData _createTheme(Color color, [Brightness? forcedBrightness]) {
    final brightness = forcedBrightness ?? ThemeData.estimateBrightnessForColor(color);
    final contrastColor =
        brightness == Brightness.light ? Colors.black : Colors.white;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color,
        brightness: brightness,
        // Explicitly set primary to the exact color to prevent Material's color algorithm from changing it
        primary: color,
      ),
      primaryColor: color, // Set primary color directly
      useMaterial3: true,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: color, // Use exact color
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
      focusedErrorBorder:
          OutlineInputBorder(borderSide: BorderSide(color: color)),
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
    // Store the EXACT selected color, not the one from the theme
    await prefs.setInt(_themeColorKey, _selectedColor.value);
    // Store the brightness value
    await prefs.setBool(_themeBrightnessKey, 
        state.colorScheme.brightness == Brightness.dark);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt(_themeColorKey);
    final isDark = prefs.getBool(_themeBrightnessKey);
    
    if (colorValue != null) {
      try {
        final color = Color(colorValue);
        print('Loading color: 0x${color.value.toRadixString(16)}'); // Debug print
        _selectedColor = color;
        
        // If brightness was saved, use it; otherwise calculate from color
        final brightness = isDark != null 
            ? (isDark ? Brightness.dark : Brightness.light)
            : ThemeData.estimateBrightnessForColor(color);
        
        state = _createTheme(color, brightness);
      } catch (e) {
        // If there's an error parsing the color, keep the default theme
      }
    }
  }

  void updateTheme(Color color) {
    print('Saving color: 0x${color.value.toRadixString(16)}'); // Debug print
    _selectedColor = color;
    state = _createTheme(color);
    saveThemePreference();
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
