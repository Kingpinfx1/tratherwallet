import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

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
              'https://lottie.host/274b0e4b-f414-4b8a-8118-2bba42299afe/u293TQjWrP.json',
            ),
            SizedBox(height: 50),
            Text(
              'Your Gateway to \n the Future of Finance: \n Start Exploring Crypto Today',
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
