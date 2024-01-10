import 'package:flutter/material.dart';

///custom header class
///reusable header with customized look
class HeaderText extends StatelessWidget {
  final String text;

  const HeaderText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
