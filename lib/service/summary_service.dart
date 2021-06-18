import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/service/user_service.dart';

class SummaryService {
  static final _fireStore = Firestore.instance;
  static final String _collection = 'Summary';

  static Future getSummary() async {
    var hasData;
    var data;
    try {
      var summary =
          await _fireStore.collection(_collection).document('062021').get();
      if (summary.exists) {
        hasData = true;
        data = summary.data;
      } else {
        hasData = false;
      }
    } catch (e) {
      print(e);
    }
    var result = {
      'hasData': hasData,
      'data': data,
    };
    return result;
  }

  static Future createSummary(String dateTime) async {
    var error = '';
    try {
      var listUser = await UserService.getListUserActive();
      List<String> listUID = [];
      int payOut = 0;
      bool done = false;
      Map<String, dynamic> summary = {};
      int total = 0;
      List<int> listPayOut = [];
      for (var user in listUser) {
        payOut = await TransactionService.getMonthPriceByUID(user['uid']);
        listPayOut.add(payOut);
        total += payOut;
      }
      for (var i = 0; i < listUser.length; i++) {
        payOut = listPayOut[i];
        listUID.add(listUser[i]['uid']);
        summary.putIfAbsent(
            listUser[i]['uid'],
            () => {
                  'displayName': '${listUser[i]['displayName']}',
                  'done': done,
                  'payIn': (total / listUser.length - payOut).toInt(),
                  'payOut': payOut,
                });
      }

      summary.putIfAbsent('users', () => listUID);
      await _fireStore
          .collection(_collection)
          .document(dateTime)
          .setData(Map<String, dynamic>.from(summary));
    } catch (e) {
      error = e.message;
    }
    return error;
  }

  static Future removeSummary(String date) async {
    await _fireStore.collection(_collection).document(date).delete();
  }
}
