import 'package:get/get.dart';

class SummaryController extends GetxController {
  bool loading = false;
  String selectedMonth = '';

  void isLoading(bool status) {
    loading = status;
    update();
  }

  void updateMonth(DateTime date) {
    selectedMonth = date.month < 10
        ? '0${date.month}${date.year}'
        : '${date.month}${date.year}';
    update();
  }

  void reloadView() {
    update();
  }
}
