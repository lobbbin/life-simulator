import 'package:flutter/material.dart';
import '../models/education_stage.dart';
import '../config/theme.dart';

class EducationStageCard extends StatelessWidget {
  final EducationStage stage;
  final bool expanded;

  const EducationStageCard({
    super.key,
    required this.stage,
    this.expanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(expanded ? 16.0 : 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStageIcon(stage.stage),
                  color: AppTheme.careerTeal,
                  size: expanded ? 28 : 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStageName(stage.stage),
                        style: TextStyle(
                          fontSize: expanded ? 18 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (expanded)
                        Text(
                          _getAgeRange(stage.stage),
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: stage.status == 'enrolled'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    stage.status.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: stage.status == 'enrolled' ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            if (expanded) ...[
              const SizedBox(height: 12),
              _progressRow('Academic', stage.academicPerformance, AppTheme.intelligencePurple),
              const SizedBox(height: 4),
              _progressRow('Social', stage.socialStatus, AppTheme.socialBlue),
              if (stage.gpa != null) ...[
                const SizedBox(height: 4),
                _infoRow('GPA', stage.gpa!.toStringAsFixed(1)),
              ],
              if (stage.major != null) ...[
                const SizedBox(height: 4),
                _infoRow('Major', stage.major!),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _progressRow(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12)),
            Text('${value.toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  IconData _getStageIcon(String stage) {
    switch (stage) {
      case 'kindergarten': return Icons.child_care;
      case 'elementary': return Icons.book;
      case 'middle_school': return Icons.school;
      case 'high_school': return Icons.school;
      case 'university': return Icons.account_balance;
      default: return Icons.school;
    }
  }

  String _getStageName(String stage) {
    switch (stage) {
      case 'kindergarten': return 'Kindergarten';
      case 'elementary': return 'Elementary School';
      case 'middle_school': return 'Middle School';
      case 'high_school': return 'High School';
      case 'university': return 'University';
      default: return stage;
    }
  }

  String _getAgeRange(String stage) {
    switch (stage) {
      case 'kindergarten': return 'Ages 3–5';
      case 'elementary': return 'Ages 6–10';
      case 'middle_school': return 'Ages 11–13';
      case 'high_school': return 'Ages 14–18';
      case 'university': return 'Ages 18–22+';
      default: return '';
    }
  }
}
