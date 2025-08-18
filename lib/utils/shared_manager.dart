import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  static const String _managersKey = 'managers';

  // حفظ المدراء
  static Future<void> saveManagers(List<Map<String, dynamic>> managers) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(managers);
    await prefs.setString(_managersKey, encoded);
  }

  // استرجاع المدراء
  static Future<List<Map<String, dynamic>>> loadManagers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_managersKey);
    if (encoded == null) return [];
    final List<dynamic> decoded = jsonDecode(encoded);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }


  static Future<void> clearManagers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_managersKey);
  }
}
