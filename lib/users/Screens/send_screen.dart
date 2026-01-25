// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:tratherwallet/users/Screens/sendcreencomp/send_buttons.dart";
import "package:tratherwallet/users/controllers/coin_controller.dart";
import "package:tratherwallet/users/userPreferences/current_user.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final CurrentUser currentUser = Get.put(CurrentUser());
  final CoinController controller = Get.put(CoinController());

  var formKey = GlobalKey<FormState>();

  var sendAmount = '';

  final walletController = TextEditingController();

  void _showBottomPanel(BuildContext context) {
    final Color primary = const Color(0xFF0F766E);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Color(0xFFF6F3EE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: walletController,
                    validator: (val) =>
                        val == "" ? "Please enter wallet address" : null,
                    decoration: InputDecoration(
                      hintText: 'Enter wallet address',
                      hintStyle: GoogleFonts.spaceGrotesk(
                        color: Colors.black45,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Fluttertoast.showToast(
                        msg:
                            'Please contact support to activate withdrawal function',
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG,
                        fontSize: 18,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.send, size: 18),
                  label: Text(
                    'Send Crypto',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<String> buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'DEL',
  ];
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Send Crypto',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Fast, simple, and secure transfers',
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
                          Icons.send_outlined,
                          color: primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Balance',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$ ${currentUser.user.user_balance.toString()}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Send Amount',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '\$ ${sendAmount.isEmpty ? "0" : sendAmount}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (sendAmount.isNotEmpty)
                          Obx(
                            () => controller.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : controller.coinsList.isEmpty
                                    ? Text(
                                        "BTC --",
                                        style: GoogleFonts.spaceGrotesk(
                                          fontSize: 12,
                                          color: Colors.black45,
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
                                          double dousendAmountBalance =
                                              double.tryParse(sendAmount) ?? 0;
                                          double sendEquivalent =
                                              dousendAmountBalance /
                                                  controller.coinsList[index]
                                                      .currentPrice;
                                          return Text(
                                            "BTC ${sendEquivalent.toStringAsFixed(10)}",
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 12,
                                              color: Colors.black45,
                                            ),
                                          );
                                        }),
                          ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: sendAmount.isEmpty
                                ? null
                                : () {
                                    _showBottomPanel(context);
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              'Enter wallet address',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 16,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: GridView.builder(
                      itemCount: buttons.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 1.65,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final bool isDelete = index == buttons.length - 1;
                        return SendButtons(
                          buttonTapped: () {
                            setState(() {
                              if (isDelete) {
                                sendAmount = '';
                              } else {
                                sendAmount += buttons[index];
                              }
                            });
                          },
                          buttonText: buttons[index],
                          color: surface,
                          textColor: isDelete ? Colors.redAccent : primary,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
