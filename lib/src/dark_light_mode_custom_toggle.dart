import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_controller.dart';

/// Provider for custom theme colors
final customThemeColorsProvider =
    StateNotifierProvider<CustomThemeColorsNotifier, CustomThemeColors>((ref) {
  return CustomThemeColorsNotifier();
});

/// Model class to hold custom colors for light and dark modes
class CustomThemeColors {
  final Map<String, Color> lightModeColors;
  final Map<String, Color> darkModeColors;
  final bool isDarkMode;

  CustomThemeColors({
    required this.lightModeColors,
    required this.darkModeColors,
    this.isDarkMode = false,
  });

  CustomThemeColors copyWith({
    Map<String, Color>? lightModeColors,
    Map<String, Color>? darkModeColors,
    bool? isDarkMode,
  }) {
    return CustomThemeColors(
      lightModeColors: lightModeColors ?? this.lightModeColors,
      darkModeColors: darkModeColors ?? this.darkModeColors,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  /// Get a color by key based on current mode
  Color getColor(String key) {
    final colors = isDarkMode ? darkModeColors : lightModeColors;
    return colors[key] ?? Colors.grey;
  }
}

/// Notifier to manage custom theme colors
class CustomThemeColorsNotifier extends StateNotifier<CustomThemeColors> {
  bool _preferencesLoaded = false;

  CustomThemeColorsNotifier()
      : super(CustomThemeColors(
          lightModeColors: {
            // Default light mode colors
            'background': Colors.white,
            'text': Colors.black87,
          },
          darkModeColors: {
            // Default dark mode colors
            'background': Colors.grey.shade900,
            'text': Colors.white,
          },
          isDarkMode: false, // Default to light mode
        )) {
    // Load saved mode preference immediately
    _loadSavedModePreference();
  }

  // Improved method to load saved preference
  Future<void> _loadSavedModePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIsDarkMode = prefs.getBool('custom_theme_is_dark_mode');
      if (savedIsDarkMode != null) {
        state = state.copyWith(isDarkMode: savedIsDarkMode);
      }
      _preferencesLoaded = true;
    } catch (e) {
      _preferencesLoaded = true; // Mark as loaded even on error
    }
  }

  // Add this method to save preference
  Future<void> _saveModePreference(bool isDarkMode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('custom_theme_is_dark_mode', isDarkMode);
    } catch (e) {
      // Silently handle errors
    }
  }

  void setLightModeColors(Map<String, Color> colors) {
    state = state.copyWith(lightModeColors: colors);
  }

  void setDarkModeColors(Map<String, Color> colors) {
    state = state.copyWith(darkModeColors: colors);
  }

  // Wait for preferences to load before setting mode
  Future<void> setMode(bool isDarkMode) async {
    // Wait for preferences to load if they haven't already
    if (!_preferencesLoaded) {
      await _loadSavedModePreference();
    }

    state = state.copyWith(isDarkMode: isDarkMode);
    _saveModePreference(isDarkMode);
  }

  // Wait for preferences to load before toggling mode
  Future<void> toggleMode() async {
    // Wait for preferences to load if they haven't already
    if (!_preferencesLoaded) {
      await _loadSavedModePreference();
    }

    final newIsDarkMode = !state.isDarkMode;
    state = state.copyWith(isDarkMode: newIsDarkMode);
    _saveModePreference(newIsDarkMode);
  }

  /// Get a color by key
  Color getColor(String key) {
    return state.getColor(key);
  }
}

/// A utility class to access custom theme colors
class CustomThemeColorPalette {
  final WidgetRef ref;

  CustomThemeColorPalette(this.ref);

  Color getColor(String key) {
    return ref.read(customThemeColorsProvider.notifier).getColor(key);
  }

  /// Initialize the color palette with custom colors
  static void initialize(
    WidgetRef ref, {
    required Map<String, Color> lightModeColors,
    required Map<String, Color> darkModeColors,
    bool isDarkMode = false,
    bool syncWithAppTheme = false,
  }) {
    ref
        .read(customThemeColorsProvider.notifier)
        .setLightModeColors(lightModeColors);
    ref
        .read(customThemeColorsProvider.notifier)
        .setDarkModeColors(darkModeColors);

    // Set the mode based on the isDarkMode parameter
    ref.read(customThemeColorsProvider.notifier).setMode(isDarkMode);

    // If syncing with app theme, also update the app theme
    if (syncWithAppTheme) {
      final appIsDarkMode = ref.read(themeProvider.notifier).isDarkMode;
      if (appIsDarkMode != isDarkMode) {
        ref.read(themeProvider.notifier).toggleDarkMode();
      }
    }
  }

  /// Apply theme colors to the app theme
  static void applyToAppTheme(
    WidgetRef ref, {
    required Map<String, Color> lightModeColors,
    required Map<String, Color> darkModeColors,
    bool isDarkMode = false,
  }) {
    // Get primary colors from the maps
    final lightPrimary = lightModeColors['primary'] ?? Colors.blue;
    final darkPrimary = darkModeColors['primary'] ?? Colors.blue;

    // Get background colors if available
    final lightBackground = lightModeColors['background'];
    final darkBackground = darkModeColors['background'];

    // Update the app theme with the appropriate color based on mode
    final primaryColor = isDarkMode ? darkPrimary : lightPrimary;
    final scaffoldColor = isDarkMode ? darkBackground : lightBackground;

    // Update the app theme
    ref.read(themeProvider.notifier).updateTheme(
          primaryColor,
        );

    // Ensure the app's dark mode state matches
    final appIsDarkMode = ref.read(themeProvider.notifier).isDarkMode;
    if (appIsDarkMode != isDarkMode) {
      ref.read(themeProvider.notifier).toggleDarkMode();
    }
  }
}

/// A widget that allows toggling between custom light and dark mode color schemes
class DarkLightModeCustomToggle extends ConsumerWidget {
  /// Creates a custom theme mode toggle widget
  const DarkLightModeCustomToggle({
    super.key,
    required this.lightModeColors,
    required this.darkModeColors,
    this.showIcon = true,
    this.showText = true,
    this.syncWithAppTheme = true,
    this.lightModeIconColor,
    this.darkModeIconColor,
    this.defaultDarkMode = false, // Default mode property
  });

  /// Colors to use in light mode (map of name to color)
  final Map<String, Color> lightModeColors;

  /// Colors to use in dark mode (map of name to color)
  final Map<String, Color> darkModeColors;

  /// Whether to show the sun/moon icon
  final bool showIcon;

  /// Whether to show the "Light/Dark" text
  final bool showText;

  /// Whether to sync with the app's theme mode
  final bool syncWithAppTheme;

  /// Custom color for the light mode icon
  final Color? lightModeIconColor;

  /// Custom color for the dark mode icon
  final Color? darkModeIconColor;

  /// Whether to use dark mode by default
  final bool defaultDarkMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize colors if needed - ONLY ONCE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add a check to prevent multiple initializations
      if (!_initialized) {
        ref
            .read(customThemeColorsProvider.notifier)
            .setLightModeColors(lightModeColors);
        ref
            .read(customThemeColorsProvider.notifier)
            .setDarkModeColors(darkModeColors);

        // Only set default mode if there's no saved preference
        // This allows the saved preference to take precedence
        final currentIsDarkMode =
            ref.read(customThemeColorsProvider).isDarkMode;

        // If there's no saved preference (currentIsDarkMode is false by default)
        // and defaultDarkMode is true, then set the mode
        if (!currentIsDarkMode && defaultDarkMode) {
          // Set the mode directly
          ref.read(customThemeColorsProvider.notifier).setMode(defaultDarkMode);

          // If syncing with app theme, also update the app theme
          if (syncWithAppTheme) {
            // Apply colors to app theme immediately to avoid rendering issues
            CustomThemeColorPalette.applyToAppTheme(
              ref,
              lightModeColors: lightModeColors,
              darkModeColors: darkModeColors,
              isDarkMode: defaultDarkMode,
            );
          }
        } else if (syncWithAppTheme) {
          // Ensure app theme is synced with the current mode (which might be from saved preference)
          CustomThemeColorPalette.applyToAppTheme(
            ref,
            lightModeColors: lightModeColors,
            darkModeColors: darkModeColors,
            isDarkMode: currentIsDarkMode,
          );
        }

        _initialized = true;
      }
    });

    final customColors = ref.watch(customThemeColorsProvider);
    final isDarkMode = customColors.isDarkMode;

    // Icons for light/dark mode
    final IconData darkModeIcon = Icons.dark_mode;
    final IconData lightModeIcon = Icons.light_mode;

    // Default colors if not provided
    final Color defaultLightModeColor = Colors.amber;
    final Color defaultDarkModeColor = Colors.indigo;

    // Use provided colors or fallback to defaults
    final Color currentLightIconColor =
        lightModeIconColor ?? defaultLightModeColor;
    final Color currentDarkIconColor =
        darkModeIconColor ?? defaultDarkModeColor;

    // Current icon based on mode
    final IconData currentIcon = isDarkMode ? lightModeIcon : darkModeIcon;
    final Color currentIconColor =
        isDarkMode ? currentLightIconColor : currentDarkIconColor;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        ref.read(customThemeColorsProvider.notifier).toggleMode();

        if (syncWithAppTheme) {
          ref.read(themeProvider.notifier).toggleDarkMode();
        }
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

  /// Create a color palette to access colors
  static CustomThemeColorPalette getColorPalette(WidgetRef ref) {
    return CustomThemeColorPalette(ref);
  }
}

// Add this flag to the state class
bool _initialized = false;
