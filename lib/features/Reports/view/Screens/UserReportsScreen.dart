import 'package:flutter/material.dart';

class UserReportsScreen extends StatelessWidget {
  UserReportsScreen({super.key});

  final List<Map<String, dynamic>> userReports = [
    {
      'user': 'John Doe',
      'report': 'العنصر المفضل لا يعمل بشكل صحيح',
      'date': DateTime(2025, 7, 20, 14, 30),
      'status': 'تم الاستلام',
    },
    {
      'user': 'Sarah Ali',
      'report': 'لا أستطيع إضافة عناصر جديدة',
      'date': DateTime(2025, 7, 21, 9, 15),
      'status': 'قيد المعالجة',
    },
    {
      'user': 'Ahmed Saleh',
      'report': 'التطبيق يغلق فجأة عند التصفح',
      'date': DateTime(2025, 7, 22, 16, 45),
      'status': 'تم الحل',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('بلاغات المستخدمين')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: userReports.length,
        separatorBuilder: (context, index) => const Divider(height: 24),
        itemBuilder: (context, index) {
          final report = userReports[index];
          return Card(
            elevation: 3,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المستخدم: ${report['user']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text('البلاغ: ${report['report']}'),
                  const SizedBox(height: 8),
                  Text(
                    'التاريخ: ${report['date'].toString().substring(0, 16)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'الحالة: ${report['status']}',
                    style: TextStyle(
                      color: report['status'] == 'تم الحل'
                          ? Colors.green
                          : report['status'] == 'قيد المعالجة'
                          ? Colors.orange
                          : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
