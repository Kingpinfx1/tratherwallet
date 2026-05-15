// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:tratherwallet/users/Screens/withdrawal_history.dart';
import 'package:tratherwallet/users/authentication/login.dart';
import 'package:tratherwallet/users/model/user_model.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:tratherwallet/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../../api_connection/api_connection.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  signOutUser() async {
    var resultResponse = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          "Logout",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          "Are you sure you want to logout?",
        ),
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text(
                "No",
                style: TextStyle(
                  color: Colors.deepPurple,
                ),
              )),
          TextButton(
              onPressed: () {
                Get.back(result: "loggedOut");
              },
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: Colors.red,
                ),
              )),
        ],
      ),
    );

    if (resultResponse == "loggedOut") {
      //delete-remove the user data from phone local storage
      RememberUserPrefs.removeUserInfo().then((value) {
        Get.off(() => LoginScreen());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUser currentUser = Get.put(CurrentUser());
    final Uri _url = Uri.parse('https://tratherwallet.top/privacy-policy.html');
    final Uri _aboutUrl = Uri.parse('https://tratherwallet.top');
    //final Uri _helpUrl = Uri.parse('https://tratherwallet.top');
   

    Future<String> deleteUser(User user) async {
      try {
        var res = await http.post(Uri.parse(API.deleteAccount), body: {
          'user_id': user.user_id.toString(),
        });

        if (res.statusCode == 200) {
          var resBodyOfUpdate = jsonDecode(res.body);

          if (resBodyOfUpdate['success'] == true) {
            return "User data updated successfully";
          } else {
            return "Failed to delete user";
          }
        } else {
          return "Server responded with status code ${res.statusCode}";
        }
      } catch (error) {
        return "An error occurred: $error";
      }
    }

    deleteAccount() async {
      var resultResponse = await Get.dialog(
        AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            "Delete Account?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete your account?",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back(); // Close dialog without proceeding
                },
                child: const Text(
                  "No",
                  style: TextStyle(
                    color: Colors.deepPurple,
                  ),
                )),
            TextButton(
                onPressed: () {
                  Get.back(result: "deleteConfirmed"); // Proceed to delete
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )),
          ],
        ),
      );

      if (resultResponse == "deleteConfirmed") {
        try {
          String resultMessage = await deleteUser(currentUser.user);

          // Check result message to confirm deletion success
          if (resultMessage == "User data updated successfully") {
            Fluttertoast.showToast(
              msg: "Your account has been deleted successfully.",
              gravity: ToastGravity.CENTER,
            );

            // Clear user preferences and navigate to the login screen
            await RememberUserPrefs.removeUserInfo();
            Get.off(() => LoginScreen());
          } else {
            Fluttertoast.showToast(
              msg: "Account deletion failed: $resultMessage",
              gravity: ToastGravity.CENTER,
            );
          }
        } catch (error) {
          Fluttertoast.showToast(
            msg: "An error occurred during deletion: $error",
            gravity: ToastGravity.CENTER,
          );
        }
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F3EE),
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
                color: const Color(0xFFF59E0B).withOpacity(0.12),
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
                color: const Color(0xFF0F766E).withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Manage your account details',
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
                      child: IconButton(
                        tooltip: 'Logout',
                        color: const Color(0xFF0F766E),
                        icon: const Icon(Icons.logout),
                        onPressed: () {
                          signOutUser();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: const Color(0xFF0F766E),
                        backgroundImage: null,
                        child: Text(
                          currentUser.user.user_firstname[0].toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentUser.user.user_email.toString(),
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${currentUser.user.user_firstname} ${currentUser.user.user_lastname}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.history,
                        title: 'Withdrawal History',
                        onTap: () => Get.to(() => const WithdrawalHistoryScreen()),
                      ),
                      _SettingsTile(
                        icon: Icons.notifications,
                        title: 'Privacy Policy',
                        onTap: () async {
                          if (!await launchUrl(_url)) {
                            throw Exception('Could not launch $_url');
                          }
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.settings,
                        title: 'About',
                        onTap: () async {
                          if (!await launchUrl(_aboutUrl)) {
                            throw Exception('Could not launch $_aboutUrl');
                          }
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.chat,
                        title: 'Help Center',
                        onTap: () async {
                          if (!await launchUrl(_aboutUrl)) {
                            throw Exception('Could not launch $_aboutUrl');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _SettingsTile(
                        icon: Icons.delete,
                        title: 'Delete Account',
                        titleColor: const Color(0xFFEF4444),
                        onTap: () {
                          deleteAccount();
                        },
                      ),
                      _SettingsTile(
                        icon: Icons.logout,
                        title: 'Logout',
                        titleColor: const Color(0xFFEF4444),
                        onTap: () {
                          signOutUser();
                        },
                      ),
                    ],
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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color? titleColor;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3EE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF0F766E),
        ),
      ),
      trailing: const Icon(Icons.keyboard_arrow_right),
      title: Text(
        title,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.black87,
        ),
      ),
    );
  }
}
