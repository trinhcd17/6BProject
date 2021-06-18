import 'package:flutter/material.dart';
import 'package:money_statistic/components/app_bar.dart';
import 'package:money_statistic/constants.dart';

class HistoryView extends StatefulWidget {
  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Lịch sử', null, null),
      body: Container(
        color: Colors.yellow,
      ),
    );
  }
}
