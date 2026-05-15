// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "dart:convert";

import "package:tratherwallet/api_connection/api_connection.dart";
import "package:tratherwallet/users/Screens/sendcreencomp/send_buttons.dart";
import "package:tratherwallet/users/controllers/coin_controller.dart";
import "package:tratherwallet/users/userPreferences/current_user.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:http/http.dart" as http;

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

  Future<void> _submitWithdrawal() async {
    final double? amount = double.tryParse(sendAmount);
    final double balance =
        double.tryParse(currentUser.user.user_balance) ?? 0;

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }
    if (amount > balance) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount exceeds your balance')),
      );
      return;
    }

    try {
      var res = await http.post(Uri.parse(API.withdrawalRequest), body: {
        'user_id': currentUser.user.user_id.toString(),
        'amount': sendAmount,
        'wallet_address': walletController.text.trim(),
      });

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        if (body['success'] == true) {
          Get.back(); // close bottom sheet
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Withdrawal Submitted',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
              ),
              content: Text(
                'Your request is under review. Check Withdrawal History in your profile for status updates.',
                style: GoogleFonts.spaceGrotesk(color: Colors.black54),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'OK',
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xFF0F766E),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(body['message'] ?? 'Submission failed')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Server error ${res.statusCode}: ${res.body.substring(0, res.body.length.clamp(0, 100))}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showBottomPanel(BuildContext context) {
    final Color primary = const Color(0xFF0F766E);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xFFF6F3EE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Recipient Wallet Address',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: walletController,
                      autofocus: true,
                      validator: (val) =>
                          val == "" ? "Please enter wallet address" : null,
                      style: GoogleFonts.spaceGrotesk(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g. 1A2b3C4d5E6f...',
                        hintStyle: GoogleFonts.spaceGrotesk(
                          color: Colors.black38,
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Color(0xFF0F766E),
                          size: 20,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _submitWithdrawal();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: const Icon(Icons.send, size: 18),
                        label: Text(
                          'Send Crypto',
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
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
