import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../app_text/app_text.dart';

class AppButton extends StatelessWidget {
  bool? isResponsive;
  double? size;
  Color? color;
  final String? text;
  AppButton({this.size, this.color, this.text, this.isResponsive});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isResponsive == true ? 50 : size,
      width: isResponsive == true ? double.maxFinite : size,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(child: AppText(text: text!)),
    );
  }
}
