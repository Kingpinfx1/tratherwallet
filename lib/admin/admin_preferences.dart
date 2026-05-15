import 'package:shared_preferences/shared_preferences.dart';

class AdminPrefs {
  static Future<void> storeAdminToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adminToken', token);
  }

  static Future<String> getAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('adminToken') ?? '';
  }

  static Future<void> removeAdminToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('adminToken');
  }
}
