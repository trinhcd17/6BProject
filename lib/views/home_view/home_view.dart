import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_statistic/components/app_bar.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/models/transaction.dart';
import 'package:money_statistic/service/authService.dart';
import 'package:money_statistic/service/transaction_service.dart';
import 'package:money_statistic/views/add_view/add_view.dart';
import 'package:money_statistic/views/detail_view/detail_view.dart';
import 'package:money_statistic/views/home_view/controller.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CalendarController _calendarController;
  HomeController _homeController = Get.put(HomeController());
  int sum = 0;
  final textColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(context, 'Trang chủ', 'assets/icons/add.svg', () {
          navigatorToAddScreen(context);
        }),
        body: buildBody(),
      ),
    );
  }

  SafeArea buildBody() {
    return SafeArea(
      child: GetBuilder<HomeController>(builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildCalendar(_),
            buildListTransactions(_),
          ],
        );
      }),
    );
  }

  Widget buildListTransactions(HomeController _) {
    return GetBuilder<HomeController>(builder: (__) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: FutureBuilder(
                  future: TransactionService.getTransactionByUID(_.selectedDay),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Transactions> listTransactions =
                          snapshot.data['data'];
                      int total = snapshot.data['totalPrice'];
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Các khoản đã chi',
                                  style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Text(
                                  'Tổng: $total đ',
                                  style:
                                      TextStyle(color: textColor, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              for (var i = 0; i < listTransactions.length; i++)
                                buildListItem(
                                    listTransactions[i].title,
                                    listTransactions[i].price,
                                    listTransactions[i],
                                    __),
                            ],
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Các khoản đã chi',
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              Text(
                                'Tổng: 0 đ',
                                style:
                                    TextStyle(color: textColor, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      );
    });
  }

  Container buildCalendar(HomeController _) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: TableCalendar(
        calendarStyle: CalendarStyle(
            selectedColor: kPrimaryColor, todayColor: kPrimaryColorWithOpacity),
        startingDayOfWeek: StartingDayOfWeek.monday,
        initialSelectedDay: DateTime.now(),
        calendarController: _calendarController,
        initialCalendarFormat: CalendarFormat.week,
        onDaySelected: (selectedDay, focusedDay) {
          _.updateFocusDay(selectedDay);
          _calendarController.setSelectedDay(selectedDay);
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: false,
      title: Text(
        'Thống kê'.toUpperCase(),
        style: TextStyle(color: kPrimaryColor),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0),
          child: InkWell(
            onTap: () async {
              navigatorToAddScreen(context);
            },
            child: SvgPicture.asset(
              'assets/icons/add.svg',
              height: 25,
              color: kPrimaryColor,
            ),
          ),
        )
      ],
      elevation: 1,
    );
  }

  void navigatorToAddScreen(BuildContext context) {
    pushNewScreen(context, screen: AddView(), withNavBar: false).then((value) {
      _homeController.reloadView();
    });
  }

  Widget buildListItem(
      String title, int price, Transactions transactions, HomeController __) {
    return InkWell(
      onTap: () {
        pushNewScreen(context,
                screen: DetailView(
                  transactions: transactions,
                ),
                withNavBar: false)
            .then((value) {
          if (value == 'Reload') {
            __.reloadView();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        height: 60,
        decoration: BoxDecoration(
          color: kPrimaryColorWithOpacity,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: 20.0, top: 10.0, bottom: 10.0),
              width: 2,
              color: textColor,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$price đ',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _calendarController.dispose();
  }
}
