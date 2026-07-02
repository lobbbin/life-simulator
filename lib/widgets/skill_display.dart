import 'package:flutter/material.dart';
import '../config/theme.dart';

class SkillDisplay extends StatelessWidget {
  final String name;
  final int level;
  final double maxLevel;

  const SkillDisplay({
    super.key,
    required this.name,
    required this.level,
    this.maxLevel = 100,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (level / maxLevel).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(name, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  progress >= 0.8
                      ? Colors.green
                      : progress >= 0.5
                          ? AppTheme.careerTeal
                          : Colors.blue,
                ),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$level',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: progress >= 0.8 ? Colors.green : AppTheme.careerTeal,
            ),
          ),
        ],
      ),
    );
  }
}
