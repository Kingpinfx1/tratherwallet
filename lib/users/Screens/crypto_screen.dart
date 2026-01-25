// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:tratherwallet/users/controllers/coin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CryptoScreen extends StatelessWidget {
  final CoinController controller = Get.put(CoinController());

  CryptoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color surface = const Color(0xFFF6F3EE);
    final Color primary = const Color(0xFF0F766E);
    final Color accent = const Color(0xFFF59E0B);

    return Scaffold(
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crypto Market',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Track the top assets in real time',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : controller.coinsList.isEmpty
                              ? Center(
                                  child: Text(
                                    "Market data unavailable",
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: controller.coinsList.length < 20
                                      ? controller.coinsList.length
                                      : 20,
                                  itemBuilder: (context, index) {
                                    final coin = controller.coinsList[index];
                                    final bool isPositive =
                                        coin.priceChangePercentage24H >= 0;
                                    return Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.06),
                                            blurRadius: 12,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 52,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                  color: surface,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.network(
                                                    coin.image,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coin.name,
                                                    style: GoogleFonts
                                                        .spaceGrotesk(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    coin.symbol.toUpperCase(),
                                                    style: GoogleFonts
                                                        .spaceGrotesk(
                                                      fontSize: 12,
                                                      color: Colors.black45,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "\$ ${coin.currentPrice}",
                                                style:
                                                    GoogleFonts.spaceGrotesk(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: isPositive
                                                      ? primary.withOpacity(0.15)
                                                      : const Color(0xFFEF4444)
                                                          .withOpacity(0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  "${coin.priceChangePercentage24H.toStringAsFixed(2)}%",
                                                  style:
                                                      GoogleFonts.spaceGrotesk(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: isPositive
                                                        ? primary
                                                        : const Color(
                                                            0xFFEF4444),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
