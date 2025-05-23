import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/src/dark_light_mode_custom_toggle.dart';

class CustomThemeExample extends ConsumerWidget {
  const CustomThemeExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Define custom colors for light and dark modes using named keys
    final lightModeColors = {
      'background': Colors.white,
      'textField': Colors.blue.shade100,
      'button': Colors.blue.shade800,
      'text': Colors.black,
    };

    final darkModeColors = {
      'background': Colors.grey.shade900,
      'textField': Colors.grey.shade800,
      'button': Colors.blue.shade600,
      'text': Colors.white,
    };

    // Create a color palette to access colors
    final colorPalette = DarkLightModeCustomToggle.getColorPalette(ref);

    return Scaffold(
      backgroundColor: colorPalette.getColor('background'),
      appBar: AppBar(
        title: Text(
          'Custom Theme Example',
          style: TextStyle(color: colorPalette.getColor('text')),
        ),
        backgroundColor:
            colorPalette.getColor('background').withValues(alpha: 0.8),
        actions: [
          // Add the custom theme toggle
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DarkLightModeCustomToggle(
              lightModeColors: lightModeColors,
              darkModeColors: darkModeColors,
              syncWithAppTheme: true, // Sync with app theme if desired
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Example TextField using custom colors
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter text here',
                  fillColor: colorPalette.getColor('textField'),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: TextStyle(color: colorPalette.getColor('text')),
              ),

              const SizedBox(height: 20),

              // Example Button using custom colors
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPalette.getColor('button'),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Custom Themed Button'),
              ),

              const SizedBox(height: 40),

              // Text explaining the feature
              Text(
                'This example demonstrates how to use custom colors for light and dark modes.',
                style: TextStyle(color: colorPalette.getColor('text')),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
