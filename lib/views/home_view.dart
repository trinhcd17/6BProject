import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_statistic/constants.dart';
import 'package:money_statistic/views/add_view/add_view.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  CalendarController _calendarController;
  int sum = 0;
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: false,
          title: Text(
            'Thống kê',
            style: TextStyle(color: kPrimaryColor),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: InkWell(
                onTap: () {
                  pushNewScreen(context, screen: AddView(), withNavBar: false);
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
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                child: TableCalendar(
                  calendarController: _calendarController,
                  initialCalendarFormat: CalendarFormat.week,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Các khoản đã chi',
                      style: TextStyle(
                          color: kPrimaryColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tổng: $sum đ',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        buildListItem(),
                        buildListItem(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildListItem() {
    return Container(
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
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
            width: 2,
            color: kPrimaryColor,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mua quần áo',
                  style: TextStyle(
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '50.000 đ',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ],
            ),
          ),
        ],
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
