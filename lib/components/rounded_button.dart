import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function function;
  final bool loading;
  final Size screenSize;
  final Color backgroundColor;
  final Color textColor;
  const RoundedButton({
    Key key,
    @required this.title,
    @required this.function,
    @required this.loading,
    this.screenSize,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: 50,
        width: screenSize.width - 40,
        decoration: BoxDecoration(
          color: backgroundColor == null
              ? Color.fromRGBO(91, 103, 202, 100)
              : backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                  strokeWidth: 2.5,
                ),
              )
            : Center(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor == null ? Colors.white : textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      ),
    );
  }
}
