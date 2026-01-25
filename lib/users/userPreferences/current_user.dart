import 'dart:convert';

import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/user_model.dart';
import 'package:tratherwallet/users/userPreferences/user_preferences.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CurrentUser extends GetxController {
  final Rx<User> _currentUser = User(
    user_id: 1,
    user_firstname: '',
    user_lastname: '',
    user_address: '',
    user_email: '',
    user_password: '',
    user_balance: '',
  ).obs;

  User get user => _currentUser.value;

  Future<void> getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    if (getUserInfoFromLocalStorage == null) {
      return;
    }
    _currentUser.value = getUserInfoFromLocalStorage;
    await _refreshUserInfoFromServer(getUserInfoFromLocalStorage.user_id);
  }

  Future<void> _refreshUserInfoFromServer(int userId) async {
    try {
      var res = await http.post(
        Uri.parse(API.readUserDetails),
        body: {
          'user_id': userId.toString(),
        },
      );
      if (res.statusCode != 200) {
        return;
      }
      var resBody = jsonDecode(res.body);
      if (resBody is Map<String, dynamic> && resBody['success'] == true) {
        final dynamic userData = resBody['userData'];
        Map<String, dynamic>? userMap;
        if (userData is List && userData.isNotEmpty) {
          userMap = userData.first as Map<String, dynamic>;
        } else if (userData is Map<String, dynamic>) {
          userMap = userData;
        }
        if (userMap != null) {
          User updatedUser = User.fromJson(userMap);
          _currentUser.value = updatedUser;
          await RememberUserPrefs.storeUserInfo(updatedUser);
        }
      }
    } catch (_) {}
  }
}
