import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String title;
  final Function function;
  final bool loading;

  const RoundedButton({
    Key key,
    @required this.title,
    @required this.function,
    @required this.loading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromRGBO(91, 103, 202, 100),
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
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
      ),
    );
  }
}
