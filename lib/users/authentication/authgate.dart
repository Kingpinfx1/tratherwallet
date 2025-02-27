import 'package:tratherwallet/users/Screens/nav_screen.dart';
import 'package:tratherwallet/users/authentication/login.dart';
import 'package:tratherwallet/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RememberUserPrefs.readUserInfo(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.data == null) {
          return LoginScreen();
        } else {
          return UserNavScreen();
        }
      },
    );
  }
}
