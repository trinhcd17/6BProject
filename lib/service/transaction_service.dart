import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:money_statistic/models/transaction.dart';
import 'package:money_statistic/service/authService.dart';

class TransactionService {
  static final _fireStore = Firestore.instance;
  static final String _collection = 'Transactions';

  static Future addTransaction(
      String title, DateTime dateTime, int price) async {
    try {
      var date = dateTime.month < 10
          ? '0${dateTime.month}${dateTime.year}'
          : '${dateTime.month}${dateTime.year}';

      Transactions transaction = Transactions(
          title: title,
          dateTime: dateTime.microsecondsSinceEpoch,
          price: price,
          uid: AuthService.uid);

      await _fireStore
          .collection(_collection)
          .document(date)
          .collection(AuthService.uid)
          .add(transaction.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future getTransactionByUID(String dateTime) async {
    // var date = dateTime.month < 10
    //     ? '0${dateTime.month}${dateTime.year}'
    //     : '${dateTime.month}${dateTime.year}';
    var data = await _fireStore
        .collection(_collection)
        .document(dateTime)
        .collection(AuthService.uid)
        .getDocuments();
    return data;
  }
}
