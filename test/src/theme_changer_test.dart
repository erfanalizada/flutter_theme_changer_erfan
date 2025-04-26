import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/src/theme_changer.dart';
import 'package:flutter_theme_changer_erfan/src/theme_controller.dart';

void main() {
  group('ThemeChanger Widget', () {
    testWidgets('renders correctly with default theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ThemeChanger(
            title: 'Test App',
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Test Header'),
              ),
              body: const Center(
                child: Text('Test Content'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Header'), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('updates theme when color changes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: ThemeChanger(
            title: 'Test App',
            child: Consumer(
              builder: (context, ref, _) {
                final theme = ref.watch(themeProvider);
                return Scaffold(
                  body: ColoredBox(
                    color: theme.colorScheme.primary,
                    child: const SizedBox(width: 100, height: 100),
                  ),
                );
              },
            ),
          ),
        ),
      );

      final initialColor = tester.widget<ColoredBox>(find.byType(ColoredBox)).color;
      
      await tester.runAsync(() async {
        final container = ProviderScope.containerOf(
          tester.element(find.byType(ThemeChanger)),
        );
        container.read(themeProvider.notifier).updateTheme(Colors.red);
      });

      await tester.pumpAndSettle();

      final updatedColor = tester.widget<ColoredBox>(find.byType(ColoredBox)).color;
      expect(updatedColor, isNot(equals(initialColor)));
      expect(updatedColor.red > updatedColor.blue, isTrue);
    });
  });
}