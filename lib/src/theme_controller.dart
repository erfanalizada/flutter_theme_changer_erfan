import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_defaultTheme) {
    // Load saved theme when ThemeNotifier is created
    loadSavedTheme();
  }

  static final _defaultTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    useMaterial3: true,
  );

  bool _isFirstUpdate = true;

  Future<void> updateTheme(Color primaryColor) async {
    await _saveThemePreference(primaryColor);
    _isFirstUpdate = false;
    
    // Create a color scheme that better preserves the original color
    final colorScheme = ColorScheme(
      // Use the actual primaryColor directly instead of a generated one
      primary: primaryColor,
      // Generate other colors from the seed to maintain harmony
      secondary: ColorScheme.fromSeed(seedColor: primaryColor).secondary,
      tertiary: ColorScheme.fromSeed(seedColor: primaryColor).tertiary,
      
      // Surface and background colors
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      
      // On-colors (text/icon colors that appear on top of the main colors)
      onPrimary: _getContrastColor(primaryColor),
      onSecondary: ColorScheme.fromSeed(seedColor: primaryColor).onSecondary,
      onTertiary: ColorScheme.fromSeed(seedColor: primaryColor).onTertiary,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      
      // Brightness
      brightness: Brightness.light,
      
      // Container colors
      primaryContainer: primaryColor.withOpacity(0.8),
      secondaryContainer: ColorScheme.fromSeed(seedColor: primaryColor).secondaryContainer,
      tertiaryContainer: ColorScheme.fromSeed(seedColor: primaryColor).tertiaryContainer,
      errorContainer: Colors.red.shade200,
      
      // On-container colors
      onPrimaryContainer: _getContrastColor(primaryColor.withOpacity(0.8)),
      onSecondaryContainer: ColorScheme.fromSeed(seedColor: primaryColor).onSecondaryContainer,
      onTertiaryContainer: ColorScheme.fromSeed(seedColor: primaryColor).onTertiaryContainer,
      onErrorContainer: Colors.white,
      
      // Surface tint color
      surfaceTint: primaryColor.withOpacity(0.1),
      
      // Outline color
      outline: Colors.grey.shade400,
      outlineVariant: Colors.grey.shade300,
      
      // Shadow color
      shadow: Colors.black.withOpacity(0.1),
      
      // Scrim color
      scrim: Colors.black.withOpacity(0.3),
      
      // Inverse colors
      inversePrimary: _getContrastColor(primaryColor),
      inverseSurface: Colors.grey.shade900,
      onInverseSurface: Colors.white,
    );
    
    state = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      
      // AppBar theme - using primary color directly
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: _getContrastColor(primaryColor),
      ),
      
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: _getContrastColor(primaryColor),
        ),
      ),
      
      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: _getContrastColor(primaryColor),
      ),
      
      // BottomNavigationBar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: primaryColor,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow,
      ),
    );
  }

  // Helper method to determine a contrasting color (black or white) based on the background color
  Color _getContrastColor(Color backgroundColor) {
    // Calculate the relative luminance of the color
    // Using the formula: 0.299*R + 0.587*G + 0.114*B
    final double luminance = (0.299 * backgroundColor.red + 
                             0.587 * backgroundColor.green + 
                             0.114 * backgroundColor.blue) / 255;
    
    // Use white text on dark backgrounds, black text on light backgrounds
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  Future<void> _saveThemePreference(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    // Save color as a hex string
    await prefs.setString('theme_color', '#${color.value.toRadixString(16).padLeft(8, '0')}');
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('theme_color');
    if (colorString != null && colorString.startsWith('#')) {
      try {
        final colorValue = int.parse(colorString.substring(1), radix: 16);
        final color = Color(colorValue);
        updateTheme(color);
      } catch (e) {
        // If parsing fails, keep the default theme
      }
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});
