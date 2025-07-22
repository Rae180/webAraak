import 'package:flutter/material.dart';
import 'package:start/features/Auth/View/Screens/LoginPage.dart';
import 'package:start/features/Dashboard/view/Screens/DashboardScreen.dart';
import 'package:start/features/Reports/view/Screens/ReportsScreen.dart';
import 'package:start/features/Resources/view/Screens/AddItemScreen.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/ResourcesScreen.dart';
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';
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

  static const List<Widget> _screens = [
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
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          NavigationRail(
            minWidth: _isExpanded ? 200 : 72,
            extended: _isExpanded,
            leading: _isExpanded 
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        const Icon(Icons.photo_library, size: 32),
                        const SizedBox(width: 12),
                        const Text('Gallery Manager', 
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.menu_open),
                          onPressed: () => setState(() => _isExpanded = !_isExpanded),
                          iconSize: 20,
                        ),
                      ],
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.photo_library),
                label: Text('Resources'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.business),
                label: Text('Sub-Galleries'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.report),
                label: Text('Reports'),
              ),
            ],
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            labelType: _isExpanded 
                ? NavigationRailLabelType.none 
                : NavigationRailLabelType.selected,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content
          Expanded(child: _screens[_selectedIndex]),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => _showAddResourceDialog(context),
              child: const Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
            )
          : null,
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () => Navigator.pushReplacementNamed(context, LoginPage.routeName),
          ),
        ],
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