import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          const SizedBox(height: 8),
          _buildSettingTile(
            icon: Icons.brightness_6,
            title: 'تغيير الثيم',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.language,
            title: 'تغيير اللغة',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.group,
            title: 'الموظفون',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.local_shipping,
            title: 'الطلبات الحالية',
            onTap: () {},
          ),
          _buildSettingTile(
            icon: Icons.logout,
            title: 'تسجيل الخروج',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
