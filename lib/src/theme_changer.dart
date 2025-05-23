import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';

class ThemeChanger extends ConsumerWidget {
  final Widget child;
  final String? title;
  final Color defaultColor;
  final Color? scaffoldColor;

  const ThemeChanger({
    super.key,
    required this.child,
    this.title,
    required this.defaultColor,
    this.scaffoldColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize the theme provider with the default color
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeProvider.notifier).setDefaultColor(
            defaultColor,
            scaffoldColor: scaffoldColor,
          );
    });

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
    properties.add(ColorProperty('defaultColor', defaultColor));
    properties.add(ColorProperty('scaffoldColor', scaffoldColor));
  }
}
