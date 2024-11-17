// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firstwallet/users/authentication/login.dart';
import 'package:firstwallet/users/userPreferences/current_user.dart';
import 'package:firstwallet/users/userPreferences/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              leading: Icon(Icons.notifications),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text('Privacy Policy'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.keyboard_arrow_right),
              title: Text('About'),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListTile(
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
