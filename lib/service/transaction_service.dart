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
          .setData({'default': 123});
      var addItem = await _fireStore
          .collection(_collection)
          .document(date)
          .collection(AuthService.uid)
          .add(transaction.toJson());
      await _fireStore
          .collection(_collection)
          .document(date)
          .collection(AuthService.uid)
          .document(addItem.documentID)
          .updateData({'id': addItem.documentID});
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
        data.add(
          Transactions(
            title: item['title'],
            dateTime: item['dateTime'],
            price: item['price'],
            special: item['special'],
            userSpecial: item['userSpecial'],
            id: item['id'],
          ),
        );
      }
    }
    var result = {'data': data, 'totalPrice': total};
    return result;
  }

  static Stream<QuerySnapshot> getMonthPriceByUID() {
    DateTime currentTime = DateTime.now();

    String selectedMonth = currentTime.month < 10
        ? '0${currentTime.month}${currentTime.year}'
        : '${currentTime.month}${currentTime.year}';
    var res = _fireStore
        .collection(_collection)
        .document(selectedMonth)
        .collection(AuthService.uid)
        .snapshots();
    return res;
  }

  static Future getTotalPriceByUID() async {
    int result = 0;
    var listDocs = await _fireStore.collection(_collection).getDocuments();
    for (var item in listDocs.documents) {
      var data = await _fireStore
          .collection(_collection)
          .document(item.documentID)
          .collection(currentU.uid)
          .getDocuments();

      if (data.documents.length >= 0) {
        var userTrans = data.documents;
        for (var trans in userTrans) {
          result += trans.data['price'];
        }
      } else {
        result = 0;
      }
    }
    var res = {'data': result};
    return res;
  }

  static Future updateTransaction(Transactions transactions) async {
    int total = 0;
    var res = false;
    String error = '';
    try {
      DateTime selectedDay =
          DateTime.fromMillisecondsSinceEpoch(transactions.dateTime);
      String selectedMonth = selectedDay.month < 10
          ? '0${selectedDay.month}${selectedDay.year}'
          : '${selectedDay.month}${selectedDay.year}';
      await _fireStore
          .collection(_collection)
          .document(selectedMonth)
          .collection(AuthService.uid)
          .document(transactions.id)
          .updateData(transactions.toJson())
          .whenComplete(() {
        res = true;
      });
    } catch (e) {
      error = e.message;
    }
    var result = {'data': res, 'totalPrice': total, 'error': error};
    return result;
  }

  static Future removeTransaction(Transactions transactions) async {
    DateTime selectedDay =
        DateTime.fromMillisecondsSinceEpoch(transactions.dateTime);
    String selectedMonth = selectedDay.month < 10
        ? '0${selectedDay.month}${selectedDay.year}'
        : '${selectedDay.month}${selectedDay.year}';
    int total = 0;
    var res = false;
    await _fireStore
        .collection(_collection)
        .document(selectedMonth)
        .collection(AuthService.uid)
        .document(transactions.id)
        .delete()
        .whenComplete(() {
      res = true;
    });

    var result = {'data': res, 'totalPrice': total};
    return result;
  }
}
