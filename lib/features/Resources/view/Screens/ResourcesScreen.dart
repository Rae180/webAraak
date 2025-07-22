import 'package:flutter/material.dart';
import 'package:start/features/Resources/view/Screens/AddItemScreen.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/EditItemScreen.dart';
import 'package:start/features/Resources/view/Screens/EditRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/UploadGlbScreen.dart';
import 'package:start/features/Resources/view/Widgets/ResourceCard.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> rooms = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMockData();
  }

  void _loadMockData() {
    // Mock items data
    items = [
      {
        'id': '1',
        'name': 'Modern Sofa',
        'description': '3-seater leather sofa with adjustable headrests',
        'price': 499.99,
        'category': 'Living Room'
      },
      {
        'id': '2',
        'name': 'Coffee Table',
        'description': 'Solid oak table with tempered glass top',
        'price': 199.99,
        'category': 'Living Room'
      },
      {
        'id': '3',
        'name': 'Floor Lamp',
        'description': 'Adjustable standing lamp with dimmer',
        'price': 89.99,
        'category': 'Lighting'
      },
    ];

    // Mock rooms data
    rooms = [
      {
        'id': 'r1',
        'name': 'Modern Living Room',
        'description': 'Contemporary design with minimalist furniture',
        'price': 2999.99,
        'colors': [0xFFFFFFFF, 0xFF000000, 0xFF5C469C],
        'items': ['1', '2', '3']
      },
      {
        'id': 'r2',
        'name': 'Cozy Bedroom',
        'description': 'Warm and inviting bedroom setup',
        'price': 2599.99,
        'colors': [0xFF5C469C, 0xFF1D2671, 0xFF0A0E21],
        'items': ['1']
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.photo)),
            Tab(icon: Icon(Icons.room)),
          ],
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildItemsList(),
              _buildRoomsList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemsList() {
    return items.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => ResourceCard(
              title: items[index]['name'] ?? 'Item $index',
              subtitle: items[index]['description'] ?? 'Description',
              onEdit: () => _editItem(context, items[index]),
              onDelete: () => _deleteItem(context, index),
              icon: Icons.chair,
              color: Colors.brown,
            ),
          );
  }

  Widget _buildRoomsList() {
    return rooms.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) => ResourceCard(
              title: rooms[index]['name'] ?? 'Room $index',
              subtitle: rooms[index]['description'] ?? 'Room description',
              onEdit: () => _editRoom(context, rooms[index]),
              onDelete: () => _deleteRoom(context, index),
              icon: Icons.room,
              color: Colors.blue,
            ),
          );
  }

  void _editItem(BuildContext context, Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditItemScreen(item: item),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          // Update the item in the list
          final index = items.indexWhere((i) => i['id'] == item['id']);
          if (index != -1) {
            items[index] = value;
          }
        });
      }
    });
  }

  void _deleteItem(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${items[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => items.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${items[index]['name']} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editRoom(BuildContext context, Map<String, dynamic> room) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditRoomScreen(room: room),
      ),
    ).then((value) {
      if (value != null) {
        setState(() {
          // Update the room in the list
          final index = rooms.indexWhere((r) => r['id'] == room['id']);
          if (index != -1) {
            rooms[index] = value;
          }
        });
      }
    });
  }

  void _deleteRoom(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete ${rooms[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => rooms.removeAt(index));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${rooms[index]['name']} deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Optional: Add button functionality
  void _addItem(BuildContext context) {
    Navigator.of(context).pushNamed(AddItemScreen.routeName).then((newItem) {
      if (newItem != null) {
       // setState(() => items.add(newItem));
      }
    });
  }

  void _addModel(BuildContext context) {
    Navigator.of(context).pushNamed(UploadGlbScreen.routeName).then((newItem) {
      if (newItem != null) {
       // setState(() => items.add(newItem));
      }
    });
  }

  void _addRoom(BuildContext context) {
    Navigator.of(context).pushNamed(AddItemScreen.routeName).then((newRoom) {
      if (newRoom != null) {
        // setState(() => rooms.add(newRoom));
      }
    });
  }
}
