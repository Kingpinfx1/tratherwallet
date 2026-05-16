// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:tratherwallet/admin/admin_login.dart';
import 'package:tratherwallet/admin/admin_preferences.dart';
import 'package:tratherwallet/admin/admin_screens/allusers.dart';
import 'package:tratherwallet/admin/admin_screens/withdrawal_requests.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  static const Color bg = Color(0xFF0F172A);
  static const Color surface = Color(0xFF1E293B);
  static const Color teal = Color(0xFF0F766E);
  static const Color border = Color(0xFF334155);

  Widget _card({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: teal.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: teal, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
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
          'Admin Panel',
          style: GoogleFonts.spaceGrotesk(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: bg,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: teal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.admin_panel_settings,
                      color: Colors.white, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome Admin',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.white70),
              title: Text('Users',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white)),
              onTap: () => Get.to(() => AdminGetAllUsers()),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Colors.white70),
              title: Text('Withdrawals',
                  style: GoogleFonts.spaceGrotesk(color: Colors.white)),
              onTap: () => Get.to(() => AdminWithdrawalRequests()),
            ),
            const Divider(color: Color(0xFF334155)),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout',
                  style: GoogleFonts.spaceGrotesk(color: Colors.red)),
              onTap: () async {
                await AdminPrefs.removeAdminToken();
                Get.to(() => AdminLogin());
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Access',
              style: GoogleFonts.spaceGrotesk(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _card(
                  icon: Icons.person,
                  label: 'Users',
                  onTap: () => Get.to(() => AdminGetAllUsers()),
                ),
                _card(
                  icon: Icons.swap_horiz,
                  label: 'Withdrawals',
                  onTap: () => Get.to(() => AdminWithdrawalRequests()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
