// ignore_for_file: prefer_const_constructors

import 'package:tratherwallet/users/Screens/account_screen.dart';
import 'package:tratherwallet/users/Screens/crypto_screen.dart';
import 'package:tratherwallet/users/Screens/learn_screen.dart';
import 'package:tratherwallet/users/Screens/home_screen.dart';
import 'package:tratherwallet/users/Screens/wallet_screen.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
    LearnScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final Color surface = const Color(0xFFF6F3EE);
    final Color primary = const Color(0xFF0F766E);
    return GetBuilder(
        init: CurrentUser(),
        initState: (currentState) {
          _rememberCurrentUser.getUserInfo();
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: surface,
            extendBody: true,
            bottomNavigationBar: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BottomNavigationBar(
                      iconSize: 22,
                      selectedFontSize: 12,
                      unselectedFontSize: 11,
                      showUnselectedLabels: true,
                      type: BottomNavigationBarType.fixed,
                      currentIndex: _pageIndex,
                      onTap: (value) {
                        setState(() {
                          _pageIndex = value;
                        });
                      },
                      backgroundColor: Colors.white,
                      selectedItemColor: primary,
                      unselectedItemColor: Colors.black54,
                      selectedLabelStyle: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                      unselectedLabelStyle: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
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
                          icon: Icon(Icons.menu_book_outlined),
                          label: 'LEARN',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.person),
                          label: 'ACCOUNT',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: _pages[_pageIndex],
          );
        });
  }
}
