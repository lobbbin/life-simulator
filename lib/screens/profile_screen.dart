import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/player_provider.dart';
import '../providers/time_provider.dart';
import '../widgets/stat_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Profile')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final player = provider.player;
          final stats = provider.stats;

          if (player == null || stats == null) {
            return const Center(child: Text('No player data'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(player.name, player.age),
                const SizedBox(height: 24),
                _buildSectionTitle('Core Vitals'),
                const SizedBox(height: 8),
                _buildStatCard('Health', stats.health, AppTheme.healthGreen, Icons.favorite),
                _buildStatCard('Energy', stats.energy, AppTheme.energyYellow, Icons.bolt),
                _buildStatCard('Happiness', stats.happiness, AppTheme.happinessOrange, Icons.emoji_emotions),

                const SizedBox(height: 24),
                _buildSectionTitle('Life Domains'),
                const SizedBox(height: 8),
                _buildStatCard('Intelligence', stats.intelligence, AppTheme.intelligencePurple, Icons.psychology),
                _buildStatCard('Social', stats.social, AppTheme.socialBlue, Icons.groups),
                _buildStatCard('Fitness', stats.fitness, AppTheme.fitnessRed, Icons.fitness_center),
                _buildStatCard('Career', stats.career, AppTheme.careerTeal, Icons.work),

                const SizedBox(height: 24),
                _buildSectionTitle('Derived Stats'),
                const SizedBox(height: 8),
                _buildStatCard('Money', stats.money, AppTheme.moneyGreen, Icons.attach_money, showMax: false),
                _buildStatCard('Hunger', stats.hunger, Colors.brown, Icons.restaurant),
                _buildStatCard('Stress', stats.stress, Colors.pink, Icons.psychology_alt),
                _buildStatCard('Reputation', stats.reputation, Colors.blueGrey, Icons.star),

                const SizedBox(height: 24),
                _buildSectionTitle('Skills'),
                const SizedBox(height: 8),
                ...provider.skills.map((skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _buildSkillTile(skill.skillName, skill.skillLevel),
                    )),

                const SizedBox(height: 24),
                _buildSectionTitle('Traits'),
                const SizedBox(height: 8),
                if (provider.traits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No traits yet', style: TextStyle(color: Colors.grey)),
                  )
                else
                  ...provider.traits.map((trait) => Card(
                        child: ListTile(
                          leading: Icon(
                            trait.traitType == 'innate' ? Icons.auto_awesome : Icons.emoji_events,
                            color: trait.traitType == 'innate' ? Colors.amber : Colors.teal,
                          ),
                          title: Text(trait.traitName),
                          subtitle: Text(trait.description),
                        ),
                      )),

                const SizedBox(height: 24),
                _buildSectionTitle('Education'),
                const SizedBox(height: 8),
                if (provider.currentEducationStage != null)
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.school),
                      title: Text(_getStageName(provider.currentEducationStage!.stage)),
                      subtitle: Text('Performance: ${provider.currentEducationStage!.academicPerformance.toStringAsFixed(0)}/100'),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Not in education', style: TextStyle(color: Colors.grey)),
                  ),

                const SizedBox(height: 24),
                _buildSectionTitle('Game Info'),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _infoRow('Age', player.age.toString()),
                        _infoRow('Status', player.isAlive ? 'Alive' : 'Deceased'),
                        _infoRow('Net Worth', '\$${provider.getNetWorth().toStringAsFixed(0)}'),
                        _infoRow('Relationships', provider.relationships.length.toString()),
                        _infoRow('Inventory', provider.inventory.length.toString()),
                        _infoRow('Memories', provider.memories.length.toString()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(String name, int age) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(fontSize: 36, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Age $age', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildStatCard(String label, double value, Color color, IconData icon, {bool showMax = true}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: showMax ? (value / 100).clamp(0.0, 1.0) : (value / 10000).clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              showMax ? '${value.toStringAsFixed(0)}/100' : '\$${value.toStringAsFixed(0)}',
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillTile(String name, int level) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: level / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.careerTeal),
                  minHeight: 8,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('$level', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
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
}
