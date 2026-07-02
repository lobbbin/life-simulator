import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/player_provider.dart';
import '../providers/education_provider.dart';
import '../models/education_stage.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final playerProvider = context.read<PlayerProvider>();
    final player = playerProvider.player;
    if (player != null) {
      await context.read<EducationProvider>().loadEducation(player.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Education')),
      body: Consumer<EducationProvider>(
        builder: (context, provider, _) {
          final current = provider.currentStage;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (current != null) ...[
                  _buildCurrentStageCard(current),
                  const SizedBox(height: 24),
                  _buildEducationTimeline(provider.allStages),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('Not currently in education',
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                _buildSectionTitle('Education History'),
                const SizedBox(height: 8),
                if (provider.allStages.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No education history yet'),
                    ),
                  )
                else
                  ...provider.allStages.reversed.map((stage) => _buildEducationCard(stage)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentStageCard(EducationStage stage) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.careerTeal.withOpacity(0.3), width: 2),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.school, color: AppTheme.careerTeal, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStageName(stage.stage),
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getStageAgeRange(stage.stage),
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: stage.status == 'enrolled' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    stage.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: stage.status == 'enrolled' ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _progressRow('Academic Performance', stage.academicPerformance, AppTheme.intelligencePurple),
            const SizedBox(height: 8),
            _progressRow('Social Status', stage.socialStatus, AppTheme.socialBlue),
            if (stage.gpa != null) ...[
              const SizedBox(height: 8),
              _infoRow('GPA', stage.gpa!.toStringAsFixed(1)),
            ],
            if (stage.major != null) ...[
              const SizedBox(height: 8),
              _infoRow('Major', stage.major!),
            ],
            if (stage.minor != null) ...[
              const SizedBox(height: 8),
              _infoRow('Minor', stage.minor!),
            ],
            if (stage.completedSemesters != null) ...[
              const SizedBox(height: 8),
              _infoRow('Semesters Completed', stage.completedSemesters.toString()),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(EducationStage stage) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: stage.isCurrent ? AppTheme.careerTeal : Colors.grey,
          child: Icon(
            stage.stage == 'kindergarten' ? Icons.child_care :
            stage.stage == 'university' ? Icons.school :
            Icons.book,
            color: Colors.white,
          ),
        ),
        title: Text(_getStageName(stage.stage)),
        subtitle: Text(
          '${_getStageAgeRange(stage.stage)} • ${stage.status.replaceAll('_', ' ')}'
          '${stage.isCurrent ? ' • CURRENT' : ''}',
        ),
        trailing: stage.isCurrent ? const Icon(Icons.chevron_right) : null,
      ),
    );
  }

  Widget _buildEducationTimeline(List<EducationStage> stages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Life Timeline'),
        const SizedBox(height: 8),
        ...['kindergarten', 'elementary', 'middle_school', 'high_school', 'university']
            .map((stageType) {
          final stage = stages.where((s) => s.stage == stageType).firstOrNull;
          final isCompleted = stage != null && stage.status == 'graduated';
          final isCurrent = stage != null && stage.isCurrent;
          final isFuture = stage == null;

          return _timelineItem(
            icon: stageType == 'kindergarten' ? Icons.child_care :
                  stageType == 'university' ? Icons.school :
                  Icons.book,
            title: _getStageName(stageType),
            subtitle: _getStageAgeRange(stageType),
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isFuture: isFuture,
          );
        }),
      ],
    );
  }

  Widget _timelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isCurrent,
    required bool isFuture,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? Colors.green
                      : isCurrent
                          ? AppTheme.careerTeal
                          : Colors.grey[300],
                ),
                child: Icon(
                  isCompleted ? Icons.check : icon,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              Container(width: 2, height: 24, color: Colors.grey[300]),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isFuture ? Colors.grey : null,
                    )),
                Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.careerTeal.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('CURRENT',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.careerTeal)),
            ),
        ],
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
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('${value.toStringAsFixed(0)}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600));
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

  String _getStageAgeRange(String stage) {
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
