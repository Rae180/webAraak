import 'package:flutter/material.dart';
import '../../../../utils/shared_manager.dart';
import 'add_branch_details_screen.dart';



class SelectBranchManagerScreen extends StatefulWidget {
  const SelectBranchManagerScreen({super.key});

  @override
  State<SelectBranchManagerScreen> createState() => _SelectBranchManagerScreenState();
}

class _SelectBranchManagerScreenState extends State<SelectBranchManagerScreen> {
  List<Map<String, dynamic>> managers = [];

  @override
  void initState() {
    super.initState();
    _loadManagers();
  }

  Future<void> _loadManagers() async {
    final loaded = await SharedManager.loadManagers();
    setState(() {
      managers = loaded;
    });
  }

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
          final managerName = manager['name'] ?? 'بدون اسم';
          return ListTile(
            title: Text(managerName),
            onTap: () async {
              final newBranch = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddBranchDetailsScreen(
                    selectedManager: managerName,
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
