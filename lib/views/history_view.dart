import 'package:flutter/material.dart';
import 'package:money_statistic/constants.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Lịch sử',
          style: TextStyle(color: kPrimaryColor),
        ),
        elevation: 1,
      ),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
