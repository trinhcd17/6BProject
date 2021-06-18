import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_statistic/components/app_bar.dart';
import 'package:money_statistic/components/rounded_button.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/service/summary_service.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/service/user_service.dart';
import 'package:money_statistic/views/splash.dart';
import 'package:money_statistic/views/summary_view/controller.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:toast/toast.dart';

class SummaryView extends StatefulWidget {
  @override
  _SummaryViewState createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final SummaryController summaryController = Get.put(SummaryController());
  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double headerHeight = 40.0;

    return Scaffold(
      appBar: customAppBar(context, 'Tổng kết', null, null),
      body: Theme(
        data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: GetBuilder<SummaryController>(builder: (_) {
          return FutureBuilder(
              future: SummaryService.getSummary(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['hasData']) {
                    var listUser = snapshot.data['data']['users'];
                    var data = snapshot.data['data'];
                    return Column(
                      children: [
                        Container(
                          width: screenSize.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                offset: Offset(1, 1),
                                spreadRadius: 1,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 20.0),
                          child: Column(
                            children: [
                              buildHeaderRow(headerHeight),
                              for (var user in listUser)
                                buildInsideRow(headerHeight, data['$user']),
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RoundedButtonHalfSize(
                                title: 'Lưu',
                                function: () async {},
                                loading: false,
                                screenSize: screenSize,
                                backgroundColor: kPrimaryColor,
                              ),
                              RoundedButtonHalfSize(
                                title: 'Xoá',
                                function: () async {
                                  await SummaryService.removeSummary(
                                      _.selectedMonth);
                                  _.reloadView();
                                },
                                loading: _.loading,
                                screenSize: screenSize,
                                backgroundColor: Colors.red,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Chưa có tổng kết'),
                          SizedBox(
                            height: 50,
                          ),
                          RoundedButton(
                            title: 'Tạo tổng kết',
                            function: () async {
                              _.isLoading(true);
                              DateTime date = DateTime.now();
                              _.updateMonth(date);

                              var result = await SummaryService.createSummary(
                                  _.selectedMonth);
                              if (result == '') {
                                _.reloadView();
                                _.isLoading(false);
                              } else {
                                showToast('Có lỗi: $result');
                                _.isLoading(false);
                              }
                            },
                            loading: _.loading,
                            screenSize: screenSize,
                            backgroundColor: kPrimaryColor,
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                        kPrimaryColor,
                      ),
                      strokeWidth: 2.5,
                    ),
                  );
                }
              });
        }),
      ),
    );
  }

  Column buildInsideRow(double headerHeight, user) {
    return Column(
      children: [
        Row(
          children: [
            buildInsideItem(
              headerHeight: headerHeight,
              flex: 3,
              child: Text(
                user['displayName'],
                overflow: TextOverflow.ellipsis,
              ),
            ),
            buildInsideItem(
              headerHeight: headerHeight,
              flex: 2,
              child: Text(
                '${user['payOut']} đ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                ),
              ),
            ),
            buildInsideItem(
              headerHeight: headerHeight,
              flex: 2,
              child: Text(
                '${user['payIn']} đ',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                ),
              ),
            ),
            buildInsideItem(
              headerHeight: headerHeight,
              flex: 2,
              child: Icon(
                user['done'] ? Icons.check_box : Icons.check_box_outline_blank,
                color: kPrimaryColor,
              ),
            ),
          ],
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Column buildHeaderRow(double headerHeight) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildHeaderItem(headerHeight, 3, 'Tên'),
            buildHeaderItem(headerHeight, 2, 'Đã chi'),
            buildHeaderItem(headerHeight, 2, 'Phải đóng'),
            buildHeaderItem(headerHeight, 2, 'Xác nhận'),
          ],
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.black,
        ),
      ],
    );
  }

  Flexible buildHeaderItem(double headerHeight, int flex, String title) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Container(
        height: headerHeight,
        child: Center(
            child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    );
  }

  Flexible buildInsideItem({double headerHeight, int flex, Widget child}) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
        ),
        height: headerHeight,
        child: Center(
          child: child,
        ),
      ),
    );
  }

  void showToast(String message) {
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }
}
