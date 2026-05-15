// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditPaymentScreen extends StatefulWidget {
  final PaymentMethods eachPaymentMethod;

  const EditPaymentScreen({super.key, required this.eachPaymentMethod});

  @override
  _EditPaymentScreenState createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  late TextEditingController _walletController;

  @override
  void initState() {
    super.initState();
    _walletController =
        TextEditingController(text: widget.eachPaymentMethod.description);
  }

  @override
  void dispose() {
    _walletController.dispose();
    super.dispose();
  }

  Future<String> updateWallet(PaymentMethods paymentMethods) async {
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.updateWallet), body: {
        'id': paymentMethods.id.toString(),
        'description': _walletController.text.toString(),
        'admin_token': token,
      });

      if (res.statusCode == 200) {
        var resBodyOfUpdate = jsonDecode(res.body);

        if (resBodyOfUpdate['success'] == true) {
          Fluttertoast.showToast(
            msg: "Wallet updated",
            gravity: ToastGravity.CENTER,
          );
          return "Wallet updated successfully";
        } else {
          Fluttertoast.showToast(msg: "Failed to update wallet");
          return "Failed to update wallet";
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
        return "Failed to connect to server";
      }
    } catch (error) {
      Fluttertoast.showToast(msg: "Error: $error");
      return "An error occurred: $error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Edit ${widget.eachPaymentMethod.name}',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Wallet Address',
            style: GoogleFonts.spaceGrotesk(
              color: Colors.white60,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: border),
            ),
            child: TextFormField(
              controller: _walletController,
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: const Icon(Icons.account_balance_wallet_outlined,
                    color: Color(0xFF0F766E), size: 20),
                hintText: 'Enter wallet address',
                hintStyle: GoogleFonts.spaceGrotesk(
                    color: Colors.white38, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => updateWallet(widget.eachPaymentMethod),
              style: ElevatedButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                'Save Changes',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
