import 'package:get/get.dart';

class HomeController extends GetxController {
  HomeController();
  int totalPrice = 0;
  DateTime selectedDay = DateTime.now();
  int temp = 0;
  void updatePrice(int price) {
    totalPrice += price;
    update();
  }

  void updateFocusDay(DateTime date) {
    selectedDay = date;
    update();
  }

  void reloadView() {
    temp++;
    update();
  }
}
