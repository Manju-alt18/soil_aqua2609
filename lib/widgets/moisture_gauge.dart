import 'dart:math';
import 'package:flutter/material.dart';
import '/app_theme.dart';

class MoistureGauge extends StatelessWidget {
  final double value;
  final double size;
  const MoistureGauge({super.key, required this.value, this.size = 200});

  Color get _color {
    if (value < 25) return AppColors.coral;
    if (value < 45) return AppColors.amber;
    if (value < 75) return AppColors.leaf;
    return AppColors.sky;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: _GaugePainter(animatedValue, _color),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${animatedValue.toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: size * 0.19, fontWeight: FontWeight.bold, color: AppColors.ink),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Soil Moisture',
                    style: TextStyle(fontSize: size * 0.07, color: AppColors.ink.withOpacity(0.6), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  _GaugePainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;

    final track = Paint()
      ..color = AppColors.mint.withOpacity(0.4)
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi * 0.75, pi * 1.5, false, track);

    final progress = Paint()
      ..shader = SweepGradient(
        colors: [AppColors.sky, color],
        startAngle: pi * 0.75,
        endAngle: pi * 2.25,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = 16
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweep = pi * 1.5 * (value / 100).clamp(0, 1);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), pi * 0.75, sweep, false, progress);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}