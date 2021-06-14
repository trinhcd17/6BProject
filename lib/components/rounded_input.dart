import 'package:flutter/material.dart';

class RoundedInput extends StatefulWidget {
  final bool isPassword;
  const RoundedInput({
    Key key,
    this.isPassword,
  }) : super(key: key);

  @override
  _RoundedInputState createState() => _RoundedInputState();
}

class _RoundedInputState extends State<RoundedInput> {
  bool showPass = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(91, 103, 202, 150),
        borderRadius: BorderRadius.circular(29),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.white),
        child: TextField(
          obscureText: widget.isPassword == true ? !showPass : false,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: widget.isPassword == true
                ? Icon(Icons.lock)
                : Icon(Icons.person),
            hintText: widget.isPassword == true ? 'Mật khẩu' : 'Tài khoản',
            border: InputBorder.none,
            suffixIcon: widget.isPassword == true
                ? InkWell(
                    onTap: () {
                      showPass = !showPass;
                      setState(() {});
                    },
                    child: showPass == false
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
