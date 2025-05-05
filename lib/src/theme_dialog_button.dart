import 'package:flutter/material.dart';
import 'theme_color_picker_widget.dart';

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
  });

  /// The list of colors to display in the color picker dialog
  final List<Color> availableColors;

  /// The list of gradient color sets, each containing 2-4 colors
  final List<List<Color>> gradientColors;

  /// The icon to display in the button
  final Widget icon;

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
              child: ThemeColorPickerWidget(
                availableColors: availableColors,
                gradientColors: gradientColors,
              ),
            ),
          ),
        );
      },
    );
  }
}
