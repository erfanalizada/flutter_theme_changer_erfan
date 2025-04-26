import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/screen_one.dart';
import 'screens/screen_two.dart';
import 'screens/screen_three.dart';
import 'screens/screen_four.dart';
import 'widgets/theme_color_picker_widget.dart';
import 'widgets/theme_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Theme Picker Demo',
      theme: theme,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // <- this tracks which page we are on

  final List<Widget> _screens = const [
    ScreenOne(),
    ScreenTwo(),
    ScreenThree(),
    ScreenFour(),
  ];

  final List<String> _titles = const [
    'Name',
    'Email',
    'Phone',
    'Address',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]), // <- title changes depending on page
        // Use theme colors explicitly
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Stack(
        children: [
          Container(
            // Add a background color to make theme changes more visible
            color: Theme.of(context).colorScheme.background,
            child: _screens[_currentIndex],
          ),
          const Positioned(
            bottom: 80,
            right: 20,
            child: ThemeColorPickerWidget(), // <- circular color picker floating
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // <- which item is selected
        onTap: (index) {
          setState(() {
            _currentIndex = index; // <- change screen when tapped
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Name',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Email',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: 'Phone',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Address',
          ),
        ],
      ),
    );
  }
}


