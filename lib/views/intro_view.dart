import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:splashscreen/splashscreen.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  FirebaseUser user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    var result = FirebaseAuth.instance.currentUser;
    return new SplashScreen(
        navigateAfterSeconds: result != null ? SplashView() : SplashView(),
        seconds: 5,
        image: Image.asset('assets/splash_picture.png', fit: BoxFit.scaleDown),
        backgroundColor: Colors.white,
        photoSize: 100.0,
        onClick: () => print("flutter"),
        loaderColor: kPrimaryColor);
  }

  getUserLogin() async {
    user = await FirebaseAuth.instance.currentUser();
  }
}
