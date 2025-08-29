import 'package:flutter/material.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Dashboard/view/Screens/DashboardScreen.dart';
import 'package:start/features/Reports/view/Screens/ReportsScreen.dart';
import 'package:start/features/Resources/view/Screens/AddItemScreen.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/ResourcesScreen.dart';
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';
import 'package:start/features/Settings/View/Screens/SettingsScreen.dart';
import 'package:start/features/SubGallery/view/Screens/SubGalleriesScreen.dart';
import 'package:start/features/Users/view/Screens/UsersScreen.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home_page';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isExpanded = true;

  static List<Widget> _screens = [
    DashboardScreen(),
    ResourcesScreen(),
    SubGalleriesScreen(),
    UsersScreen(),
    ReportsScreen(),
  ];

  static const List<String> _titles = [
    'Dashboard',
    'Resources',
    'Sub-Galleries',
    'Users',
    'Reports'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Custom Sidebar
          Container(
            width: _isExpanded ? 200 : 72,
            color: Colors.grey[100],
            child: Column(
              children: [
                // Header
                _isExpanded
                    ? Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.photo_library, size: 28),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Gallery Manager',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.menu_open, size: 20),
                              onPressed: () =>
                                  setState(() => _isExpanded = !_isExpanded),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () =>
                              setState(() => _isExpanded = !_isExpanded),
                        ),
                      ),
                const Divider(height: 1),

                // Menu Items
                Expanded(
                  child: ListView(
                    children: [
                      _buildSidebarItem(Icons.dashboard, 'Dashboard', 0),
                      _buildSidebarItem(Icons.photo_library, 'Resources', 1),
                      _buildSidebarItem(Icons.business, 'Sub-Galleries', 2),
                      _buildSidebarItem(Icons.people, 'Users', 3),
                      _buildSidebarItem(Icons.report, 'Reports', 4),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),

          // Main content
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[700]),
            if (_isExpanded) ...[
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey[700],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showAddResourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Resource'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text('Add New Item'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AddItemScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.room),
              title: const Text('Add New Room'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AddRoomScreen.routeName);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.room),
              title: const Text('Add New Model'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, UploadGlbScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
