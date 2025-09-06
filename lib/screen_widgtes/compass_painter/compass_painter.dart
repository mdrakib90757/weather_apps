import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompassPainter extends CustomPainter {
  final double windAngleDegrees;

  CompassPainter({required this.windAngleDegrees});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.4;

    void drawText(String text, Offset position) {
      TextPainter(
          text: TextSpan(
            text: text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          textDirection: TextDirection.ltr,
        )
        ..layout()
        ..paint(canvas, position - Offset(7, 8));
    }

    drawText('N', center - Offset(0, radius + 10));
    drawText('S', center + Offset(0, radius - 5));
    drawText('W', center - Offset(radius + 12, 0));
    drawText('E', center + Offset(radius - 5, 0));

    final arrowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final arrowAngleRad = windAngleDegrees * (math.pi / 180);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(arrowAngleRad);

    final arrowPath = Path()
      ..moveTo(0, radius * 0.4)
      ..lineTo(0, -radius * 0.7);

    canvas.drawPath(arrowPath, arrowPaint);

    final arrowHeadPaint = Paint()..color = Colors.white;
    final headPath = Path()
      ..moveTo(0, -radius * 0.85)
      ..lineTo(-6, -radius * 0.85 + 15)
      ..lineTo(6, -radius * 0.85 + 15)
      ..close();
    canvas.drawPath(headPath, arrowHeadPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is CompassPainter &&
        oldDelegate.windAngleDegrees != windAngleDegrees;
  }
}
