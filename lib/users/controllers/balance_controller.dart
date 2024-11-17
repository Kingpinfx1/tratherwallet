import 'package:get/get.dart';

class BalanceController extends GetxController {
  RxBool showBalance = true.obs;

  void toggleBalanceVisibility() {
    showBalance.value = !showBalance.value;
  }
}
