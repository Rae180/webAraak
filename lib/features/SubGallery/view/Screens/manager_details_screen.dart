import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'AddManagerScreen.dart';

class ManagerDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> manager;
  final Function(Map<String, dynamic>) onUpdate;
  final Function() onDelete;

  const ManagerDetailsScreen({
    super.key,
    required this.manager,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ManagerDetailsScreen> createState() => _ManagerDetailsScreenState();
}

class _ManagerDetailsScreenState extends State<ManagerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المدير'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editManager,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey[200],
                backgroundImage: widget.manager['imagePath'] != null
                    ? FileImage(File(widget.manager['imagePath']))
                    : null,
                child: widget.manager['imagePath'] == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailItem('الاسم الكامل', widget.manager['name']),
            _buildDetailItem('رقم الهاتف', widget.manager['phone'] ?? 'غير محدد'),
            _buildDetailItem('البريد الإلكتروني', widget.manager['email'] ?? 'غير محدد'),
            _buildDetailItem('العنوان', widget.manager['address'] ?? 'غير محدد'),
            const Spacer(),
            ElevatedButton(
              onPressed: _confirmDelete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('حذف المدير'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _editManager() async {
    final updatedManager = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => AddManagerScreen(existingManager: widget.manager),
      ),
    );

    if (updatedManager != null) {
      widget.onUpdate(updatedManager);
      setState(() {});
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المدير؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              widget.onDelete();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}