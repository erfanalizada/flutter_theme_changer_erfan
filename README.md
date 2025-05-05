# Flutter Dynamic Theme Changer

A Flutter package that allows you to easily change your app's theme color dynamically at runtime using Riverpod.  
It provides both a **full theme changer wrapper** and **two beautiful theme picker widgets**!

## ✨  Features

- 🎨 Dynamic primary color theme switching with Material 3 ColorScheme
- 🧩 Two ready-to-use theme picker widgets:
  - `ThemeColorPickerWidget`: An expandable color picker that can be placed anywhere (Great for floating).
  - `ThemeDialogButton`: A convenient AppBar button that shows colors in a dialog. Great for all common use cases.
- 🌈 Allow users to pick from customizable color palettes
- 🚀 Built with Flutter Riverpod 2.0 (StateNotifier based)
- 🎯 Simple API and easy integration
- ✍️ Fully customizable if needed
- ✅ Compatible with Flutter 3.24 and Material 3
- 🔄 Optimized performance with background processing
- 💾 Persistent theme preferences across app restarts
- 🧵 Off-main-thread theme generation for smooth UI


## 🎥 Theme Color Picker Demo

![ThemeColorPickerWidget](https://raw.githubusercontent.com/erfanalizada/flutter_theme_changer_erfan/main/ThemeColorPickerWidget.gif)

*Above: Animated demo of ThemeColorPickerWidget.*

---

## 🎥 Theme Dialog Button Demo

![ThemeDialogButton](https://raw.githubusercontent.com/erfanalizada/flutter_theme_changer_erfan/main/ThemeDialogButton.gif)

*Above: Animated demo of ThemeDialogButton widget.*






## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_theme_changer_erfan: ^0.0.1+8
```
Then run `flutter pub get` to install the package.

## 🛠️ How to Use

### Basic Setup
Wrap your app with ThemeChanger and specify a default color:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: ThemeChanger(
        title: 'My App',
        defaultColor: Colors.purple, // Specify your default theme color
        scaffoldColor: Colors.white, // Optional scaffold background color
        child: HomeScreen(),
      ),
    ),
  );
}
```

### Using ThemeDialogButton
Add the dialog button to your AppBar for a clean theme selection experience:

```dart
AppBar(
  title: const Text('My App'),
  actions: [
    // Add the theme dialog button to your AppBar
    ThemeDialogButton(
      availableColors: [
        Colors.blue,
        Colors.red,
        Colors.green,
        Colors.orange,
        Colors.purple,
      ],
    ),
  ],
)
```

## 🎨 Customizing Colors

Both widgets accept custom colors:

```dart
// For ThemeColorPickerWidget
ThemeColorPickerWidget(
  availableColors: [
    Colors.teal,
    Colors.indigo,
    Colors.deepOrange,
    Colors.cyan,
    Colors.lime,
    Colors.amber,
  ],
)

// For ThemeDialogButton (coming soon)
```

## 📦 What's Inside

Widget/File | Purpose
---|---
`ThemeChanger` | Wraps your app with dynamic theming
`ThemeColorPickerWidget` | Expandable color picker that shows in-place
`ThemeDialogButton` | AppBar button that shows colors in a dialog
`ThemeNotifier + themeProvider` | Riverpod logic for managing theme color


## 📲 Example

A full working example is available inside the /example folder.

To run the example locally:

```bash

flutter run --target=example/lib/main.dart

```
You'll see a floating color button — tap it, pick a color, and the app's theme changes instantly!

## ✅ All tests passed,including integration tests 

## ✅ All tests passed, including integration tests

![ScreenShot of testings log](https://raw.githubusercontent.com/erfanalizada/flutter_theme_changer_erfan/main/all_tests_passed.png)

## 🙌 Contributing
Contributions are welcome!
Feel free to open issues or submit pull requests if you'd like to help!

## 🔥 Author
Erfan Alizada. Developed with ❤️ using Flutter and Riverpod.

## Additional information

- For more examples, check out the example directory
- Report bugs on the [issue tracker](https://github.com/erfanalizada/flutter_theme_changer_erfan/issues)
- Contribute to the package on [GitHub](https://github.com/erfanalizada/flutter_theme_changer_erfan)


## 📄 License MIT
This project is licensed under the MIT License.
See the LICENSE file for more details.

## 🔍 Performance Considerations

This package is optimized for performance with:
- Background processing for theme generation using isolates
- Efficient state management with Riverpod
- Minimal rebuilds when changing themes
- Immediate UI feedback with optimized theme generation

For apps concerned with performance, you can monitor theme changes:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Add performance monitoring
  final observer = PerformanceObserver();
  WidgetsBinding.instance.addObserver(observer);
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## 📱 Material 3 Support

This package fully supports Material 3, which is the default in Flutter 3.24+. Key features include:

- Uses `ColorScheme.fromSeed` for harmonious color generation
- Properly handles Material 3 theme properties
- Supports the new Material 3 color system
- Adapts to both light and dark themes

The theme picker widgets automatically adapt to your app's Material version and provide a consistent experience.

## 🔄 Theme Persistence

Themes are automatically saved to SharedPreferences and restored when the app restarts:

- User theme preferences persist across app sessions
- Fast loading with optimized storage
- Fallback to default theme when no saved preference exists

## 🧵 Advanced Usage

### Custom Theme Generation

You can customize how themes are generated by extending the ThemeNotifier:

```dart
class CustomThemeNotifier extends ThemeNotifier {
  @override
  Future<void> updateThemeOffMainThread(Color primaryColor) async {
    // Your custom theme generation logic
    super.updateThemeOffMainThread(primaryColor);
  }
}

// Register your custom provider
final customThemeProvider = StateNotifierProvider<CustomThemeNotifier, ThemeData>((ref) {
  return CustomThemeNotifier();
});
```

### Performance Monitoring

The package includes built-in performance logging that you can use to monitor theme generation times:

```dart
import 'dart:developer' as developer;

void main() {
  // Enable detailed logging
  developer.log('Theme generation performance monitoring enabled', name: 'performance');
  
  runApp(const ProviderScope(child: MyApp()));
}
```

## 📊 Technical Details

- Uses isolates for off-main-thread theme generation
- Implements optimized color calculations
- Leverages Flutter's Material 3 design system
- Provides immediate visual feedback while processing complex themes

