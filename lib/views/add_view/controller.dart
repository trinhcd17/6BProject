import 'package:get/get.dart';

class AddController extends GetxController {
  AddController();
  DateTime dateTime = DateTime.now();
  bool loading = false;
  bool switchStatus = false;
  void changeDateTime(DateTime _dateTime) {
    dateTime = _dateTime;
    update();
  }

  void isLoading(bool status) {
    loading = status;
    update();
  }

  void changeSwitchStatus(bool status) {
    switchStatus = status;
    update();
  }
}
