import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_theme_changer_erfan/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('Verify theme change flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap the theme picker button
      final themePickerButton = find.byTooltip('Pick theme color');
      await tester.tap(themePickerButton);
      await tester.pumpAndSettle();

      // Verify color picker is shown
      expect(find.byType(ColorPicker), findsOneWidget);

      // Select a new color
      final redColorButton = find.byKey(const Key('red_color_button'));
      await tester.tap(redColorButton);
      await tester.pumpAndSettle();

      // Verify theme has changed
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor.red > scaffold.backgroundColor.blue, isTrue);
    });
  });
}