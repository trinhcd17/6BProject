import 'package:flutter/material.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          'Tài khoản',
          style: TextStyle(color: kPrimaryColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: InkWell(
              onTap: () {
                AuthService.signOut();
                pushNewScreen(context, screen: SplashView(), withNavBar: false);
              },
              child: Icon(
                Icons.exit_to_app_outlined,
                color: kPrimaryColor,
                size: 28,
              ),
            ),
          )
        ],
        elevation: 1,
      ),
      body: Container(
        color: Colors.pink,
      ),
    );
  }
}
