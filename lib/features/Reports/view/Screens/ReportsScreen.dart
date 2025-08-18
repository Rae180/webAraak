import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatelessWidget {
  ReportsScreen({super.key});

  final List<Map<String, dynamic>> soldItems = [
    {
      'name': 'Chair Model A',
      'quantitySold': 5,
      'unitPrice': 24.0,
      'saleDate': DateTime(2025, 7, 20),
    },
    {
      'name': 'Table Model B',
      'quantitySold': 2,
      'unitPrice': 150.0,
      'saleDate': DateTime(2025, 7, 21),
    },
    {
      'name': 'Sofa Model C',
      'quantitySold': 1,
      'unitPrice': 850.0,
      'saleDate': DateTime(2025, 7, 22),
    },
  ];

  final List<Map<String, dynamic>> inventoryItems = [
    {'name': 'Chair Model A', 'quantityAvailable': 10},
    {'name': 'Table Model B', 'quantityAvailable': 5},
    {'name': 'Sofa Model C', 'quantityAvailable': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تقارير المبيعات')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'القطع المباعة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DataTable(
              columns: const [
                DataColumn(label: Text('القطعة')),
                DataColumn(label: Text('الكمية')),
                DataColumn(label: Text('سعر الوحدة')),
                DataColumn(label: Text('سعر البيع المجمل')),
                DataColumn(label: Text('تاريخ البيع')),
              ],
              rows: soldItems.map((item) {
                final totalSale = item['quantitySold'] * item['unitPrice'];
                return DataRow(cells: [
                  DataCell(Text(item['name'])),
                  DataCell(Text(item['quantitySold'].toString())),
                  DataCell(Text('\$${item['unitPrice'].toStringAsFixed(2)}')),
                  DataCell(Text('\$${totalSale.toStringAsFixed(2)}')),
                  DataCell(Text(DateFormat('yyyy/MM/dd').format(item['saleDate']))),
                ]);
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'القطع الموجودة في المعرض',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DataTable(
              columns: const [
                DataColumn(label: Text('القطعة')),
                DataColumn(label: Text('الكمية المتوفرة')),
              ],
              rows: inventoryItems.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item['name'])),
                  DataCell(Text(item['quantityAvailable'].toString())),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
