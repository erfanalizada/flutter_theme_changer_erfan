import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/widgets/theme_color_picker.dart';
import 'package:flutter_theme_changer_erfan/widgets/theme_controller.dart'; // make sure you have this

class ThemeColorPickerWidget extends ConsumerWidget {
  const ThemeColorPickerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ThemeColorPicker(
      availableColors: [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.pink,
      ],
      onColorSelected: (color) {
        ref.read(themeProvider.notifier).updateTheme(color);
      },
    );
  }
}
