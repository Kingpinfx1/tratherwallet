// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'dart:convert';

import 'package:firstwallet/admin/admin_screens/edit_users.dart';
import 'package:firstwallet/api_connection/api_connection.dart';
import 'package:firstwallet/users/model/user_model.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class AdminGetAllUsers extends StatefulWidget {
  const AdminGetAllUsers({super.key});

  @override
  State<AdminGetAllUsers> createState() => _AdminGetAllUsersState();
}

class _AdminGetAllUsersState extends State<AdminGetAllUsers> {
  //Get all users function
  Future<List<User>> getAllUsers() async {
    List<User> allUsersList = [];

    try {
      var res = await http.post(Uri.parse(API.readAllUsers));

      if (res.statusCode == 200) {
        var resBodyOfAllUsers = jsonDecode(res.body);

        if (resBodyOfAllUsers['success'] == true) {
          for (var eachUserData
              in (resBodyOfAllUsers['allUsersData'] as List)) {
            allUsersList.add(User.fromJson(eachUserData));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return allUsersList;
  }

  Future<String> deleteUser(User user) async {
    try {
      var res = await http.post(Uri.parse(API.deleteUser), body: {
        'user_id': user.user_id.toString(),
      });

      if (res.statusCode == 200) {
        var resBodyOfUpdate = jsonDecode(res.body);

        if (resBodyOfUpdate['success'] == true) {
          Fluttertoast.showToast(
            msg: "User deleted",
            gravity: ToastGravity.CENTER,
          );
          return "User data updated successfully";
        } else {
          Fluttertoast.showToast(msg: "Failed to delete user ");
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
      ),
      body: ListView(
        children: [
          FutureBuilder(
            future: getAllUsers(),
            builder: (context, AsyncSnapshot<List<User>> dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (dataSnapShot.data == null) {
                return const Center(
                  child: Text(
                    "No User found",
                  ),
                );
              }
              if (dataSnapShot.data!.isNotEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    padding: EdgeInsets.only(bottom: 150),
                    itemCount: dataSnapShot.data!.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      //instance of items from model

                      User eachUserData = dataSnapShot.data![index];

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 16 : 8,
                          2,
                          index == dataSnapShot.data!.length - 1 ? 16 : 8,
                          2,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.shade100,
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 3,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // ID and Email/name column
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        eachUserData.user_id.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            eachUserData.user_email.toString(),
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            eachUserData.user_firstname
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Delete and edit row
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          deleteUser(eachUserData);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade300,
                                        ),
                                      ),
                                      // const SizedBox(width: 2),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditUsersScreen(
                                                eachUserData: eachUserData,
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.black38,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text("Empty, No Data."),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
