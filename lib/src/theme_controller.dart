import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

ThemeData _generateThemeData(Color primaryColor) {
  // Move the theme generation logic here
  final colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    primary: primaryColor,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor:
          primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    ),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_defaultTheme) {
    // Load saved theme asynchronously without blocking
    _loadSavedThemeAsync();
  }

  static final _defaultTheme = (() {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
    );
  })();

  Future<void> updateThemeOffMainThread(Color primaryColor) async {
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
    final newTheme = await compute(_generateThemeData, primaryColor);
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

  Future<void> loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final colorString = prefs.getString('theme_color');
    if (colorString != null && colorString.startsWith('#')) {
      try {
        final colorValue = int.parse(colorString.substring(1), radix: 16);
        final color = Color(colorValue);
        updateThemeOffMainThread(color);
      } catch (e) {
        // If parsing fails, keep the default theme
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
    // For better performance, use the off-main-thread version
    updateThemeOffMainThread(primaryColor);

    // But also update the UI immediately for responsiveness
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
    );

    state = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
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
  return ThemeNotifier();
});
