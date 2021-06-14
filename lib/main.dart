import 'package:flutter/material.dart';
import 'package:money_statistic/views/intro_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: IntroScreen(),
  ));
}
