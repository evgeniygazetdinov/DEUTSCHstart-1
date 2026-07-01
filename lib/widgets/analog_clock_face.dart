import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Простой аналоговый циферблат (1–12 ч, стрелки часов и минут).
class AnalogClockFace extends StatelessWidget {
  const AnalogClockFace({
    super.key,
    required this.hour12,
    required this.minute,
    this.size = 180,
  });

  final int hour12;
  final int minute;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _ClockPainter(hour12: hour12, minute: minute),
      ),
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter({required this.hour12, required this.minute});

  final int hour12;
  final int minute;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 4;

    final facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = const Color(0xFF1C1C1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius, facePaint);
    canvas.drawCircle(center, radius, borderPaint);

    for (var i = 1; i <= 12; i++) {
      final angle = (i * 30 - 90) * math.pi / 180;
      final outer = Offset(
        center.dx + math.cos(angle) * (radius - 8),
        center.dy + math.sin(angle) * (radius - 8),
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - (i % 3 == 0 ? 22 : 14)),
        center.dy + math.sin(angle) * (radius - (i % 3 == 0 ? 22 : 14)),
      );
      final tick = Paint()
        ..color = const Color(0xFF3C3C43)
        ..strokeWidth = i % 3 == 0 ? 2.5 : 1.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(inner, outer, tick);

      final labelRadius = radius - 28;
      final label = Offset(
        center.dx + math.cos(angle) * labelRadius,
        center.dy + math.sin(angle) * labelRadius,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: '$i',
          style: const TextStyle(
            color: Color(0xFF1C1C1E),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, label - Offset(tp.width / 2, tp.height / 2));
    }

    final h = hour12 % 12;
    final hourAngle = ((h + minute / 60) * 30 - 90) * math.pi / 180;
    final minuteAngle = (minute * 6 - 90) * math.pi / 180;

    _drawHand(
      canvas,
      center,
      hourAngle,
      radius * 0.48,
      const Color(0xFF1C1C1E),
      5,
    );
    _drawHand(
      canvas,
      center,
      minuteAngle,
      radius * 0.68,
      const Color(0xFF007AFF),
      3.5,
    );

    canvas.drawCircle(center, 5, Paint()..color = const Color(0xFF1C1C1E));
  }

  void _drawHand(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    Color color,
    double width,
  ) {
    final end = Offset(
      center.dx + math.cos(angle) * length,
      center.dy + math.sin(angle) * length,
    );
    canvas.drawLine(
      center,
      end,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ClockPainter old) =>
      old.hour12 != hour12 || old.minute != minute;
}
