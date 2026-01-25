// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:tratherwallet/users/Screens/paymentscreens/btc.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/eth.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/doge.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_any_logo/flutter_logo.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletScreen extends StatelessWidget {
  final CurrentUser currentUser = Get.put(CurrentUser());

  WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Color surface = const Color(0xFFF6F3EE);
    final Color primary = const Color(0xFF0F766E);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: surface,
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF7EFE3),
                      Color(0xFFE9F5F2),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -40,
              right: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -40,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Wallets',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your crypto balances',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TabBar(
                      indicator: BoxDecoration(
                        color: primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      labelColor: primary,
                      unselectedLabelColor: Colors.black54,
                      labelStyle: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      tabs: [
                        Tab(
                          child: AnyLogo.crypto.bitcoin.image(),
                        ),
                        Tab(
                          child: AnyLogo.crypto.ethereum.image(),
                        ),
                        Tab(
                          child: AnyLogo.crypto.dogecoin.image(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: screenSize.height * 0.58,
                      child: TabBarView(
                        children: [
                          BtcScreen(),
                          EthScreen(),
                          DogeScreen(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
