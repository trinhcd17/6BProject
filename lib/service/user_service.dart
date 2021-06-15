import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/authService.dart';

class UserService {
  UserService();
  static final _fireStore = Firestore.instance;
  static final String _collection = 'Users';

  static Future getUserInfo() async {
    var res = {
      "data": [],
      "error": "",
    };
    try {
      var data = await _fireStore
          .collection(_collection)
          .document(AuthService.uid)
          .get();
      if (data.exists) {
        currentU = User.fromJson(data.data);
      } else {
        res["error"] = "User not found!";
      }
      return false;
    } catch (e) {
      print(e);
      res["error"] = e.message;
    }
    return res;
  }
}
