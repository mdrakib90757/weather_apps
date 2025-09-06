import 'package:flutter/material.dart';

import '../../widgets/app_text/app_text.dart';
import '../compass_painter/compass_painter.dart';

class WindWidget extends StatelessWidget {
  final String direction;
  final String speed;
  final double windAngleDegrees;

  const WindWidget({
    Key? key,
    required this.direction,
    required this.speed,
    required this.windAngleDegrees,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: direction, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              AppText(text: speed, color: Colors.white, size: 18),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 60,
            height: 60,
            child: CustomPaint(
              painter: CompassPainter(windAngleDegrees: windAngleDegrees),
            ),
          ),
        ],
      ),
    );
  }
}
