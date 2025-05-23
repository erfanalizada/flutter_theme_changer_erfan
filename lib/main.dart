import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/theme_changer.dart';
import 'src/theme_color_picker_widget.dart';
import 'src/theme_dialog_button.dart';
import 'src/custom_color_picker_dialog.dart';

void main() async {
  // Initialize Flutter binding
  WidgetsFlutterBinding.ensureInitialized();

  // Clear saved theme preferences (optional - remove this in production)
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('theme_color');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeChanger(
      title: 'Theme Dialog Demo',
      defaultColor: Color.fromARGB(255, 198, 255, 64),
      child: ThemeChangerDemo(),
    );
  }
}

class ThemeChangerDemo extends StatefulWidget {
  const ThemeChangerDemo({super.key});

  @override
  State<ThemeChangerDemo> createState() => _ThemeChangerDemoState();
}

class _ThemeChangerDemoState extends State<ThemeChangerDemo> {
  bool _toggleValue = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer Demo'),
        actions: const [
          ThemeDialogButton(
            availableColors: [Colors.red, Colors.blue, Colors.green],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme color picker widget
            const ThemeColorPickerWidget(
              availableColors: [Colors.red, Colors.blue, Colors.green],
            ),
            const SizedBox(height: 40),

            // Custom toggle widget that calls CustomColorPickerDialog
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Toggle Theme Picker:'),
                const SizedBox(width: 16),
                Switch(
                  value: _toggleValue,
                  onChanged: (value) {
                    setState(() {
                      _toggleValue = value;
                    });
                    if (value) {
                      CustomColorPickerDialog.showColorPickerDialog(
                        context,
                        availableColors: [
                          Colors.purple,
                          Colors.orange,
                          Colors.teal,
                          Colors.pink,
                          Colors.indigo,
                          Colors.amber,
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
