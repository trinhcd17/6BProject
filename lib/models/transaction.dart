import 'dart:convert';

Transactions transactionFromJson(String str) =>
    Transactions.fromJson(json.decode(str));

String transactionToJson(Transactions data) => json.encode(data.toJson());

class Transactions {
  Transactions({
    this.title,
    this.dateTime,
    this.price,
    this.uid,
    this.special,
    this.userSpecial,
  });

  String title;
  int dateTime;
  int price;
  String uid;
  bool special;
  List<dynamic> userSpecial;

  factory Transactions.fromJson(Map<String, dynamic> json) => Transactions(
        title: json["title"],
        dateTime: json["dateTime"],
        price: json["price"],
        uid: json["uid"],
        special: json["special"] == null ? false : json["special"],
        userSpecial: json["userSpecial"] == null
            ? []
            : List<dynamic>.from(json["userSpecial"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "dateTime": dateTime,
        "price": price,
        "uid": uid,
        "special": special == null ? false : special,
        "userSpecial": userSpecial == null
            ? []
            : List<dynamic>.from(userSpecial.map((x) => x)),
      };
}

class UserSpecial {
  UserSpecial({
    this.name,
    this.uid,
  });

  String name;
  String uid;

  factory UserSpecial.fromJson(Map<String, dynamic> json) => UserSpecial(
        name: json["name"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
      };
}
