import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.displayName,
    this.uid,
    this.role,
    this.username,
    this.active,
  });

  String displayName;
  String uid;
  String role;
  String username;
  bool active;

  factory User.fromJson(Map<String, dynamic> json) => User(
        displayName: json["displayName"],
        uid: json["uid"],
        role: json["role"],
        username: json["username"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "uid": uid,
        "role": role,
        "username": username,
        "active": active,
      };
}

User currentU;
List<User> listUsers = [];
List<User> selectedUsers = [];
