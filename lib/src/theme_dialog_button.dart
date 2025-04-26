import 'package:flutter/material.dart';
import 'theme_color_picker_widget.dart';

/// A button that shows a theme picker in a dialog when pressed.
class ThemeDialogButton extends StatelessWidget {
  const ThemeDialogButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.palette),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ThemeColorPickerWidget(),
            ),
          ),
        );
      },
    );
  }
}