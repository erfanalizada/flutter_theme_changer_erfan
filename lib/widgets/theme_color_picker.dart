import 'package:flutter/material.dart';

class ThemeColorPicker extends StatefulWidget {
  final List<Color> availableColors;
  final ValueChanged<Color> onColorSelected;

  const ThemeColorPicker({
    super.key,
    required this.availableColors,
    required this.onColorSelected,
  });

  @override
  State<ThemeColorPicker> createState() => _ThemeColorPickerState();
}

class _ThemeColorPickerState extends State<ThemeColorPicker> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_isExpanded)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: widget.availableColors.map((color) {
              return GestureDetector(
                onTap: () {
                  widget.onColorSelected(color);
                  _toggleExpanded();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              );
            }).toList(),
          ),
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isExpanded ? Icons.close : Icons.color_lens,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
