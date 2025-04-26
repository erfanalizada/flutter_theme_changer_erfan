import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_theme_changer_erfan/src/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Persistence Tests', () {
    late ThemeNotifier themeNotifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      themeNotifier = ThemeNotifier();
    });

    test('Theme should be saved when updated', () async {
      await themeNotifier.saveThemePreference();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('theme_color'), isNotNull);
    });

    test('Theme should be loaded from preferences', () async {
      // Set up mock preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_color', '#FF0000'); // Red color

      await themeNotifier.loadSavedTheme();
      expect(themeNotifier.state.colorScheme.primary.r > 
             themeNotifier.state.colorScheme.primary.b, isTrue);
    });
  });
}