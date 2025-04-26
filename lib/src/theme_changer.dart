import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';

class ThemeChanger extends ConsumerWidget {
  final Widget child;
  final String? title;

  const ThemeChanger({
    super.key,
    required this.child,
    this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: title ?? 'Theme Changer',
      theme: ref.watch(themeProvider),
      home: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Widget>('child', child));
    properties.add(DiagnosticsProperty<String>('title', title));
  }
}
