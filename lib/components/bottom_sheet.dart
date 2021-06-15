import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomSheet extends StatefulWidget {
  final bool reverse;
  const CustomBottomSheet({Key key, this.reverse}) : super(key: key);

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  final BottomSheetController _bottomSheetController =
      Get.put(BottomSheetController());
  List<dynamic> selectedItem = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: GetBuilder<BottomSheetController>(builder: (_) {
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
                        color: Colors.grey.shade700,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return buildItem(_, index);
                  }),
            ),
          ],
        );
      }),
    ));
  }

  ListTile buildItem(BottomSheetController _, index) {
    return ListTile(
      title: Text('Person $index'),
      trailing: GestureDetector(
        onTap: () {},
        child: Checkbox(
          value: _.checkBoxStatus,
        ),
      ),
    );
  }
}

class BottomSheetController extends GetxController {
  BottomSheetController();
  bool checkBoxStatus = false;

  void changeCheckBox(bool status) {
    checkBoxStatus = status;
    update();
  }
}
