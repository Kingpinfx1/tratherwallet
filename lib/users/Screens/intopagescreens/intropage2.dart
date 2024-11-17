import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

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
              'https://lottie.host/ebb4f65e-1810-4f73-8dfd-26ed205eaf7f/dqvfjfgTj6.json',
            ),
            SizedBox(height: 50),
            Text(
              'Unlock the World  of \n Crypto currency with Ease',
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
