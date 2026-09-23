import 'package:flutter/material.dart';

class MoistureGauge extends StatelessWidget {
  final int percent;
  final double size;

  const MoistureGauge({super.key, required this.percent, this.size = 180});

  Color _colorFor(BuildContext context, int p) {
    if (p < 30) return Colors.redAccent;
    if (p < 60) return Colors.amber;
    return Colors.greenAccent.shade400;
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(context, percent);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percent / 100,
              strokeWidth: 14,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$percent%',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 4),
              Text('Moisture', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
