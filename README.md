# Flutter Dynamic Theme Changer

A Flutter package that allows you to easily change your app's theme color dynamically at runtime using Riverpod.  
It provides both a **full theme changer wrapper** and **two beautiful theme picker widgets**!

## ✨  Features

- 🎨 Dynamic primary color theme switching
- 🧩 Two ready-to-use theme picker widgets:
  - `ThemeColorPickerWidget`: An expandable color picker that can be placed anywhere(Great for floating).
  - `ThemeDialogButton`: A convenient AppBar button that shows colors in a dialog. Great for all common use cases.
- 🌈 Allow users to pick from customizable color palettes
- 🚀 Built with Flutter Riverpod 2.0 (StateNotifier based)
- 🎯 Simple API and easy integration
- ✍️ Fully customizable if needed


<h2>🎥 Theme Color Picker Demo</h2>

<img src="https://raw.githubusercontent.com/erfanalizada/flutter_theme_changer_erfan/main/ThemeColorPickerWidget.gif" width="400"/>

<p><i>Above: Animated demo of ThemeColorPickerWidget.</i></p>

---

<h2>🎥 Theme Dialog Button Demo</h2>

<img src="https://raw.githubusercontent.com/erfanalizada/flutter_theme_changer_erfan/main/ThemeDialogButton.gif" width="400"/>

<p><i>Above: Animated demo of ThemeDialogButton.</i></p>





## Getting started

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_theme_changer_erfan: ^0.0.1+1
```
Then run `flutter pub get` to install the package.

## 🛠️ How to Use

### Option 1: Using ThemeColorPickerWidget (Expandable Picker)
Place the color picker directly in your layout:

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ThemeColorPickerWidget(), // Expands to show colors when tapped
      ),
    );
  }
}
```

### Option 2: Using ThemeDialogButton (Dialog Picker)
Add a button to your AppBar that shows colors in a dialog:

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
        actions: [
          ThemeDialogButton(), // Shows color picker in a dialog
        ],
      ),
    );
  }
}
```

### Basic Setup
Wrap your app with ThemeChanger:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: ThemeChanger(
        title: 'My App',
        child: HomeScreen(),
      ),
    ),
  );
}
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

