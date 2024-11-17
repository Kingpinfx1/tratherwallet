// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firstwallet/users/Screens/crypto_screen.dart';
import 'package:firstwallet/users/Screens/send_screen.dart';
import 'package:firstwallet/users/Screens/wallet_screen.dart';
import 'package:firstwallet/users/controllers/balance_controller.dart';
import 'package:firstwallet/users/controllers/coin_controller.dart';
import 'package:firstwallet/users/userPreferences/current_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BalanceController balanceController = Get.put(BalanceController());

  final CurrentUser currentUser = Get.put(CurrentUser());

  final CoinController controller = Get.put(CoinController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 10),
                      Text(
                        'Hi',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${currentUser.user.user_firstname} ${currentUser.user.user_lastname}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Icon(Icons.help_outline),
                        SizedBox(width: 10),
                        // Icon(Icons.notifications_none_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 180,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Available Balance',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Transaction History  >',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(
                            () => balanceController.showBalance.value
                                ? Text(
                                    "\$ ${currentUser.user.user_balance}",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    '🙈🙈🙈🙈',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                                  ),
                          ),
                          GestureDetector(
                            onTap: () {
                              balanceController.toggleBalanceVisibility();
                            },
                            child: Icon(
                              Icons.visibility_off,
                              color: Colors.white38,
                              size: 15,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => WalletScreen());
                            },
                            style: ButtonStyle(
                              elevation: WidgetStateProperty.all(3),
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.white),
                            ),
                            child: Text(
                              'Wallet',
                              style: TextStyle(
                                color: Colors.deepPurple,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    //btc equivalent
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Obx(
                        () => controller.isLoading.value
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: null,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  String currentAmount =
                                      currentUser.user.user_balance;
                                  double douBalance =
                                      double.parse(currentAmount);
                                  double amountEquivalent = douBalance /
                                      controller.coinsList[index].currentPrice;
                                  return Text(
                                    "BTC ${amountEquivalent.toStringAsFixed(10)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  );
                                }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            /// three buttons
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SendScreen());
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade400,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Send',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //crypto screen button
                  GestureDetector(
                    onTap: () {
                      Get.to(() => CryptoScreen());
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade400,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                              child: Icon(
                                Icons.show_chart,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Crypto',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => WalletScreen());
                    },
                    child: Container(
                      height: 60,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade400,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                              child: Icon(
                                Icons.insert_chart,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Receive',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(25, 5, 25, 1),
              child: Obx(
                () => controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: null,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade400,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              offset: Offset(4, 4),
                                              blurRadius: 5,
                                            )
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Image.network(controller
                                              .coinsList[index].image),
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.coinsList[index].name,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "${controller.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)} %",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "\$ ${controller.coinsList[index].currentPrice}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        controller.coinsList[index].symbol
                                            .toUpperCase(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
