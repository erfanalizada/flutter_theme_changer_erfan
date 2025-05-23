import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

ThemeData _generateThemeData(Color primaryColor,
    {Color? scaffoldColor, bool isDarkMode = false}) {
  // Create color scheme based on brightness
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldColor,
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor:
          primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  Color _defaultColor = Colors.blue; // Default fallback, will be overridden
  Color? _scaffoldColor;
  bool _hasUserSelectedColor = false; // Track if user has selected a color
  bool _isDarkMode = false; // Track dark mode state

  ThemeNotifier() : super(_generateThemeData(Colors.blue)) {
    // Load saved theme asynchronously without blocking
    _loadSavedThemeAsync();
  }

  // Method to set the default color from ThemeChanger
  void setDefaultColor(Color color, {Color? scaffoldColor}) {
    _defaultColor = color;
    _scaffoldColor = scaffoldColor;

    // Only update the theme if user hasn't selected a color and we haven't loaded a saved theme
    if (!_hasUserSelectedColor && state.colorScheme.primary == Colors.blue) {
      state = _generateThemeData(color,
          scaffoldColor: scaffoldColor, isDarkMode: _isDarkMode);
    }
  }

  // Toggle between light and dark mode
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    await _saveDarkModePreference(_isDarkMode);

    // Update theme with current color but new brightness
    updateThemeOffMainThread(state.colorScheme.primary);
  }

  // Get current dark mode state
  bool get isDarkMode => _isDarkMode;

  Future<void> updateThemeOffMainThread(Color primaryColor) async {
    // Mark that user has selected a color
    _hasUserSelectedColor = true;

    developer.log('Starting theme update', name: 'performance');
    final startTime = DateTime.now();

    // Save preference
    await _saveThemePreference(primaryColor);
    developer.log(
        'Saved theme preference in ${DateTime.now().difference(startTime).inMilliseconds}ms',
        name: 'performance');

    // Generate theme in a separate isolate
    developer.log('Starting theme generation in isolate', name: 'performance');
    final isolateStart = DateTime.now();
    final newTheme = await compute(
        (params) => _generateThemeData(params['color'] as Color,
            scaffoldColor: params['scaffoldColor'] as Color?,
            isDarkMode: params['isDarkMode'] as bool),
        {
          'color': primaryColor,
          'scaffoldColor': _scaffoldColor,
          'isDarkMode': _isDarkMode
        });
    developer.log(
        'Theme generation completed in ${DateTime.now().difference(isolateStart).inMilliseconds}ms',
        name: 'performance');

    // Update state with the new theme
    state = newTheme;
    developer.log(
        'Total theme update completed in ${DateTime.now().difference(startTime).inMilliseconds}ms',
        name: 'performance');
  }

  // Add a cache for SharedPreferences
  SharedPreferences? _prefsCache;

  Future<SharedPreferences> _getPrefs() async {
    _prefsCache ??= await SharedPreferences.getInstance();
    return _prefsCache!;
  }

  Future<void> _saveThemePreference(Color color) async {
    final prefs = await _getPrefs();
    final argb = color.toARGB32();
    final colorString = '#${argb.toRadixString(16).padLeft(8, '0')}';
    await prefs.setString('theme_color', colorString);
  }

  Future<void> _saveDarkModePreference(bool isDarkMode) async {
    final prefs = await _getPrefs();
    await prefs.setBool('is_dark_mode', isDarkMode);
  }

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();

    // Load dark mode preference
    _isDarkMode = prefs.getBool('is_dark_mode') ?? false;

    final colorString = prefs.getString('theme_color');
    if (colorString != null && colorString.startsWith('#')) {
      try {
        final colorValue = int.parse(colorString.substring(1), radix: 16);
        final color = Color(colorValue);
        _hasUserSelectedColor =
            true; // Mark that we have a saved user selection
        updateThemeOffMainThread(color);
      } catch (e) {
        // If parsing fails, keep the default theme
        updateThemeOffMainThread(_defaultColor);
      }
    } else {
      // No saved theme, use the default color
      if (!_hasUserSelectedColor) {
        updateThemeOffMainThread(_defaultColor);
      }
    }
  }

  // Make this a separate method that doesn't block initialization
  Future<void> _loadSavedThemeAsync() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadSavedTheme();
    });
  }

  // Add this method back for compatibility
  void updateTheme(Color primaryColor) {
    // Mark that user has selected a color
    _hasUserSelectedColor = true;

    // For better performance, use the off-main-thread version
    updateThemeOffMainThread(primaryColor);

    // But also update the UI immediately for responsiveness
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
    );

    state = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: _scaffoldColor,
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor:
            primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      ),
    );
  }

  // Helper method for contrast color
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  // This will be initialized with the default color from ThemeChanger
  // The actual color will be set when ThemeChanger is created
  return ThemeNotifier();
});

// Remove the family provider since we'll initialize the main provider with the default color
