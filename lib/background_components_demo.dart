import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_theme_changer_erfan/dynamic_theme_picker.dart';

class BackgroundComponentsDemo extends ConsumerStatefulWidget {
  const BackgroundComponentsDemo({super.key});

  @override
  ConsumerState<BackgroundComponentsDemo> createState() => _BackgroundComponentsDemoState();
}

class _BackgroundComponentsDemoState extends ConsumerState<BackgroundComponentsDemo> {
  int _selectedIndex = 0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Color Components'),
          actions: const [
            ThemeDialogButton(
              availableColors: [
                Colors.blue, 
                Colors.red, 
                Colors.green, 
                Colors.purple, 
                Colors.orange,
                Colors.teal,
                Colors.brown,
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Surfaces'),
              Tab(text: 'Dialogs'),
              Tab(text: 'Other'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: const Text('Current Theme Colors'),
                subtitle: Text('Primary: ${Theme.of(context).colorScheme.primary}'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: const Text('Close Drawer'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab - Surface components
            _buildSurfacesTab(context),
            
            // Second tab - Dialog components
            _buildDialogsTab(context),
            
            // Third tab - Other components
            _buildOtherComponentsTab(context),
          ],
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
          onTap: (index) => setState(() => _selectedIndex = index),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Current primary color: ${Theme.of(context).colorScheme.primary}',
                ),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          tooltip: 'Show Theme Colors',
          child: const Icon(Icons.color_lens),
        ),
      ),
    );
  }

  Widget _buildSurfacesTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Material Surfaces'),
          
          // 1. Material with default background
          _buildComponentCard(
            context,
            'Material',
            'Basic Material surface uses background color',
            Material(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Material Surface',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          
          // 2. Card
          _buildComponentCard(
            context,
            'Card',
            'Card background is derived from colorScheme.background',
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Card Widget',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ),
          
          // 3. ExpansionPanel
          _buildComponentCard(
            context,
            'ExpansionPanel',
            'Panel background uses colorScheme.background',
            ExpansionPanelList(
              expansionCallback: (index, isExpanded) {
                setState(() {
                  _expanded = !isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isExpanded) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Expansion Panel Header',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Expansion Panel Content',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  isExpanded: _expanded,
                ),
              ],
            ),
          ),
          
          // 4. Container with explicit theme color
          _buildComponentCard(
            context,
            'Explicit Theme Color',
            'Container using Theme.of(context).colorScheme.primary',
            Container(
              color: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.all(16),
              child: Text(
                'Container with explicit primary color',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          
          // 5. AppBar with theme color
          _buildComponentCard(
            context,
            'AppBar with Theme Color',
            'AppBar using colorScheme.primary',
            AppBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              title: Text(
                'AppBar with Theme Color',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Center(
            child: ThemeColorPickerWidget(
              availableColors: [
                Colors.blue, 
                Colors.red, 
                Colors.green, 
                Colors.purple, 
                Colors.orange,
                Colors.teal,
                Colors.brown,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Dialog Components'),
          
          // 1. AlertDialog
          _buildComponentCard(
            context,
            'AlertDialog',
            'Dialog background uses colorScheme.background',
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Alert Dialog'),
                    content: const Text(
                      'This dialog\'s background color is affected by colorScheme.background',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Alert Dialog'),
            ),
          ),
          
          // 2. SimpleDialog
          _buildComponentCard(
            context,
            'SimpleDialog',
            'Dialog background uses colorScheme.background',
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    title: const Text('Simple Dialog'),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'This dialog\'s background is affected by colorScheme.background',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Show Simple Dialog'),
            ),
          ),
          
          // 3. BottomSheet
          _buildComponentCard(
            context,
            'BottomSheet',
            'Sheet background uses colorScheme.background',
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Bottom Sheet',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This sheet\'s background is affected by colorScheme.background',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Show Bottom Sheet'),
            ),
          ),
          
          // 4. DatePicker
          _buildComponentCard(
            context,
            'DatePicker',
            'Picker dialog background uses colorScheme.background',
            ElevatedButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2025),
                );
              },
              child: const Text('Show Date Picker'),
            ),
          ),
          
          // 5. TimePicker
          _buildComponentCard(
            context,
            'TimePicker',
            'Picker dialog background uses colorScheme.background',
            ElevatedButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: const Text('Show Time Picker'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherComponentsTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Other Components'),
          
          // Toggle Components Section
          _buildSectionHeader(context, 'Toggle Components'),
          
          // 1. Radio Buttons
          _buildComponentCard(
            context,
            'Radio Buttons',
            'Radio buttons use colorScheme.secondary for selected state',
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [1, 2, 3].map((value) => 
                Radio<int>(
                  value: value,
                  groupValue: _selectedIndex,
                  onChanged: (newValue) {
                    setState(() {
                      if (newValue != null) _selectedIndex = newValue;
                    });
                  },
                )
              ).toList(),
            ),
          ),
          
          // 2. Checkbox
          _buildComponentCard(
            context,
            'Checkbox',
            'Checkbox uses colorScheme.secondary for selected state',
            Checkbox(
              value: _expanded,
              onChanged: (value) {
                setState(() {
                  if (value != null) _expanded = value;
                });
              },
            ),
          ),
          
          // 3. Switch
          _buildComponentCard(
            context,
            'Switch',
            'Switch uses colorScheme.secondary for active state',
            Switch(
              value: _expanded,
              onChanged: (value) {
                setState(() {
                  _expanded = value;
                });
              },
            ),
          ),
          
          // 4. ToggleButtons
          _buildComponentCard(
            context,
            'ToggleButtons',
            'ToggleButtons use colorScheme for selected state',
            ToggleButtons(
              isSelected: [_selectedIndex == 0, _selectedIndex == 1, _selectedIndex == 2],
              onPressed: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: const [
                Icon(Icons.format_bold),
                Icon(Icons.format_italic),
                Icon(Icons.format_underline),
              ],
            ),
          ),
          
          // Original components...
          _buildSectionHeader(context, 'Other UI Components'),
          
          // 1. SnackBar (button to show)
          _buildComponentCard(
            context,
            'SnackBar',
            'SnackBar background may use colorScheme in some themes',
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'This is a SnackBar with theme-based styling',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Show SnackBar'),
            ),
          ),
          
          // 5. Current Theme Info
          _buildComponentCard(
            context,
            'Current Theme Info',
            'Details about the current theme colors',
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Primary Color: ${Theme.of(context).colorScheme.primary}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Secondary Color: ${Theme.of(context).colorScheme.secondary}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Brightness: ${Theme.of(context).brightness}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Is Material 3: ${Theme.of(context).useMaterial3}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Center(
            child: ThemeColorPickerWidget(
              availableColors: [
                Colors.blue, 
                Colors.red, 
                Colors.green, 
                Colors.purple, 
                Colors.orange,
                Colors.teal,
                Colors.brown,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildComponentCard(
    BuildContext context,
    String title,
    String description,
    Widget component,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            component,
          ],
        ),
      ),
    );
  }
}




