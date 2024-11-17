import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network(
              height: 300,
              width: 400,
              'https://lottie.host/44cf8742-ea12-44e8-bb0a-32e36006886e/jlodMT18RL.json',
            ),
            SizedBox(height: 50),
            Text(
              'Stay Ahead of the Curve: \n Your Crypto Companion',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
