import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_statistic/views/root_app.dart';

class AuthService {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static var currentUserFBA = FirebaseAuth.instance.currentUser();
  static final _firestore = Firestore.instance;
  static String uid;

  static login(String userID, String password, context) async {
    var userCredential = await AuthService.auth
        .signInWithEmailAndPassword(email: userID, password: password);
    if (userCredential.user != null) {
      getUserData();
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => RootApp()),
        (Route<dynamic> route) => false,
      );
    }
  }

  static getUserData() async {
    FirebaseUser user = await currentUserFBA;
    uid = user.uid;
  }

  static signOut() async {
    await auth.signOut();
  }
}
