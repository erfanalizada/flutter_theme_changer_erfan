import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_controller.dart';

class ThemeColorPickerWidget extends ConsumerStatefulWidget {
  const ThemeColorPickerWidget({
    super.key,
    this.availableColors = const [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
    ],
  });

  final List<Color> availableColors;

  @override
  ConsumerState<ThemeColorPickerWidget> createState() =>
      _ThemeColorPickerWidgetState();
}

class _ThemeColorPickerWidgetState
    extends ConsumerState<ThemeColorPickerWidget> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.availableColors
                        .map((color) => _buildColorButton(color))
                        .toList(),
                  ),
                ),
              ),
            ),
          _buildMainButton(currentTheme),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return InkWell(
      onTap: () {
        ref.read(themeProvider.notifier).updateTheme(color);
        _toggleExpanded();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(ThemeData currentTheme) {
    return InkWell(
      onTap: _toggleExpanded,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: currentTheme.colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 200),
          turns: _isExpanded ? 0.125 : 0,
          child: Icon(
            _isExpanded ? Icons.close : Icons.color_lens,
            color: currentTheme.colorScheme.onPrimary,
            size: 30,
          ),
        ),
      ),
    );
  }
}
