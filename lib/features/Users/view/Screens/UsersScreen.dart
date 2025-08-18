import 'package:flutter/material.dart';

import '../widgets/UserModel.dart';
import 'OrdersScreen.dart';


class UsersListScreen extends StatelessWidget {
  final List<UserModel> users = [
    UserModel(
      id: '1',
      name: 'أحمد محمد',
      email: 'ahmed@example.com',
      imageUrl: 'assets/profile.jpeg',
    ),
    UserModel(
      id: '2',
      name: 'ليلى خالد',
      email: 'layla@example.com',
      imageUrl: 'assets/profile.jpeg',
    ),
    UserModel(
      id: '3',
      name: 'محمد يوسف',
      email: 'mohamed@example.com',
      imageUrl: 'assets/profile.jpeg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('قائمة المستخدمين'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: (user.imageUrl != null && user.imageUrl!.isNotEmpty)
                  ? NetworkImage(user.imageUrl!)
                  : AssetImage('assets/default_user.png') as ImageProvider,
              backgroundColor: Colors.transparent, // بدون لون خلفي
            ),


            title: Text(user.name),
            subtitle: Text(user.email),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrdersScreen(userName: user.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
