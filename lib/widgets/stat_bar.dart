import 'package:flutter/material.dart';

class StatBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData? icon;
  final bool showValue;
  final double height;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.icon,
    this.showValue = true,
    this.height = 8,
  });

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 100.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
            ],
            Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
            if (showValue)
              Text(
                '${clampedValue.toStringAsFixed(0)}/100',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color),
              ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: clampedValue / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: height,
          ),
        ),
      ],
    );
  }
}
