import 'package:flutter/cupertino.dart';

class AppLargeText extends StatelessWidget {
  double? size;
  final String text;
  final Color color;
  AppLargeText({this.size = 20, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
