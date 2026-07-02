import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/career_provider.dart';

class PrisonScreen extends StatelessWidget {
  const PrisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prison'),
        backgroundColor: AppTheme.prisonGrey,
      ),
      body: Consumer<CareerProvider>(
        builder: (context, career, _) {
          final sentence = career.currentSentence;

          if (sentence == null) {
            return _buildNoSentence(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSentenceCard(sentence),
                const SizedBox(height: 16),
                _buildStatusGrid(sentence),
                const SizedBox(height: 16),
                _buildPrisonActivities(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoSentence(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_open, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Not currently incarcerated',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSentenceCard(sentence) {
    final daysRemaining = sentence.daysRemaining;
    final totalDays = sentence.sentenceLength;
    final progress = totalDays > 0 ? (totalDays - daysRemaining) / totalDays : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock, color: AppTheme.prisonGrey, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Sentence',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('${totalDays} days • ${daysRemaining} remaining',
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.prisonGrey),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text('${(progress * 100).toStringAsFixed(0)}% complete',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusGrid(sentence) {
    return Row(
      children: [
        Expanded(child: _statusCard('Good Conduct', sentence.goodConduct, Colors.green)),
        const SizedBox(width: 8),
        Expanded(child: _statusCard('Inmate Respect', sentence.inmateRespect, Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _statusCard('Guard Rapport', sentence.guardRapport, Colors.blue)),
      ],
    );
  }

  Widget _statusCard(String label, double value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('${value.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrisonActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              _activityTile(Icons.work, 'Prison Job', 'Work in laundry, kitchen, or library'),
              const Divider(),
              _activityTile(Icons.fitness_center, 'Gym', 'Work out and gain strength'),
              const Divider(),
              _activityTile(Icons.book, 'Education', 'Take GED or college courses'),
              const Divider(),
              _activityTile(Icons.phone, 'Phone Call', 'Contact the outside world'),
              const Divider(),
              _activityTile(Icons.gavel, 'Parole Hearing', 'Apply for early release'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.prisonGrey),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
