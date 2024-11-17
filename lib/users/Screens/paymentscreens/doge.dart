// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:firstwallet/api_connection/api_connection.dart';
import 'package:firstwallet/users/model/payment_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class DogeScreen extends StatelessWidget {
  const DogeScreen({super.key});

  Future<List<PaymentMethods>> getAllPaymentMethods() async {
    List<PaymentMethods> allPaymentMethods = [];

    try {
      var res = await http.get(Uri.parse(API.readAllWallets));

      if (res.statusCode == 200) {
        var resBodyOfPaymentMethods = jsonDecode(res.body);

        if (resBodyOfPaymentMethods['success'] == true) {
          for (var eachPaymentMethod
              in (resBodyOfPaymentMethods['paymentMethods'] as List)) {
            allPaymentMethods.add(PaymentMethods.fromJson(eachPaymentMethod));
          }
        }
      } else {
        Fluttertoast.showToast(msg: "Status Code is not 200");
      }
    } catch (errorMsg) {
      Fluttertoast.showToast(msg: "Error:: $errorMsg");
    }

    return allPaymentMethods;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FutureBuilder(
          future: getAllPaymentMethods(),
          builder: (context, AsyncSnapshot<List<PaymentMethods>> dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (dataSnapShot.data == null) {
              return const Center(
                child: Text(
                  "No Payment Method found",
                ),
              );
            }
            if (dataSnapShot.data!.isNotEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 150),
                  // itemCount: dataSnapShot.data!.length,
                  itemCount: 1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    //instance of items from model

                    PaymentMethods eachPaymentMethod = dataSnapShot.data![2];

                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          ClipRRect(
                            child: FadeInImage(
                              height: 300,
                              width: 300,
                              placeholder:
                                  const AssetImage('lib/images/doge.png'),
                              image: NetworkImage(
                                eachPaymentMethod.image,
                              ),
                              imageErrorBuilder:
                                  (context, error, stackTraceError) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                  ),
                                );
                              },
                            ),
                          ),
                          Text(
                            eachPaymentMethod.name.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          SelectableText(
                            eachPaymentMethod.description.toString(),
                            style: TextStyle(
                              fontSize: 17,
                            ),
                          ),
                          // TextButton(
                          //   onPressed: null,
                          //   child: Text(
                          //     'Copy wallet',
                          //     style: TextStyle(
                          //       color: Colors.deepPurple,
                          //     ),
                          //   ),
                          // ),
                        ],
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
    );
  }
}
