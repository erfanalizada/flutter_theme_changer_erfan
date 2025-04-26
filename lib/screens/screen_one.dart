import 'package:flutter/material.dart';
import '../widgets/theme_color_picker_widget.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () {}, // Added callback to enable the button
            child: const Text('Screen One Button'),
          ),
        ),
        const Positioned(
          bottom: 20,
          right: 20,
          child: ThemeColorPickerWidget(),
        ),
      ],
    );
  }
}
