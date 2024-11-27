// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:firstwallet/admin/admin_home.dart';
import 'package:firstwallet/api_connection/api_connection.dart';
import 'package:flutter/material.dart';
import 'package:firstwallet/users/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditUsersScreen extends StatefulWidget {
  final User eachUserData;

  const EditUsersScreen({super.key, required this.eachUserData});

  @override
  _EditUsersScreenState createState() => _EditUsersScreenState();
}

class _EditUsersScreenState extends State<EditUsersScreen> {
  late TextEditingController _balanceController;
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    _balanceController =
        TextEditingController(text: widget.eachUserData.user_balance);
    // Initialize controllers for other fields as needed
  }

  @override
  void dispose() {
    // Dispose controllers
    _balanceController.dispose();
    // Dispose controllers for other fields as needed
    super.dispose();
  }

  Future<String> updateUser(User user) async {
    try {
      var res = await http.post(Uri.parse(API.updateUser), body: {
        'user_id': user.user_id.toString(),
        'user_balance': _balanceController.text.toString(),
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: Text('Edit User ${widget.eachUserData.user_lastname}'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _balanceController,
            decoration: InputDecoration(
              labelText: 'Balance',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              updateUser(widget.eachUserData);

              Get.to(() => AdminHome());
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.pressed)) {
                    // return the color when pressed
                    return Colors.deepPurple;
                  }
                  // return the default color
                  return Colors.deepPurple;
                },
              ),
            ),
            child: Text(
              'Save Changes',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
