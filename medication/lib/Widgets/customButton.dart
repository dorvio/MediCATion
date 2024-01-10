import 'package:flutter/material.dart';

///custom button class
///reusable button with customized look
class CustomButton extends StatefulWidget {
  final Function onPressed;
  final String text;

  const CustomButton({
    Key? key,
    required this.onPressed,
    this.text = 'Klik',
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: const Color.fromARGB(255, 174, 199, 255),
      ),
      onPressed: () => widget.onPressed.call(),
      child: Text(
        widget.text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}