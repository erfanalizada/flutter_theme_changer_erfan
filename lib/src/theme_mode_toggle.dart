import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';

/// A toggle widget for switching between light and dark mode
class ThemeModeToggle extends ConsumerWidget {
  /// Creates a theme mode toggle widget
  const ThemeModeToggle({
    super.key,
    this.showIcon = true,
    this.showText = true,
    this.compact = false,
    this.lightModeIconColor, // New parameter for light mode icon color
    this.darkModeIconColor, // New parameter for dark mode icon color
  });

  /// Whether to show the sun/moon icon
  final bool showIcon;

  /// Whether to show the "Light/Dark" text
  final bool showText;

  /// Whether to use a compact layout (icon only)
  final bool compact;

  /// Custom color for the light mode icon (sun)
  /// If null, uses the theme's icon color
  final Color? lightModeIconColor;

  /// Custom color for the dark mode icon (moon)
  /// If null, uses the theme's icon color
  final Color? darkModeIconColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider.notifier).isDarkMode;

    // Hardcoded icons for light/dark mode
    final IconData darkModeIcon = Icons.dark_mode; // Moon icon for dark mode
    final IconData lightModeIcon = Icons.light_mode; // Sun icon for light mode

    // Default colors if not provided
    final Color defaultLightModeColor = Colors.amber; // Yellow/amber for sun
    final Color defaultDarkModeColor = Colors.indigo; // Indigo for moon

    // Use provided colors or fallback to defaults
    final Color currentLightIconColor =
        lightModeIconColor ?? defaultLightModeColor;
    final Color currentDarkIconColor =
        darkModeIconColor ?? defaultDarkModeColor;

    // Select the appropriate icon and color based on current mode
    final IconData currentIcon = isDarkMode ? lightModeIcon : darkModeIcon;
    final Color currentIconColor =
        isDarkMode ? currentLightIconColor : currentDarkIconColor;

    if (compact) {
      return IconButton(
        icon: Icon(
          currentIcon,
          color: currentIconColor,
        ),
        tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
        onPressed: () {
          ref.read(themeProvider.notifier).toggleDarkMode();
        },
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        ref.read(themeProvider.notifier).toggleDarkMode();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Icon(
                currentIcon,
                size: 20,
                color: currentIconColor,
              ),
            if (showIcon && showText) const SizedBox(width: 8),
            if (showText)
              Text(
                isDarkMode ? 'Light Mode' : 'Dark Mode',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
          ],
        ),
      ),
    );
  }
}
