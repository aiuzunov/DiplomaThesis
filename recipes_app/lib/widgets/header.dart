import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        style: GoogleFonts.roboto(
            color: color, fontSize: size, fontWeight: FontWeight.bold));
  }
}
