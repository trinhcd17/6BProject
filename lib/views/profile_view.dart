import 'package:flutter/material.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/service/user_service.dart';
import 'package:money_statistic/views/login_view.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final String avatarDefault = 'assets/images/avatar_default.png';
    final String avatarDemo = 'assets/images/spider_man.jpeg';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: FutureBuilder(
          future: UserService.getUserInfo(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildHeader(screenSize, avatarDemo, snapshot),
                buildBody(snapshot, screenSize),
              ],
            );
          }),
    );
  }

  Expanded buildBody(AsyncSnapshot snapshot, Size screenSize) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            buildItem('Tài khoản:',
                snapshot.hasData ? currentU.username : 'username'),
            buildItem('Tháng này:', '200000000 đ'),
            buildItem('Tổng cộng:', '200000000 đ'),
            Spacer(),
            RoundedButton(
              title: 'Đổi mật khẩu',
              function: () {
                UserService.getUserInfo();
              },
              loading: false,
              screenSize: screenSize,
              backgroundColor: Colors.white,
              textColor: kPrimaryColor,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeader(
      Size screenSize, String avatarDemo, AsyncSnapshot snapshot) {
    return Container(
      width: screenSize.width,
      height: screenSize.height / 3 - 20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50.0),
          bottomRight: Radius.circular(50.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.lightBlueAccent,
                    kPrimaryColorWithOpacity,
                  ]),
            ),
            child: Container(
              margin: EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(avatarDemo),
                radius: 60.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              // snapshot.hasData ? currentU.displayName : 'Loading',
              snapshot.hasData ? currentU.displayName : 'Loading',
              style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(String leading, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                child: Text(
                  leading,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(
            height: 1,
            color: Colors.white,
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }

  Widget buildInfoContainer(Size screenSize) {
    return Expanded(
      child: Container(
        height: screenSize.height,
        margin: EdgeInsets.symmetric(vertical: 80, horizontal: 40),
        decoration: BoxDecoration(
          color: kPrimaryColorWithOpacity,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
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
              pushNewScreen(context, screen: LoginView(), withNavBar: false);
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
    );
  }
}
