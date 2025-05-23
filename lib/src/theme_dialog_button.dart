import 'package:flutter/material.dart';
import 'theme_color_picker_widget.dart';
import 'theme_mode_toggle.dart';

/// A button that shows a theme picker in a dialog when pressed.
class ThemeDialogButton extends StatelessWidget {
  const ThemeDialogButton({
    super.key,
    this.availableColors = const [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ],
    this.gradientColors = const [],
    this.icon = const Icon(Icons.palette),
    this.showDarkModeToggle = true,
  });

  /// The list of colors to display in the color picker dialog
  final List<Color> availableColors;

  /// The list of gradient color sets, each containing 2-4 colors
  final List<List<Color>> gradientColors;

  /// The icon to display in the button
  final Widget icon;

  /// Whether to show the dark mode toggle in the dialog
  final bool showDarkModeToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showDarkModeToggle) ...[
                    const ThemeModeToggle(),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],
                  ThemeColorPickerWidget(
                    availableColors: availableColors,
                    gradientColors: gradientColors,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
