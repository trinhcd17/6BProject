import 'package:get/get.dart';

class DetailController extends GetxController {
  DetailController();
  bool isEditing = false;
  DateTime dateTime = DateTime.now();
  bool switchStatus = false;
  bool loading = false;
  List listUsers = [];

  void changeEditStatus(bool status) {
    isEditing = status;
    update();
  }

  void changeDateTime(DateTime _dateTime) {
    dateTime = _dateTime;
    update();
  }

  void changeSwitchStatus(bool status) {
    switchStatus = status;
    update();
  }

  void isLoading(bool status) {
    loading = status;
    update();
  }

  void removeUser(String uid) {
    if (listUsers.contains(uid)) {
      listUsers.remove(uid);
      if (listUsers.length <= 0) {
        changeSwitchStatus(false);
      }
    }
    update();
  }
}
