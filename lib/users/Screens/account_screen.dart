// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:tratherwallet/users/authentication/login.dart';
import 'package:tratherwallet/users/model/user_model.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:tratherwallet/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
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
    final Uri _helpUrl = Uri.parse(
        'https://widget-page.smartsupp.com/widget/a9ba59c1d96bd8cdde31ecaf60e7370a586bb2d1');

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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 4,
          ),
        ),
        actions: <Widget>[
          IconButton(
            tooltip: 'Logout',
            color: Colors.white,
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOutUser();
            },
          )
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.deepPurple,
                  backgroundImage: null,
                  child: Text(
                    currentUser.user.user_firstname[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentUser.user.user_email.toString(),
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${currentUser.user.user_firstname} ${currentUser.user.user_lastname}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Divider(
              color: Colors.grey,
              thickness: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () async {
                if (!await launchUrl(_url)) {
                  throw Exception('Could not launch $_url');
                }
              },
              leading: Icon(Icons.notifications),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text('Privacy Policy'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () async {
                if (!await launchUrl(_aboutUrl)) {
                  throw Exception('Could not launch $_aboutUrl');
                }
              },
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text('About'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () async {
                if (!await launchUrl(_helpUrl)) {
                  throw Exception('Could not launch $_helpUrl');
                }
              },
              leading: Icon(Icons.chat),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text('Help Center'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () {
                deleteAccount();
              },
              leading: Icon(Icons.delete),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              onTap: () {
                signOutUser();
              },
              leading: Icon(Icons.logout),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
