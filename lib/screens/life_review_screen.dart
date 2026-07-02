import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../config/routes.dart';
import '../providers/player_provider.dart';
import '../providers/career_provider.dart';

class LifeReviewScreen extends StatelessWidget {
  const LifeReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Review'),
        backgroundColor: Colors.grey[800],
      ),
      body: Consumer2<PlayerProvider, CareerProvider>(
        builder: (context, playerProvider, careerProvider, _) {
          final player = playerProvider.player;
          final stats = playerProvider.stats;

          if (player == null || stats == null) {
            return const Center(child: Text('No data to review'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.self_improvement, size: 64, color: Colors.grey),
                const SizedBox(height: 8),
                Text(
                  player.name,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${player.age} years',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    player.causeOfDeath ?? 'Passed away',
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),

                const SizedBox(height: 24),
                const Text('Life Statistics',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _statRow('Total Net Worth', '\$${playerProvider.getNetWorth().toStringAsFixed(0)}'),
                        _statRow('Relationships', '${playerProvider.relationships.length}'),
                        _statRow('Items Collected', '${playerProvider.inventory.length}'),
                        _statRow('Memories Made', '${playerProvider.memories.length}'),
                        _statRow('Career Paths', '${careerProvider.paths.length}'),
                        _statRow('Education Stages', '${playerProvider.educationStages.length}'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Text('Final Stats',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _finalStat('Health', stats.health, AppTheme.healthGreen),
                        _finalStat('Happiness', stats.happiness, AppTheme.happinessOrange),
                        _finalStat('Intelligence', stats.intelligence, AppTheme.intelligencePurple),
                        _finalStat('Social', stats.social, AppTheme.socialBlue),
                        _finalStat('Fitness', stats.fitness, AppTheme.fitnessRed),
                        _finalStat('Reputation', stats.reputation, Colors.blueGrey),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.family_restroom),
                    label: const Text('Continue as Heir'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.careerTeal,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.heirSelection),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Start New Life'),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.chat, (route) => false);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _finalStat(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: Text('${value.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
        ],
      ),
    );
  }
}
