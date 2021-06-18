import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_statistic/constants.dart';

PreferredSize customAppBar(
    context, String title, String svgLink, Function function) {
  // final Size screenSize = MediaQuery.of(context).size;
  return PreferredSize(
    preferredSize: Size.fromHeight(60),
    child: SafeArea(
      child: Theme(
        data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  height: 35,
                  width: 5,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                ),
                Container(
                  child: Center(
                      child: Text(
                    title.toUpperCase(),
                    style: TextStyle(
                        fontSize: 25,
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                Spacer(),
                if (svgLink != null)
                  InkWell(
                    onTap: function != null ? function : null,
                    child: Container(
                      padding: EdgeInsets.all(7),
                      margin: EdgeInsets.only(right: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        svgLink,
                        height: 20,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
              ],
            ),
            Spacer(),
            Divider(
              height: 1,
            ),
          ],
        ),
      ),
    ),
  );
}
