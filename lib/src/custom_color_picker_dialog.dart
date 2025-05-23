import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';
import 'theme_mode_toggle.dart';

/// A dialog that displays color options for theme selection.
///
/// This widget can be shown from any custom button or widget using the static
/// [showColorPickerDialog] method.
class CustomColorPickerDialog {
  /// Shows a color picker dialog that allows users to select a theme color.
  ///
  /// Example usage:
  /// ```dart
  /// ElevatedButton(
  ///   onPressed: () => CustomColorPickerDialog.showColorPickerDialog(context),
  ///   child: Text('Change Theme'),
  /// )
  /// ```
  static Future<void> showColorPickerDialog(
    BuildContext context, {
    List<Color> availableColors = const [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.amber,
    ],
    bool showDarkModeToggle = true,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Theme',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (showDarkModeToggle) ...[
                const SizedBox(height: 16),
                const ThemeModeToggle(),
                const SizedBox(height: 16),
                const Divider(),
              ],
              const SizedBox(height: 20),
              Consumer(
                builder: (context, ref, _) {
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: availableColors.map((color) {
                      return InkWell(
                        onTap: () {
                          ref.read(themeProvider.notifier).updateTheme(color);
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
