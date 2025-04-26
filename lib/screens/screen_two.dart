import 'package:flutter/material.dart';

class ScreenTwo extends StatefulWidget {
  const ScreenTwo({Key? key}) : super(key: key);

  @override
  State<ScreenTwo> createState() => _ScreenTwoState();
}

class _ScreenTwoState extends State<ScreenTwo> {
  String? _selectedEmailType = 'Personal';
  String? _selectedNotification = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: _selectedEmailType,
            decoration: InputDecoration(
              labelText: 'Email Type',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            items: ['Personal', 'Work', 'Other']
                .map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedEmailType = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Enter your email',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: _selectedNotification,
            decoration: InputDecoration(
              labelText: 'Notification Preference',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            items: ['Daily', 'Weekly', 'Monthly', 'Never']
                .map((freq) => DropdownMenuItem(
                      value: freq,
                      child: Text(freq),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedNotification = value;
              });
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text('Verify Email'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.help_outline),
                label: const Text('Need Help?'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
