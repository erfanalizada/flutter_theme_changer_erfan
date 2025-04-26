import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/src/theme_color_picker_widget.dart';
import 'dart:math';

void main() {
  testWidgets('Theme picker performance test - expansion animation', (WidgetTester tester) async {
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

    final stopwatch = Stopwatch()..start();
    
    // Measure expansion animation
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    
    stopwatch.stop();
    
    expect(stopwatch.elapsedMilliseconds, lessThan(300));
  });

  testWidgets('Theme picker performance test - rapid theme changes', (WidgetTester tester) async {
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

    await tester.pumpAndSettle();

    final mainButton = find.byType(InkWell).first;
    expect(mainButton, findsOneWidget, reason: 'Main button not found');

    // Expand color picker first
    await tester.tap(mainButton);
    await tester.pumpAndSettle();

    // Find all InkWell widgets
    final allInkWells = find.byType(InkWell);
    final colorOptions = allInkWells.evaluate().toList();
    final colorCount = colorOptions.length - 1; // minus main button

    expect(colorCount, greaterThan(0), reason: 'Expected color options, found none');

    final stopwatch = Stopwatch()..start();

    for (int i = 1; i <= min(3, colorCount); i++) {
      // Find the color button
      final currentColorButton = find.byType(InkWell).at(i);

      await tester.tap(currentColorButton);
      await tester.pumpAndSettle();

      // After tapping, picker is collapsed -> need to reopen
      await tester.tap(mainButton);
      await tester.pumpAndSettle();
    }

    stopwatch.stop();

    final averageTime = stopwatch.elapsedMilliseconds / min(3, colorCount);
    expect(averageTime, lessThan(100),
      reason: 'Average color change time ($averageTime ms) exceeded limit');
  });

  testWidgets('Theme picker performance test - memory usage', (WidgetTester tester) async {
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

    final initialWidgetCount = tester.allElements.length;

    for (int i = 0; i < 5; i++) {
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();
    }

    final finalWidgetCount = tester.allElements.length;
    expect(finalWidgetCount, lessThanOrEqualTo(initialWidgetCount * 1.1));
  });
}
