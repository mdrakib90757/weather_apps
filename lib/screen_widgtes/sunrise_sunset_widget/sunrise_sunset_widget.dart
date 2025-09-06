import 'package:flutter/material.dart';

import '../../widgets/app_text/app_text.dart';

class SunriseSunsetWidget extends StatelessWidget {
  final String sunrise;
  final String sunset;
  final double sunProgress;

  const SunriseSunsetWidget({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.sunProgress,
  }) : super(key: key);

  Offset _calculateSunPosition(double t, Size size) {
    final p0 = Offset(0, size.height);
    final p1 = Offset(size.width / 2, -size.height / 1.5);
    final p2 = Offset(size.width, size.height);

    final x =
        (1 - t) * (1 - t) * p0.dx + 2 * (1 - t) * t * p1.dx + t * t * p2.dx;
    final y =
        (1 - t) * (1 - t) * p0.dy + 2 * (1 - t) * t * p1.dy + t * t * p2.dy;
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.transparent.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTimeRow(sunrise, "Sunrise"),
              const SizedBox(height: 12),
              _buildTimeRow(sunset, "Sunset"),
            ],
          ),

          Expanded(
            child: SizedBox(
              height: 70,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final size = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final sunPosition = _calculateSunPosition(sunProgress, size);

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CustomPaint(size: size, painter: SunriseArcPainter()),

                      Positioned(
                        left: sunPosition.dx - 12,
                        top: sunPosition.dy - 12,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.yellow.withOpacity(0.8),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String time, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AppText(text: time, color: Colors.white, size: 20),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(bottom: 2.0),
          child: AppText(text: label, color: Colors.white, size: 18),
        ),
      ],
    );
  }
}

class SunriseArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path()
      ..moveTo(0, size.height)
      ..quadraticBezierTo(
        size.width / 2,
        -size.height / 1.5,
        size.width,
        size.height,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
