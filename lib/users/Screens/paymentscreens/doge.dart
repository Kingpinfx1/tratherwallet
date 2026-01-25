// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DogeScreen extends StatelessWidget {
  const DogeScreen({super.key});

  Future<List<PaymentMethods>> getAllPaymentMethods() async {
    List<PaymentMethods> allPaymentMethods = [];

    try {
      var res = await http.get(Uri.parse(API.readAllWallets));

      if (res.statusCode == 200) {
        var resBodyOfPaymentMethods = jsonDecode(res.body);

        if (resBodyOfPaymentMethods['success'] == true) {
          for (var eachPaymentMethod
              in (resBodyOfPaymentMethods['paymentMethods'] as List)) {
            allPaymentMethods.add(PaymentMethods.fromJson(eachPaymentMethod));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return allPaymentMethods;
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF0F766E);
    return ListView(
      children: [
        FutureBuilder(
          future: getAllPaymentMethods(),
          builder: (context, AsyncSnapshot<List<PaymentMethods>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapShot.data == null) {
              return const Center(
                child: Text(
                  "No Payment Method found",
                ),
              );
            }
            if (dataSnapShot.data!.isNotEmpty) {
              const int walletIndex = 2;
              if (dataSnapShot.data!.length <= walletIndex) {
                return Center(
                  child: Text(
                    "Wallet not available",
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                  child: _WalletCard(
                    paymentMethod: dataSnapShot.data![walletIndex],
                    placeholder: const AssetImage('lib/images/doge.png'),
                    accent: primary,
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("Empty, No Data."),
              );
            }
          },
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  final PaymentMethods paymentMethod;
  final AssetImage placeholder;
  final Color accent;

  const _WalletCard({
    required this.paymentMethod,
    required this.placeholder,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Deposit Address',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 14),
        Container(
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
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: FadeInImage(
                  height: 200,
                  width: 200,
                  placeholder: placeholder,
                  image: NetworkImage(
                    paymentMethod.image,
                  ),
                  imageErrorBuilder: (context, error, stackTraceError) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                paymentMethod.name.toString(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Wallet Address',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F3EE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SelectableText(
                  paymentMethod.description.toString(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: paymentMethod.description.toString(),
                    ),
                  );
                  Fluttertoast.showToast(msg: "Copied to clipboard");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.copy, size: 16),
                label: Text(
                  'Copy Address',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
