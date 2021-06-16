import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  int totalPrice = 0;
  DateTime selectedDay = DateTime.now();
  void updatePrice(int price) {
    totalPrice += price;
    update();
  }

  void updateFocusDay(DateTime date) {
    selectedDay = date;
    update();
  }
}
