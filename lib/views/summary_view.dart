import 'package:flutter/material.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SummaryView extends StatefulWidget {
  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          'Tổng kết',
          style: TextStyle(color: kPrimaryColor),
        ),
        elevation: 1,
      ),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}
