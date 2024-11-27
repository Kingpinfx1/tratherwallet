// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import "package:firstwallet/users/Screens/sendcreencomp/send_buttons.dart";
import "package:firstwallet/users/controllers/coin_controller.dart";
import "package:firstwallet/users/userPreferences/current_user.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:get/get.dart";

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final CurrentUser currentUser = Get.put(CurrentUser());
  final CoinController controller = Get.put(CoinController());

  var formKey = GlobalKey<FormState>();

  var sendAmount = '';

  final walletController = TextEditingController();

  void _showBottomPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade300,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextFormField(
                    controller: walletController,
                    validator: (val) =>
                        val == "" ? "Please enter wallet address" : null,
                    decoration: InputDecoration(
                      hintText: 'Enter wallet address',
                      hintStyle: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Fluttertoast.showToast(
                        msg:
                            'Please contact support to activate withdrawal function',
                        gravity: ToastGravity.CENTER,
                        toastLength: Toast.LENGTH_LONG,
                        fontSize: 20,
                      );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                    Colors.grey.shade200,
                  )),
                  child: Text(
                    'Send Crypto',
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final List<String> buttons = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '.',
    '0',
    'DEL',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Send Crypto'),
        backgroundColor: Colors.grey.shade300,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                    '\$ ${currentUser.user.user_balance.toString()} Current Balance'),
                Text(
                  '\$ $sendAmount',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                if (sendAmount.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 120,
                    ),
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
                                double dousendAmountBalance =
                                    double.parse(sendAmount);
                                double sendEquivalent = dousendAmountBalance /
                                    controller.coinsList[index].currentPrice;
                                return Text(
                                  "BTC ${sendEquivalent.toStringAsFixed(10)}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.deepPurple,
                                  ),
                                );
                              }),
                    ),
                  ),
                if (sendAmount.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _showBottomPanel(context);
                    },
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                      Colors.grey.shade200,
                    )),
                    child: Text(
                      'Click to enter wallet address',
                      style: TextStyle(
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (BuildContext context, int index) {
                  if (index == buttons.length - 1) {
                    return SendButtons(
                      buttonTapped: () {
                        setState(() {
                          sendAmount = '';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.grey.shade300,
                      textColor: Colors.deepPurple,
                    );
                  } else {
                    return SendButtons(
                      buttonTapped: () {
                        setState(() {
                          sendAmount += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.grey.shade300,
                      textColor: Colors.deepPurple,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
