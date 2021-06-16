import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/components/rounded_input.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/service/authService.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool showPass = false;
  bool loading = false;
  String messagesLogin = '';
  final TextEditingController userIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode _userIdFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Theme(
        data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: SafeArea(
          child: InkWell(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: SvgPicture.asset(
                      'assets/splash.svg',
                      height: screenSize.height * 0.35,
                    ),
                  ),
                  Column(
                    children: [
                      buildInputID(context),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 20.0),
                        child: buildInputPassword(context),
                      ),
                    ],
                  ),
                  RoundedButton(
                    loading: loading,
                    title: 'Đăng nhập',
                    function: () {
                      _loginFunc();
                    },
                    backgroundColor: kPrimaryColor,
                    screenSize: screenSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: InkWell(
                      onTap: () {
                        _showMaterialDialog('', 'Liên hệ Trinh đẹp trai nhé!');
                      },
                      child: Text('Không có tài khoản?'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildInputPassword(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColorWithOpacity,
        borderRadius: BorderRadius.circular(29),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.white),
        child: TextField(
          focusNode: _passwordFocusNode,
          controller: passwordController,
          obscureText: !showPass,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock),
            hintText: 'Mật khẩu',
            border: InputBorder.none,
            suffixIcon: InkWell(
              onTap: () {
                showPass = !showPass;
                setState(() {});
              },
              child: showPass == false
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
            ),
          ),
        ),
      ),
    );
  }

  Container buildInputID(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kPrimaryColorWithOpacity,
        borderRadius: BorderRadius.circular(29),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.white),
        child: TextField(
          focusNode: _userIdFocusNode,
          onSubmitted: (text) {
            _userIdFocusNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          controller: userIDController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person),
            hintText: 'Tài khoản',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Future<void> _loginFunc() async {
    setState(() {
      messagesLogin = null;
    });
    setState(() {
      loading = true;
    });
    try {
      // final String userID = '${userIDController.text}@6b.io';
      // final String password = '${passwordController.text}';
      final String userID = 'trinhcd@6b.io';
      final String password = '123456';
      await AuthService.login(userID, password, context);
    } catch (e) {
      print(e);
      _showMaterialDialog('Something wrong!', e.message);
      if (e.code != null) {
        setState(() => messagesLogin = 'Wrong ID or password!');
      }
    }
    setState(() => loading = false);
  }

  _showMaterialDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Đóng',
                    style: TextStyle(color: kPrimaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }
}
