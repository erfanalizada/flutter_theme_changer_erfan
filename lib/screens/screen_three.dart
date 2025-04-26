import 'package:flutter/material.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {}, // Added empty callback to enable the button
        child: const Text('Screen Three Button'),
      ),
    );
  }
}
