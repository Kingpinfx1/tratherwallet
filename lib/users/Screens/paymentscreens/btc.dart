// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BtcScreen extends StatelessWidget {
  const BtcScreen({super.key});

  Future<String> _getUserAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('currentUser') ?? '';
    if (raw.isEmpty) return '';
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final userId = map['user_id']?.toString() ?? '';
    if (userId.isEmpty) return '';

    final res = await http.post(
      Uri.parse(API.getUserWallets),
      body: {'user_id': userId},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      if (body['success'] == true) return body['btc'].toString();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder<String>(
          future: _getUserAddress(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(color: Color(0xFF0F766E)),
                ),
              );
            }
            final address = snapshot.data ?? '';
            if (address.isEmpty) {
              return const SizedBox(
                height: 300,
                child: Center(child: Text('Unable to load address. Try again.')),
              );
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
                child: _WalletCard(
                  coinName: 'Bitcoin (BTC)',
                  address: address,
                  accent: const Color(0xFF0F766E),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  final String coinName;
  final String address;
  final Color accent;

  const _WalletCard({
    required this.coinName,
    required this.address,
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
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: QrImageView(
                  data: address,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                coinName,
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
                  address,
                  style: GoogleFonts.spaceGrotesk(fontSize: 14, height: 1.4),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: address));
                  Fluttertoast.showToast(msg: "Copied to clipboard");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.copy, size: 16),
                label: Text(
                  'Copy Address',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
