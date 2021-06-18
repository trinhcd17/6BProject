import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/authService.dart';

class UserService {
  UserService();
  static final _fireStore = Firestore.instance;
  static final String _collection = 'Users';
  static var res = {
    "data": [],
    "error": "",
  };
  static Future getUserInfo() async {
    res['error'] = '';
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

  static Future getAllUsers() async {
    res['error'] = '';
    listUsers = [];
    try {
      var data = await _fireStore.collection(_collection).getDocuments();
      if (data.documents.length <= 0) {
        res["error"] = 'No user available!';
      } else {
        data.documents.forEach((element) {
          User user = User.fromJson(element.data);
          if (!listUsers.contains(user)) {
            listUsers.add(user);
          }
        });
      }
    } catch (e) {
      print(e);
      res["error"] = e.message;
    }
    return res;
  }

  static Future getDisplayNameByUID(String uid) async {
    res['error'] = '';
    listUsers = [];
    try {
      var data = await _fireStore.collection(_collection).document(uid).get();
      if (data.exists) {
        res['data'] = data.data['displayName'];
      } else {
        res["error"] = "User not found!";
      }
    } catch (e) {
      print(e);
      res["error"] = e.message;
    }
    return res;
  }

  static Future getListUserActive() async {
    var listUser = await _fireStore
        .collection(_collection)
        .where('active', isEqualTo: true)
        .getDocuments();
    return listUser.documents;
  }
}
