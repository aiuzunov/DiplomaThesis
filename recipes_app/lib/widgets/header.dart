import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  double size;
  final String text;
  final Color color;
  Header(
      {Key? key, this.size = 25, required this.text, this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color, fontSize: size, fontWeight: FontWeight.bold));
  }
}
