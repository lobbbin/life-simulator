import 'package:flutter/material.dart';

class ReputationBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final String? description;

  const ReputationBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            Text('${value.toStringAsFixed(0)}/100',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 2),
          Text(description!, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ],
    );
  }
}
