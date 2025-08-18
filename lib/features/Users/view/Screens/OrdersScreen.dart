import 'package:flutter/material.dart';

import '../widgets/OrderModel.dart';

class OrdersScreen extends StatelessWidget {
  final String userName;

  OrdersScreen({required this.userName});

  // بيانات وهمية للطلبات
  final List<OrderModel> orders = [
    OrderModel(id: '', title: 'طقم كنب', status: 'جاهز'),
    OrderModel(id: '', title: 'طاولة سفرة', status: 'قيد التوصيل'),
    OrderModel(id: '', title: 'سرير', status: 'تم التوصيل'),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'جاهز':
        return Colors.green;
      case 'قيد التوصيل':
        return Colors.orange;
      case 'تم التوصيل':
        return Colors.blue;
      case 'ملغى':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('طلبات $userName'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(order.id),
            ),
            title: Text(order.title),
            subtitle: Text(order.status),
            trailing: Icon(Icons.circle, color: _getStatusColor(order.status)),
          );
        },
      ),
    );
  }
}
