import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/screen_one.dart';
import 'screens/screen_two.dart';
import 'screens/screen_three.dart';
import 'screens/screen_four.dart';
import 'widgets/theme_color_picker_widget.dart';
import 'widgets/theme_controller.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Theme Picker Demo',
      theme: ref.watch(themeProvider),
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
  int _currentIndex = 0;
  
  static const _screens = [
    ScreenOne(),
    ScreenTwo(),
    ScreenThree(),
    ScreenFour(),
  ];

  static final _navItems = [
    _buildNavItem(Icons.person, 'Name'),
    _buildNavItem(Icons.email, 'Email'),
    _buildNavItem(Icons.phone, 'Phone'),
    _buildNavItem(Icons.home, 'Address'),
  ];

  static BottomNavigationBarItem _buildNavItem(IconData icon, String label) {
    return BottomNavigationBarItem(icon: Icon(icon), label: label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_navItems[_currentIndex].label!)),
      body: Stack(
        children: [
          _screens[_currentIndex],
          const Positioned(
            bottom: 80,
            right: 20,
            child: ThemeColorPickerWidget(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems,
      ),
    );
  }
}


