import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_statistic/components/app_bar.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/service/storage_service.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/service/user_service.dart';
import 'package:money_statistic/views/login_view.dart';
import 'package:money_statistic/views/profile_view/controller.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  ProfileController _profileController = Get.put(ProfileController());
  File image;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final String avatarDefault = 'assets/images/avatar_default.png';
    final String avatarDemo = 'assets/images/spider_man.jpeg';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          customAppBar(context, 'Tài khoản', 'assets/icons/exit_icon2.svg', () {
        signOutFunction(context);
      }),
      body: FutureBuilder(
          future: UserService.getUserInfo(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GetBuilder<ProfileController>(builder: (_) {
                  return buildHeader(screenSize, avatarDefault, snapshot, _);
                }),
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
            StreamBuilder(
                stream: TransactionService.getMonthPriceCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var total = 0;
                    for (var item in snapshot.data.documents) {
                      total += item['price'];
                    }
                    return buildItem('Tháng này:', '$total đ');
                  } else {
                    return buildItem('Tháng này:', '0 đ');
                  }
                }),
            FutureBuilder(
                future: TransactionService.getTotalPriceCurrentUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return buildItem(
                        'Tổng cộng:', '${snapshot.data['data']} đ');
                  } else {
                    return buildItem('Tổng cộng:', '0 đ');
                  }
                }),
            Spacer(),
            RoundedButton(
              title: 'Đổi mật khẩu',
              function: () async {
                await TransactionService.getTotalPriceCurrentUser();
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

  Container buildHeader(Size screenSize, String avatarDemo,
      AsyncSnapshot snapshot, ProfileController _) {
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
          buildAvatar(avatarDemo, _),
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

  Widget buildAvatar(String avatarDemo, ProfileController _) {
    return Stack(
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
            child: currentU.photoURL != null || currentU.photoURL == ''
                ? FutureBuilder(
                    future: StorageService.getAvatar(currentU.photoURL),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(snapshot.data),
                          radius: 60.0,
                        );
                      }
                      return CircleAvatar(
                        radius: 60.0,
                        backgroundColor: Colors.grey.shade400,
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                            kPrimaryColor,
                          ),
                        ),
                      );
                    })
                : CircleAvatar(
                    backgroundImage: AssetImage(avatarDemo),
                    radius: 60.0,
                  ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 5,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 150,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 5,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              getImageCamera();
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: Icon(Icons.camera_alt),
                                ),
                                Text(
                                  'Camera',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              getImageGallery();
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade300),
                                  child: Icon(Icons.image),
                                ),
                                Text(
                                  'Thư viện ảnh',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              height: 28,
              width: 28,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1.0)),
              child: Icon(
                Icons.camera_alt,
                size: 16,
              ),
            ),
          ),
        ),
      ],
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
              signOutFunction(context);
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

  void signOutFunction(BuildContext context) {
    AuthService.signOut();
    pushNewScreen(context, screen: LoginView(), withNavBar: false);
  }

  getImageGallery() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      int now = DateTime.now().millisecondsSinceEpoch;
      String fileName = "${now}_${image.path.split('/').last}";
      await StorageService.uploadImage(image, fileName);
    } else {
      print('No image selected.');
    }
    _profileController.reloadView();
  }

  getImageCamera() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      int now = DateTime.now().millisecondsSinceEpoch;
      String fileName = "${now}_${image.path.split('/').last}";
      await StorageService.uploadImage(image, fileName);
    } else {
      print('No image selected.');
    }
    _profileController.reloadView();
  }
}
