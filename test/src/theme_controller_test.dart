import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_theme_changer_erfan/src/theme_controller.dart';

void main() {
  group('ThemeNotifier', () {
    late ThemeNotifier themeNotifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      themeNotifier = ThemeNotifier();
    });

    test('initial state should have default blue theme', () {
      final colorScheme = themeNotifier.state.colorScheme;
      expect(colorScheme.primary.b > colorScheme.primary.r, isTrue);
      expect(colorScheme.primary.b > colorScheme.primary.g, isTrue);
    });

    test('updateTheme should change theme color', () {
      themeNotifier.updateTheme(Colors.red);
      final colorScheme = themeNotifier.state.colorScheme;
      expect(colorScheme.primary.r > colorScheme.primary.b, isTrue);
      expect(colorScheme.primary.r > colorScheme.primary.g, isTrue);
    });

    test('theme should be saved when updated', () async {
      themeNotifier.updateTheme(Colors.red);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_color'), isNotNull);
    });

    test('should load saved theme from preferences', () async {
      // Set up mock preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_color', '#FFFF0000'); // Red color

      await themeNotifier.loadSavedTheme();
      final colorScheme = themeNotifier.state.colorScheme;
      expect(colorScheme.primary.r > colorScheme.primary.b, isTrue);
      expect(colorScheme.primary.r > colorScheme.primary.g, isTrue);
    });
  });
}
