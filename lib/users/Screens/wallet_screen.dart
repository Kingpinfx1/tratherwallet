// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:tratherwallet/users/Screens/paymentscreens/btc.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/eth.dart';
import 'package:tratherwallet/users/Screens/paymentscreens/doge.dart';
import 'package:tratherwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_any_logo/flutter_logo.dart';

class WalletScreen extends StatelessWidget {
  final CurrentUser currentUser = Get.put(CurrentUser());

  WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Text(
            'Your Wallets',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.grey.shade300,
        body: ListView(
          children: [
            TabBar(
              tabs: [
                Tab(
                  child: AnyLogo.crypto.bitcoin.image(),
                ),
                Tab(
                  child: AnyLogo.crypto.ethereum.image(),
                ),
                Tab(
                  child: AnyLogo.crypto.dogecoin.image(),
                )
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                children: [
                  BtcScreen(),
                  EthScreen(),
                  DogeScreen(),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 0),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: 200,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(0),
            //     ),
            //     child: Lottie.network(
            //       height: 200,
            //       width: 100,
            //       'https://lottie.host/df65bd10-582b-4806-aaef-7c910eed3af5/oFoBujtvhm.json',
            //     ),
            //   ),
            // ),

            //balance
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Container(
            //     height: 150,
            //     width: MediaQuery.of(context).size.width,
            //     decoration: BoxDecoration(
            //       color: Colors.deepPurple,
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.grey,
            //           spreadRadius: 5,
            //           blurRadius: 7,
            //           offset: Offset(0, 3),
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 'Available Balance',
            //                 style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 15,
            //                 ),
            //               ),
            //               // Text(
            //               //   'Transaction History  >',
            //               //   style: TextStyle(
            //               //     color: Colors.white,
            //               //     fontSize: 15,
            //               //   ),
            //               // ),
            //             ],
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.all(15.0),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Text(
            //                 "\$${currentUser.user.user_balance}",
            //                 style: TextStyle(
            //                   fontSize: 25,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               ElevatedButton(
            //                 onPressed: null,
            //                 style: ButtonStyle(
            //                   elevation: WidgetStateProperty.all(3),
            //                   backgroundColor:
            //                       WidgetStateProperty.all(Colors.white),
            //                 ),
            //                 child: Text(
            //                   'Send Crypto',
            //                   style: TextStyle(
            //                     color: Colors.deepPurple,
            //                   ),
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
