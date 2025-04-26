// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/src/theme_changer.dart';
import 'package:flutter_theme_changer_erfan/src/theme_controller.dart';

void main() {
  testWidgets('Theme Changer basic widget rendering test', (WidgetTester tester) async {
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

  testWidgets('Theme Changer updates theme color', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: Builder(
          builder: (context) {
            return ThemeChanger(
              title: 'Test App',
              child: Consumer(
                builder: (context, ref, _) {
                  final theme = ref.watch(themeProvider);
                  return Scaffold(
                    appBar: AppBar(),
                    body: ColoredBox(
                      color: theme.colorScheme.primary,
                      child: const SizedBox(width: 100, height: 100),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Get the initial color scheme
    final initialColor = tester.widget<ColoredBox>(find.byType(ColoredBox)).color;
    
    // Update the theme color using the provider
    await tester.runAsync(() async {
      final container = ProviderScope.containerOf(
        tester.element(find.byType(ThemeChanger)),
      );
      container.read(themeProvider.notifier).updateTheme(Colors.red);
    });

    await tester.pumpAndSettle();

    // Verify the color has changed
    final updatedColor = tester.widget<ColoredBox>(find.byType(ColoredBox)).color;
    expect(updatedColor, isNot(equals(initialColor)));
    
    // Verify the new color is in the red spectrum
    expect(updatedColor.r > updatedColor.b, isTrue);
    expect(updatedColor.r > updatedColor.g, isTrue);
  });

  test('ThemeNotifier creates correct initial theme', () {
    final notifier = ThemeNotifier();
    expect(notifier.state, isA<ThemeData>());
    // Verify the theme is using Material 3
    expect(notifier.state.useMaterial3, isTrue);
    // Verify initial color scheme is based on blue
    final colorScheme = notifier.state.colorScheme;
    expect(colorScheme.primary.b > colorScheme.primary.r, isTrue);
  });

  test('ThemeNotifier updates theme correctly', () {
    final notifier = ThemeNotifier();
    notifier.updateTheme(Colors.red);
    final colorScheme = notifier.state.colorScheme;
    // Verify the new color scheme is based on red
    expect(colorScheme.primary.r > colorScheme.primary.b, isTrue);
    expect(colorScheme.primary.r > colorScheme.primary.g, isTrue);
  });
}
