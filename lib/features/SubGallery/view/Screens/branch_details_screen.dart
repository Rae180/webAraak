import 'package:flutter/material.dart';
import 'edit_branch_screen.dart';

class BranchDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> branch;
  final VoidCallback onDelete;
  final Function(Map<String, dynamic>) onUpdate;

  const BranchDetailsScreen({
    super.key,
    required this.branch,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الفرع')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailItem('اسم الفرع', branch['name']),
            _buildDetailItem('الموقع', branch['location']),
            _buildDetailItem('العنوان التفصيلي', branch['address']),
            _buildDetailItem('ساعات العمل', branch['workingHours']),
            _buildDetailItem('البريد الإلكتروني', branch['email']),
            _buildDetailItem('رقم الهاتف', branch['phone']),
            _buildDetailItem('المدير', branch['manager']),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _confirmDelete(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('حذف'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final updatedBranch = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditBranchScreen(branch: branch),
                      ),
                    );
                    if (updatedBranch != null) {
                      onUpdate(updatedBranch);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('تعديل'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value ?? 'غير محدد'),
          const Divider(),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الفرع؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}