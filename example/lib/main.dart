import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/dynamic_theme_picker.dart';

// Create a provider to track if initialization is complete
final initializationCompleteProvider = StateProvider<bool>((ref) => false);

// Define theme colors at the top level for reuse
final Map<String, Color> appLightModeColors = {
  'background': Colors.white,
  'card': Colors.blue.shade50,
  'primary': Colors.blue.shade600,
  'secondary': Colors.teal.shade400,
  'text': Colors.black87,
  'textLight': Colors.black54,
  'accent': Colors.orange,
};

final Map<String, Color> appDarkModeColors = {
  'background': Colors.grey.shade900,
  'card': Colors.grey.shade800,
  'primary': Colors.blue.shade400,
  'secondary': Colors.teal.shade300,
  'text': Colors.white,
  'textLight': Colors.white70,
  'accent': Colors.amber,
};

void main() {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Run the app with ProviderScope
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

    // Initialize theme synchronously in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Apply theme immediately
      _initializeTheme();
    });
  }

  void _initializeTheme() {
    // Initialize custom theme colors
    CustomThemeColorPalette.initialize(
      ref,
      lightModeColors: appLightModeColors,
      darkModeColors: appDarkModeColors,
      isDarkMode: false, // Default to light mode
      syncWithAppTheme: true,
    );

    // Mark initialization as complete
    ref.read(initializationCompleteProvider.notifier).state = true;
  }

  @override
  Widget build(BuildContext context) {
    // Watch initialization state
    final isInitialized = ref.watch(initializationCompleteProvider);

    return ThemeChanger(
      title: 'Custom Theme Demo',
      defaultColor: appLightModeColors['primary'] ??
          const Color.fromARGB(255, 41, 66, 87),
      child: isInitialized
          ? const CustomThemeDemo()
          : const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
    );
  }
}

class CustomThemeDemo extends ConsumerWidget {
  const CustomThemeDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Create a color palette to access colors
    final colorPalette = DarkLightModeCustomToggle.getColorPalette(ref);

    // Only watch the isDarkMode value, not the entire provider
    final isDarkMode = ref
        .watch(customThemeColorsProvider.select((state) => state.isDarkMode));

    // Only print once when the mode changes
    if (kDebugMode) {
      print('Current mode: ${isDarkMode ? "Dark" : "Light"}');
    }

    return Scaffold(
      backgroundColor: colorPalette.getColor('background'),
      appBar: AppBar(
        title: Text(
          'Custom Theme Demo',
          style: TextStyle(color: colorPalette.getColor('text')),
        ),
        backgroundColor: colorPalette.getColor('accent'),
        actions: [
          // Add the custom theme toggle
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DarkLightModeCustomToggle(
              lightModeColors: appLightModeColors,
              darkModeColors: appDarkModeColors,
              syncWithAppTheme: true,
              defaultDarkMode: false, // Set to false for light mode by default
              // Add a key for easier debugging
              key: const Key('themeToggle'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Text(
                'Custom Theme Demonstration',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorPalette.getColor('text'),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Toggle between light and dark mode to see how colors change',
                style: TextStyle(
                  fontSize: 16,
                  color: colorPalette.getColor('primary'),
                ),
              ),

              const SizedBox(height: 30),

              // Card example
              Card(
                color: colorPalette.getColor('card'),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Card Component',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorPalette.getColor('text'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This card uses the "card" color from our custom palette',
                        style: TextStyle(
                          color: colorPalette.getColor('textLight'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Button examples
              Text(
                'Button Examples',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorPalette.getColor('accent'),
                ),
              ),

              const SizedBox(height: 12),

              // Primary button
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(colorPalette.getColor('accent')),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                child: const Text('Primary Button'),
              ),

              const SizedBox(height: 12),

              // Secondary button
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      colorPalette.getColor('secondary')),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                child: const Text('Secondary Button'),
              ),

              const SizedBox(height: 12),

              // Accent button
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(colorPalette.getColor('accent')),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                child: const Text('Accent Button'),
              ),

              const SizedBox(height: 30),

              // Text field example
              Text(
                'Text Field Example',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorPalette.getColor('text'),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter text here',
                  hintStyle:
                      TextStyle(color: colorPalette.getColor('textLight')),
                  fillColor: colorPalette.getColor('card'),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: colorPalette.getColor('primary')),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                        color: colorPalette.getColor('accent'), width: 2),
                  ),
                ),
                style: TextStyle(color: colorPalette.getColor('text')),
              ),

              const SizedBox(height: 30),

              // Information section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      colorPalette.getColor('primary').withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorPalette.getColor('primary')),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: colorPalette.getColor('primary')),
                        const SizedBox(width: 8),
                        Text(
                          'How It Works',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colorPalette.getColor('text'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This demo uses named colors that switch between light and dark mode. '
                      'Click the toggle in the app bar to switch modes and see how all UI elements update.',
                      style: TextStyle(color: colorPalette.getColor('text')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
