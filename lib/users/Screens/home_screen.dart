// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:tratherwallet/users/Screens/crypto_screen.dart';
import 'package:tratherwallet/users/Screens/send_screen.dart';
import 'package:tratherwallet/users/Screens/wallet_screen.dart';
import 'package:tratherwallet/users/controllers/balance_controller.dart';
import 'package:tratherwallet/users/controllers/coin_controller.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalanceController balanceController = Get.put(BalanceController());

  final CurrentUser currentUser = Get.put(CurrentUser());

  final CoinController controller = Get.put(CoinController());

  @override
  void initState() {
    super.initState();
    currentUser.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Color surface = const Color(0xFFF6F3EE);
    final Color primary = const Color(0xFF0F766E);
    final Color accent = const Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: surface,
      body: SafeArea(
        child: Stack(
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
                  color: accent.withOpacity(0.12),
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
                  color: primary.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: Colors.black54,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(
                            () => Text(
                              '${currentUser.user.user_firstname} ${currentUser.user.user_lastname}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
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
                          Icons.notifications_none_outlined,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Container(
                    width: screenSize.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0F766E),
                          Color(0xFF14B8A6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available Balance',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white70,
                              fontSize: 13,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Obx(
                                    () => balanceController.showBalance.value
                                        ? Text(
                                            "\$ ${currentUser.user.user_balance}",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            '••••••',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      balanceController
                                          .toggleBalanceVisibility();
                                    },
                                    child: Icon(
                                      balanceController.showBalance.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => WalletScreen());
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primary,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Wallet',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Obx(
                            () => controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : controller.coinsList.isEmpty
                                    ? Text(
                                        "BTC --",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: null,
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          if (index >=
                                              controller.coinsList.length) {
                                            return const SizedBox.shrink();
                                          }
                                          String currentAmount =
                                              currentUser.user.user_balance;
                                          double douBalance =
                                              double.tryParse(currentAmount) ??
                                                  0;
                                          double amountEquivalent = douBalance /
                                              controller.coinsList[index]
                                                  .currentPrice;
                                          return Text(
                                            "BTC ${amountEquivalent.toStringAsFixed(5)}",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                          );
                                        }),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
            SizedBox(height: 10),

            /// three buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SendScreen());
                    },
                    child: _QuickAction(
                      label: 'Send',
                      icon: Icons.send,
                      color: primary,
                    ),
                  ),
                  //crypto screen button
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CryptoScreen());
                    },
                    child: _QuickAction(
                      label: 'Market',
                      icon: Icons.show_chart,
                      color: accent,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => WalletScreen());
                    },
                    child: _QuickAction(
                      label: 'Receive',
                      icon: Icons.south_west,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Top Movers',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '24h',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : controller.coinsList.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: null,
                            itemCount: controller.coinsList.length < 5
                                ? controller.coinsList.length
                                : 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.06),
                                              offset: const Offset(0, 6),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.network(controller
                                              .coinsList[index].image),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.coinsList[index].name,
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            "${controller.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)} %",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 13,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$ ${controller.coinsList[index].currentPrice}",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        controller.coinsList[index].symbol
                                            .toUpperCase(),
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                ),
              ),
          ]),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
