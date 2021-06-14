import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/views/login_view.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'assets/splash.svg',
                height: screenSize.height * 0.45,
              ),
            ),
            Text(
              'Home Money',
              style: TextStyle(
                  color: Color.fromRGBO(91, 103, 202, 1),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            Text('Quản lý chi tiêu cho gia đình của bạn'),
            RoundedButton(
                loading: false,
                title: 'Đăng nhập',
                function: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginView()));
                }),
          ],
        ),
      ),
    );
  }
}
