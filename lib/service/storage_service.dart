import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:money_statistic/models/user.dart';

class StorageService {
  static Future<bool> uploadImage(File image, String fileName) async {
    bool status = false;
    try {
      String path = "/users/images/$fileName";
      final ref = FirebaseStorage.instance.ref().child(path);
      var upload = ref.putFile(image);
      await upload.onComplete.then((value) async {
        if (currentU.photoURL != null) {
          await FirebaseStorage.instance
              .ref()
              .child(currentU.photoURL)
              .delete()
              .whenComplete(() {
            currentU.photoURL = path;
            print("success");
          }).catchError((onError) => print(onError));
        }
        await Firestore.instance
            .collection("Users")
            .document(currentU.uid)
            .updateData({"photoURL": value.ref.path});
        status = true;
      }).catchError((onError) => status = false);
    } catch (e) {
      print("Upload avatar error: $e");
    }

    return Future<bool>.value(status);
  }

  static Future<String> getAvatar(String path) async {
    try {
      if (path == "") {
        return null;
      }
      final ref = FirebaseStorage.instance.ref().child(path);
      String url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      print(e);
    }
  }
}
