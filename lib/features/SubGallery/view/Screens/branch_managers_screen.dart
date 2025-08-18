import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'AddManagerScreen.dart';
import 'manager_details_screen.dart';

class BranchManagersScreen extends StatefulWidget {
  final List<Map<String, dynamic>> managers;

  const BranchManagersScreen({super.key, required this.managers});

  @override
  State<BranchManagersScreen> createState() => _BranchManagersScreenState();
}

class _BranchManagersScreenState extends State<BranchManagersScreen> {
  late List<Map<String, dynamic>> _managers;

  @override
  void initState() {
    super.initState();
    _managers = List.from(widget.managers);
  }

  Future<void> _saveManagers() async {
    //بدو يحفظ (shared)
  }

  void _addManager() async {
    final newManager = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const AddManagerScreen()),
    );

    if (newManager != null && newManager.isNotEmpty) {
      setState(() {
        _managers.add(newManager);
      });
      // يمكنك إضافة _saveManagers() هنا إذا كنت تريد الحفظ الفوري
    }
  }

  void _editManager(int index) async {
    final updatedManager = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => AddManagerScreen(existingManager: _managers[index]),
      ),
    );

    if (updatedManager != null) {
      setState(() {
        _managers[index] = updatedManager;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مدراء الأفرع'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _managers),
        ),
      ),
      body: _managers.isEmpty
          ? const Center(child: Text('لا يوجد مدراء حالياً'))
          : ListView.builder(
        itemCount: _managers.length,
        itemBuilder: (context, index) => Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: _managers[index]['imagePath'] != null
                  ? FileImage(File(_managers[index]['imagePath']))
                  : null,
              child: _managers[index]['imagePath'] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(_managers[index]['name']),
            subtitle: Text(_managers[index]['phone'] ?? ''),
            onTap: () => _showManagerDetails(index),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addManager,
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showManagerDetails(int index) async {
    final shouldUpdate = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => ManagerDetailsScreen(
          manager: _managers[index],
          onUpdate: (updatedManager) {
            setState(() {
              _managers[index] = updatedManager;
            });
          },
          onDelete: () {
            setState(() {
              _managers.removeAt(index);
            });
          },
        ),
      ),
    );

    if (shouldUpdate == true) {
      setState(() {});
    }
  }
}