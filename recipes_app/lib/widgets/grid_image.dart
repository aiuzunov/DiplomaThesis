import 'package:flutter/material.dart';

class GridViewImage extends StatelessWidget {
  final String imageUrl;
  const GridViewImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(imageUrl, width: 5, height: 5);
  }
}
