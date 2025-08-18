import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:start/features/SubGallery/view/Screens/select_manager_screen.dart';
import 'dart:convert';
import 'branch_details_screen.dart';
import 'branch_managers_screen.dart';


class SubGalleryManagementScreen extends StatefulWidget {
  const SubGalleryManagementScreen({super.key});

  @override
  State<SubGalleryManagementScreen> createState() => _SubGalleryManagementScreenState();
}

class _SubGalleryManagementScreenState extends State<SubGalleryManagementScreen> {
  List<Map<String, dynamic>> branches = [];
  List<Map<String, dynamic>> managers = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final branchData = prefs.getString('branches');
    final managerData = prefs.getString('managers');

    if (branchData != null) {
      branches = List<Map<String, dynamic>>.from(json.decode(branchData));
    }
    if (managerData != null) {
      managers = List<Map<String, dynamic>>.from(json.decode(managerData));
    }
    setState(() {});
  }

  Future<void> _saveBranches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('branches', json.encode(branches));
  }

  Future<void> _saveManagers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('managers', json.encode(managers));
  }


  void _openBranchManagers() async {
    final updatedManagers = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(
        builder: (context) => BranchManagersScreen(managers: managers),
      ),
    );

    if (updatedManagers != null) {
      setState(() {
        managers = updatedManagers;
      });
      await _saveManagers();
    }
  }

  void _navigateToAddBranch() async {
    if (managers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إضافة مدير أولاً')),
      );
      return;
    }

    final newBranch = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SelectBranchManagerScreen(),
      ),
    );

    if (newBranch != null && newBranch is Map<String, dynamic>) {
      setState(() {
        branches.add(newBranch);
      });
      await _saveBranches();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة الفرع بنجاح')),
      );
    }
  }

  void _navigateToBranchDetails(Map<String, dynamic> branch, int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BranchDetailsScreen(
          branch: branch,
          onDelete: () async {
            setState(() {
              branches.removeAt(index);
            });
            await _saveBranches();
          },
          onUpdate: (updatedBranch) async {
            setState(() {
              branches[index] = updatedBranch;
            });
            await _saveBranches();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المعارض الفرعية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: _openBranchManagers,
            tooltip: 'مدراء الأفرع',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: branches.isEmpty
                  ? const Center(child: Text('لا يوجد أفرع بعد'))
                  : ListView.separated(
                itemCount: branches.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return ListTile(
                    title: Text(branch['name'] ?? ''),
                    subtitle: Text('مدير الفرع: ${branch['manager'] ?? ''}'),
                    leading: const Icon(Icons.business),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _navigateToBranchDetails(branch, index),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_business),
                label: const Text('إضافة فرع'),
                onPressed: _navigateToAddBranch,
              ),
            ),
          ],
        ),
      ),
    );
  }
}