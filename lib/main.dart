import 'package:tratherwallet/users/Screens/introscreen.dart';
import 'package:tratherwallet/users/authentication/authgate.dart';
import 'package:tratherwallet/users/controllers/balance_controller.dart';
import 'package:tratherwallet/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(BalanceController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Trather Wallet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: RememberUserPrefs.hasSeenIntro(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Scaffold(backgroundColor: Color(0xFFF7EFE3), body: SizedBox.shrink());
          return snapshot.data! ? const AuthGate() : const IntroScreen();
        },
      ),
    );
  }
}
