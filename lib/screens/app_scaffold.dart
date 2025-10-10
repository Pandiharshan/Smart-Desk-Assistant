import 'package:flutter/material.dart';
import 'package:smart_desk_assistant_new/screens/connection_screen.dart';
import 'package:smart_desk_assistant_new/screens/settings_screen.dart';
import 'package:smart_desk_assistant_new/screens/timer_screen.dart';

/// The main scaffold of the app, which includes the bottom navigation bar
/// and manages switching between the primary screens.
class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  // A list of the screens that correspond to the navigation bar items.
  static const List<Widget> _widgetOptions = <Widget>[
    // Screen 1: The main monitor screen
    ConnectionScreen(),
    // Screen 2: The work/break timer (placeholder for now)
    TimerScreen(),
    // Screen 3: The settings screen (placeholder for now)
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body will be the currently selected screen from our list.
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_heart_outlined),
            activeIcon: Icon(Icons.monitor_heart),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Styling the navigation bar to match the app's theme.
        backgroundColor: Theme.of(context).colorScheme.background.withAlpha(200),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
