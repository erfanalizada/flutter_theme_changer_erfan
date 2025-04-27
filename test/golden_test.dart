import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_theme_changer_erfan/src/theme_color_picker_widget.dart';

void main() {
  setUp(() {
    // Set up shared_preferences mock
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Golden test - red theme', (WidgetTester tester) async {
    // Set up the screen size and pixel ratio for consistent screenshots
    await tester.binding.setSurfaceSize(const Size(400, 800));
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: ThemeColorPickerWidget(),
            ),
          ),
        ),
      ),
    );

    // Wait for any animations to complete
    await tester.pumpAndSettle();

    // Verify against golden file
    await expectLater(
      find.byType(ThemeColorPickerWidget),
      matchesGoldenFile('goldens/theme_picker_red.png'),
    );
  });
}
