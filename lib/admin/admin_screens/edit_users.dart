// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:tratherwallet/admin/admin_home.dart';
import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:tratherwallet/users/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EditUsersScreen extends StatefulWidget {
  final User eachUserData;

  const EditUsersScreen({super.key, required this.eachUserData});

  @override
  _EditUsersScreenState createState() => _EditUsersScreenState();
}

class _EditUsersScreenState extends State<EditUsersScreen> {
  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  late TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _balanceController =
        TextEditingController(text: widget.eachUserData.user_balance);
  }

  @override
  void dispose() {
    _balanceController.dispose();
    super.dispose();
  }

  Future<String> updateUser(User user) async {
    final token = await AdminPrefs.getAdminToken();
    try {
      var res = await http.post(Uri.parse(API.updateUser), body: {
        'user_id': user.user_id.toString(),
        'user_balance': _balanceController.text.toString(),
        'admin_token': token,
      });

      if (res.statusCode == 200) {
        var resBodyOfUpdate = jsonDecode(res.body);

        if (resBodyOfUpdate['success'] == true) {
          Fluttertoast.showToast(
            msg: "Balance updated",
            gravity: ToastGravity.CENTER,
          );
          return "User data updated successfully";
        } else {
          Fluttertoast.showToast(msg: "Failed to update user data");
          return "Failed to update user data";
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
          'Edit ${widget.eachUserData.user_lastname}',
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
            'Balance (USD)',
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
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                prefixIcon: const Icon(Icons.attach_money,
                    color: Color(0xFF0F766E), size: 20),
                hintText: 'Enter balance',
                hintStyle: GoogleFonts.spaceGrotesk(
                    color: Colors.white38, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                updateUser(widget.eachUserData);
                Get.to(() => AdminHome());
              },
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
