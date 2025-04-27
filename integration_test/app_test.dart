import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_theme_changer_erfan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Verify theme change flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Tap the main expand button (first InkWell)
      final mainButton = find.byType(InkWell).first;
      await tester.tap(mainButton);
      await tester.pumpAndSettle();

      // Find all InkWell buttons (main + color buttons)
      final allInkWells = find.byType(InkWell);
      expect(allInkWells, findsWidgets);

      // Find the AppBar widget
      final appBarContext = tester.element(find.byType(AppBar));

      // Save the initial primary color from AppBar context
      final initialPrimaryColor = Theme.of(appBarContext).colorScheme.primary;

      // Tap the first color button (after the main button)
      final firstColorButton = allInkWells.at(1);
      await tester.tap(firstColorButton);
      await tester.pumpAndSettle();

      // Re-fetch AppBar context (in case it rebuilt)
      final updatedAppBarContext = tester.element(find.byType(AppBar));

      // Save the updated primary color
      final updatedPrimaryColor =
          Theme.of(updatedAppBarContext).colorScheme.primary;

      // Verify that the theme color actually changed
      expect(updatedPrimaryColor, isNot(equals(initialPrimaryColor)));
    });
  });
}
