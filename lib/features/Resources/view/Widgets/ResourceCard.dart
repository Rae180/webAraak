import 'package:flutter/material.dart';
import 'package:start/features/Resources/view/Screens/AddRoomScreen.dart';
import 'package:start/features/Resources/view/Screens/EditItemScreen.dart';
import 'package:start/features/Resources/view/Screens/EditRoomScreen.dart';

class ResourceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final IconData icon;
  final Color? color;

  const ResourceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onEdit,
    required this.onDelete,
    this.icon = Icons.photo,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon/Thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color ?? Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color ?? Theme.of(context).primaryColor),
            ),
            const SizedBox(width: 16),

            // Title and description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Action buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                  tooltip: 'Delete',
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
    _loadData();
  }

  Future<void> _loadData() async {
    // In a real app, you would fetch this from an API
    setState(() {
      items = [
        {
          'id': '1',
          'name': 'Modern Sofa',
          'description': '3-seater leather sofa',
          'price': 499.99,
          'category': 'Furniture'
        },
        {
          'id': '2',
          'name': 'Coffee Table',
          'description': 'Wooden coffee table',
          'price': 199.99,
          'category': 'Furniture'
        },
      ];

      rooms = [
        {
          'id': 'r1',
          'name': 'Living Room',
          'description': 'Modern living room setup',
          'price': 2999.99,
          'colors': [Colors.white.value, Colors.black.value],
          'items': ['1', '2']
        },
        {
          'id': 'r2',
          'name': 'Bedroom',
          'description': 'Cozy bedroom design',
          'price': 2599.99,
          'colors': [Colors.blue.value, Colors.grey.value],
          'items': ['1']
        },
      ];
    });
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
              onDelete: () => _deleteItem(index),
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
              onDelete: () => _deleteRoom(index),
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
    ).then((_) => _loadData()); // Refresh data after editing
  }

  void _deleteItem(int index) {
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
                const SnackBar(content: Text('Item deleted')),
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
    ).then((_) => _loadData()); // Refresh data after editing
  }

  void _deleteRoom(int index) {
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
                const SnackBar(content: Text('Room deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
