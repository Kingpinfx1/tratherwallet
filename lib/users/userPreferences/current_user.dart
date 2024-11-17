import 'package:firstwallet/users/model/user_model.dart';
import 'package:firstwallet/users/userPreferences/user_preferences.dart';
import 'package:get/get.dart';

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

  getUserInfo() async {
    User? getUserInfoFromLocalStorage = await RememberUserPrefs.readUserInfo();
    _currentUser.value = getUserInfoFromLocalStorage!;
  }
}
