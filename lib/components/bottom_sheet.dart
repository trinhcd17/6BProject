import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/user.dart';
import 'package:money_statistic/service/user_service.dart';

class CustomBottomSheet extends StatefulWidget {
  final bool reverse;
  const CustomBottomSheet({Key key, this.reverse}) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final BottomSheetController _bottomSheetController =
      Get.put(BottomSheetController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedUsers = [];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: FutureBuilder(
          future: UserService.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
            } else {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    kPrimaryColor,
                  ),
                ),
              );
            }
            return GetBuilder<BottomSheetController>(builder: (_) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: EdgeInsets.all(3),
                            height: 30,
                            child: Icon(
                              Icons.clear,
                              color: kPrimaryColor,
                            ),
                            decoration: BoxDecoration(
                              color: kPrimaryColorWithOpacity,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: listUsers.length,
                        itemBuilder: (context, index) {
                          return buildItem(_, index);
                        }),
                  ),
                ],
              );
            });
          }),
    ));
  }

  Widget buildItem(BottomSheetController _, index) {
    return ListTile(
      title: Text(listUsers[index].displayName),
      trailing: GestureDetector(
        onTap: () {
          _.selectItem(listUsers[index]);
        },
        child: Icon(
          selectedUsers.contains(listUsers[index])
              ? Icons.check_box
              : Icons.check_box_outline_blank,
          color: kPrimaryColor,
        ),
      ),
    );
  }
}

class BottomSheetController extends GetxController {
  BottomSheetController();

  void selectItem(User user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
    update();
  }
}
