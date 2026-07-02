import 'package:flutter/material.dart';
import '../models/career_milestone.dart';

class MilestoneTimeline extends StatelessWidget {
  final List<CareerMilestone> milestones;

  const MilestoneTimeline({
    super.key,
    required this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No milestones yet', style: TextStyle(color: Colors.grey)),
      );
    }

    final sorted = List<CareerMilestone>.from(milestones)
      ..sort((a, b) => a.achievedAt.compareTo(b.achievedAt));

    return Column(
      children: sorted.map((milestone) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _getImportanceColor(milestone.importance),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                  Container(width: 2, height: 30, color: Colors.grey[300]),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Text(
                      milestone.description,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      '${milestone.achievedAt.month}/${milestone.achievedAt.day}/${milestone.achievedAt.year}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Color _getImportanceColor(int importance) {
    if (importance >= 8) return Colors.amber;
    if (importance >= 5) return Colors.blue;
    return Colors.grey;
  }
}
