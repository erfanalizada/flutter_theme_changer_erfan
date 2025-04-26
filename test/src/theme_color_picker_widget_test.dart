import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/src/theme_color_picker_widget.dart';

void main() {
  group('ThemeColorPickerWidget', () {
    testWidgets('renders initial state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeColorPickerWidget(),
            ),
          ),
        ),
      );

      // Initially, only the main button should be visible
      expect(find.byType(InkWell), findsOneWidget);
      expect(find.byType(Card), findsNothing); // Color picker should be hidden initially
    });

    testWidgets('shows color options when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeColorPickerWidget(),
            ),
          ),
        ),
      );

      // Tap the main button
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Color picker should now be visible
      expect(find.byType(Card), findsOneWidget);
      // Main button + 6 color options
      expect(find.byType(InkWell), findsNWidgets(7));
    });

    testWidgets('changes theme on color selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeColorPickerWidget(
                availableColors: [Colors.red, Colors.blue],
              ),
            ),
          ),
        ),
      );

      // Open the color picker
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Find and tap the first color option (excluding the main button)
      final colorButtons = find.byType(InkWell);
      await tester.tap(colorButtons.at(1)); // Skip the main button
      await tester.pumpAndSettle();

      // Verify the picker closes after selection
      expect(find.byType(Card), findsNothing);
    });

    testWidgets('accepts custom colors', (WidgetTester tester) async {
      final customColors = [Colors.purple, Colors.orange, Colors.teal];
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: ThemeColorPickerWidget(
                availableColors: customColors,
              ),
            ),
          ),
        ),
      );

      // Open the color picker
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      // Should find exactly customColors.length + 1 (main button) InkWell widgets
      expect(find.byType(InkWell), findsNWidgets(customColors.length + 1));
    });
  });
}

