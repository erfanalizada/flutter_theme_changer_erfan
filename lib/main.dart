import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/dynamic_theme_picker.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemeChanger(
      title: 'Theme Changer Demo',
      child: ThemeChangerDemo(),
    );
  }
}

class ThemeChangerDemo extends StatelessWidget {
  const ThemeChangerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer Demo'),
      ),
      body: const Center(
        child: ThemeColorPickerWidget(),
      ),
    );
  }
}