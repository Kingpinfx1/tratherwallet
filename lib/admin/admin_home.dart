// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:tratherwallet/admin/admin_login.dart';
import 'package:tratherwallet/admin/admin_screens/allusers.dart';
import 'package:tratherwallet/admin/admin_screens/deposit_methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Text(
                      'Welcome Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Users'),
                  onTap: () {
                    Get.to(() => AdminGetAllUsers());
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.currency_bitcoin),
                //   title: Text('Manage buy links'),
                //   onTap: () {},
                // ),
                ListTile(
                  leading: Icon(Icons.currency_bitcoin),
                  title: Text('Deposit methods'),
                  onTap: () {
                    Get.to(() => DepositMethods());
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    Get.to(() => AdminLogin());
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //All users

                  GestureDetector(
                    onTap: () {
                      Get.to(() => AdminGetAllUsers());
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color: Colors.grey.shade500,
                                spreadRadius: 1,
                                blurRadius: 2)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.person,
                                color: Colors.grey.shade500,
                              )),
                          const SizedBox(height: 8),
                          Text(
                            'Users',
                          ),
                        ],
                      ),
                    ),
                  ),

                  //manage buy crypto links
                  // Container(
                  //   height: 100,
                  //   width: 100,
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey.shade200,
                  //       borderRadius: BorderRadius.circular(10),
                  //       boxShadow: [
                  //         BoxShadow(
                  //             offset: const Offset(0, 2),
                  //             color: Colors.grey.shade500,
                  //             spreadRadius: 1,
                  //             blurRadius: 2)
                  //       ]),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //           padding: const EdgeInsets.all(10),
                  //           decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             shape: BoxShape.circle,
                  //           ),
                  //           child: Icon(
                  //             CupertinoIcons.bitcoin,
                  //             color: Colors.grey.shade500,
                  //           )),
                  //       const SizedBox(height: 8),
                  //       Text(
                  //         'Manage links',
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  //Manage deposits
                  GestureDetector(
                    onTap: () {
                      Get.to(() => DepositMethods());
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 2),
                                color: Colors.grey.shade500,
                                spreadRadius: 1,
                                blurRadius: 2)
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.money_dollar,
                                color: Colors.grey.shade500,
                              )),
                          const SizedBox(height: 8),
                          Text(
                            'Deposits',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
