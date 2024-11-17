// ignore_for_file: prefer_const_constructors

import 'package:firstwallet/users/Screens/account_screen.dart';
import 'package:firstwallet/users/Screens/crypto_screen.dart';
import 'package:firstwallet/users/Screens/send_screen.dart';
import 'package:firstwallet/users/Screens/home_screen.dart';
import 'package:firstwallet/users/Screens/wallet_screen.dart';
import 'package:firstwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserNavScreen extends StatefulWidget {
  const UserNavScreen({super.key});

  @override
  State<UserNavScreen> createState() => _UserNavScreenState();
}

class _UserNavScreenState extends State<UserNavScreen> {
  int _pageIndex = 0;
  final CurrentUser _rememberCurrentUser = Get.put(CurrentUser());

  final List<Widget> _pages = [
    HomeScreen(),
    WalletScreen(),
    CryptoScreen(),
    SendScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.grey.shade200,
            bottomNavigationBar: BottomNavigationBar(
              iconSize: 23,
              selectedFontSize: 13,
              unselectedFontSize: 11,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.shifting,
              currentIndex: _pageIndex,
              onTap: (value) {
                setState(() {
                  _pageIndex = value;
                });
              },
              elevation: null,
              unselectedItemColor: Colors.black,
              selectedItemColor: Colors.deepPurple,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'HOME',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart),
                  label: 'WALLET',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  label: 'CRYPTO',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.telegram_outlined),
                  label: 'SEND',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'ACCOUNT',
                ),
              ],
            ),
            body: _pages[_pageIndex],
          );
        });
  }
}
