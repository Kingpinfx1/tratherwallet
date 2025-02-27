// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:tratherwallet/api_connection/api_connection.dart';
import 'package:tratherwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class EditPaymentScreen extends StatefulWidget {
  final PaymentMethods eachPaymentMethod;

  const EditPaymentScreen({super.key, required this.eachPaymentMethod});

  @override
  _EditPaymentScreenState createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  late TextEditingController _walletController;
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data
    _walletController =
        TextEditingController(text: widget.eachPaymentMethod.description);
    // Initialize controllers for other fields as needed
  }

  @override
  void dispose() {
    // Dispose controllers
    _walletController.dispose();
    // Dispose controllers for other fields as needed
    super.dispose();
  }

  Future<String> updateWallet(PaymentMethods paymentMethods) async {
    try {
      var res = await http.post(Uri.parse(API.updateWallet), body: {
        'id': paymentMethods.id.toString(),
        'description': _walletController.text.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyOfUpdate = jsonDecode(res.body);

        if (resBodyOfUpdate['success'] == true) {
          Fluttertoast.showToast(
            msg: "Wallet updated",
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
        title: Text('Edit  ${widget.eachPaymentMethod.name}'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          TextFormField(
            controller: _walletController,
            decoration: InputDecoration(
              labelText: 'Wallet Address',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              updateWallet(widget.eachPaymentMethod);
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
