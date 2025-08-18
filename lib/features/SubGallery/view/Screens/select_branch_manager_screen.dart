import 'package:flutter/material.dart';
import 'add_branch_details_screen.dart';

class SelectBranchManagerScreen extends StatelessWidget {
  final List<Map<String, dynamic>> managers;

  const SelectBranchManagerScreen({super.key, required this.managers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('اختيار مدير الفرع')),
      body: managers.isEmpty
          ? const Center(child: Text('لا يوجد مدراء متاحين'))
          : ListView.builder(
        itemCount: managers.length,
        itemBuilder: (context, index) {
          final manager = managers[index];
          return ListTile(
            title: Text(manager['name'] ?? ''),
            onTap: () async {
              final newBranch = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBranchDetailsScreen(
                    selectedManager: manager['name'],
                  ),
                ),
              );
              if (newBranch != null) {
                Navigator.pop(context, newBranch);
              }
            },
          );
        },
      ),
    );
  }
}