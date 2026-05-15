// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:tratherwallet/admin/admin_home.dart';
import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/authentication/login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdminLogin extends StatelessWidget {
  AdminLogin({super.key});

  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  loginAdminNow() async {
    try {
      var res = await http.post(
        Uri.parse(API.adminLogin),
        body: {
          "admin_email": emailController.text.trim(),
          "admin_password": passwordController.text.trim(),
        },
      );

      if (res.statusCode == 200) {
        var resBodyOfLogin = jsonDecode(res.body);
        if (resBodyOfLogin['success'] == true) {
          await AdminPrefs.storeAdminToken(resBodyOfLogin['adminToken']);
          Fluttertoast.showToast(
            msg: "Admin logged in successfully.",
            gravity: ToastGravity.CENTER,
          );
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.to(() => AdminHome());
          });
        } else {
          Fluttertoast.showToast(msg: "Incorrect credentials. Please try again.");
        }
      } else {
        Fluttertoast.showToast(msg: "Connection error. Please try again.");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error: $errorMsg");
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          prefixIcon: Icon(icon, color: teal, size: 20),
          hintText: hint,
          hintStyle: GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: teal.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: teal,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Admin Panel',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to manage your platform',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildField(
                    controller: emailController,
                    hint: 'Admin email',
                    icon: Icons.email_outlined,
                    validator: (val) => val == "" ? "Please enter your email" : null,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                    validator: (val) => val == "" ? "Please enter your password" : null,
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          loginAdminNow();
                        }
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
                        'Sign In',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not an admin? ',
                        style: GoogleFonts.spaceGrotesk(color: Colors.white60),
                      ),
                      GestureDetector(
                        onTap: () => Get.to(() => LoginScreen()),
                        child: Text(
                          'Go back',
                          style: GoogleFonts.spaceGrotesk(
                            color: teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
