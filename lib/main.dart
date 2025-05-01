import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/dynamic_theme_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Log Flutter engine info
  developer.log('Flutter engine: ${PlatformDispatcher.instance.views.first.platformDispatcher.semanticsEnabled}', name: 'performance');
  developer.log('Using Impeller: ${_isUsingImpeller()}', name: 'performance');
  
  // Add performance observer
  final observer = _PerformanceObserver();
  WidgetsBinding.instance.addObserver(observer);
  
  runApp(const ProviderScope(child: MyApp()));
}

// Helper to detect if Impeller is being used
bool _isUsingImpeller() {
  try {
    // This is a hacky way to detect Impeller, but there's no official API yet
    return PlatformDispatcher.instance.toString().contains('Impeller');
  } catch (_) {
    return false;
  }
}

// Performance observer class
class _PerformanceObserver with WidgetsBindingObserver {
  Stopwatch? _frameStopwatch;
  
  @override
  void didBeginFrame() {
    _frameStopwatch = Stopwatch()..start();
    developer.log('Frame started', name: 'performance');
  }
  
  @override
  void didDrawFrame() {
    if (_frameStopwatch != null) {
      final elapsed = _frameStopwatch!.elapsedMilliseconds;
      if (elapsed > 16) { // Frame took longer than 16ms (60fps)
        developer.log('Slow frame: ${elapsed}ms', name: 'performance');
      }
      _frameStopwatch = null;
    }
  }
}

// Wrap your app with a performance monitor
class PerformanceMonitorWidget extends StatefulWidget {
  final Widget child;
  
  const PerformanceMonitorWidget({Key? key, required this.child}) : super(key: key);
  
  @override
  State<PerformanceMonitorWidget> createState() => _PerformanceMonitorWidgetState();
}

class _PerformanceMonitorWidgetState extends State<PerformanceMonitorWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
  
  @override
  void initState() {
    super.initState();
    developer.log('App UI initialized', name: 'performance');
    
    // Log first frame timing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      developer.log('First frame rendered', name: 'performance');
    });
  }
}

// Modify your MyApp class to use the performance monitor
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const PerformanceMonitorWidget(
      child: ThemeChanger(
        title: 'Theme Dialog Demo',
        child: ThemeChangerDemo(),
      ),
    );
  }
}

class ThemeChangerDemo extends StatefulWidget {
  const ThemeChangerDemo({super.key});

  @override
  State<ThemeChangerDemo> createState() => _ThemeChangerDemoState();
}

class _ThemeChangerDemoState extends State<ThemeChangerDemo> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer Demo'),
        actions: const [
          ThemeDialogButton(
            availableColors: [Colors.red, Colors.blue, Colors.green],
            gradientColors: [
              [Colors.purple, Colors.deepPurple],
              [Colors.orange, Colors.deepOrange, Colors.red],
              [Colors.lightBlue, Colors.blue, Colors.indigo, Colors.purple],
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Theme color picker widget
            const ThemeColorPickerWidget(
              gradientColors: [
                [Colors.teal, Colors.green],
                [Colors.pink, Colors.purple],
              ],
            ),
            const SizedBox(height: 40),
            
            // Various button types to show theme effects
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 16),
            
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),
            const SizedBox(height: 16),
            
            TextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 16),
            
            // Card with content
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Themed Card',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This card uses the theme colors',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Switch(
                      value: true,
                      onChanged: (value) {},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}









