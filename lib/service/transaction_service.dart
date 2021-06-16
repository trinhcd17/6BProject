import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_statistic/models/transaction.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/authService.dart';

class TransactionService {
  static final _fireStore = Firestore.instance;
  static final String _collection = 'Transactions';

  static Future addTransaction(String title, DateTime dateTime, int price,
      bool special, List<User> selectUsers) async {
    List userSpecial = [];

    try {
      var date = dateTime.month < 10
          ? '0${dateTime.month}${dateTime.year}'
          : '${dateTime.month}${dateTime.year}';
      if (special && selectUsers.isNotEmpty) {
        selectUsers.forEach((element) {
          userSpecial.add(element.uid);
        });
      }
      Transactions transaction = Transactions(
          title: title,
          dateTime: dateTime.millisecondsSinceEpoch,
          price: price,
          uid: AuthService.uid,
          special: special,
          userSpecial: special == true ? userSpecial : []);

      await _fireStore
          .collection(_collection)
          .document(date)
          .collection(AuthService.uid)
          .add(transaction.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future getTransactionByUID(DateTime selectedDay) async {
    String selectedMonth = selectedDay.month < 10
        ? '0${selectedDay.month}${selectedDay.year}'
        : '${selectedDay.month}${selectedDay.year}';
    int total = 0;
    List<Transactions> data = [];
    DateTime timeOfTransaction, currentTime = DateTime.now();
    var res = await _fireStore
        .collection(_collection)
        .document(selectedMonth)
        .collection(AuthService.uid)
        .getDocuments();
    for (var item in res.documents) {
      timeOfTransaction = DateTime.fromMillisecondsSinceEpoch(item['dateTime']);
      if (timeOfTransaction.year == selectedDay.year &&
          timeOfTransaction.month == selectedDay.month &&
          timeOfTransaction.day == selectedDay.day) {
        total += item['price'];
        data.add(Transactions(
            title: item['title'],
            dateTime: item['dateTime'],
            price: item['price'],
            special: item['special'],
            userSpecial: item['userSpecial']));
      }
    }
    var result = {'data': data, 'totalPrice': total};
    return result;
  }
}
