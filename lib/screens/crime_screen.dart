import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/career_path.dart';
import '../models/crime_crew.dart';
import '../providers/career_provider.dart';
import '../providers/player_provider.dart';

class CrimeScreen extends StatelessWidget {
  const CrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime'),
        backgroundColor: AppTheme.crimeRed,
      ),
      body: Consumer2<CareerProvider, PlayerProvider>(
        builder: (context, career, player, _) {
          final crimePath = career.paths
              .where((p) => p.pathType == 'crime' && p.isActive)
              .firstOrNull;

          if (crimePath == null) {
            return _buildInactiveState(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeatMeter(crimePath),
                const SizedBox(height: 16),
                _buildRepGrid(crimePath),
                const SizedBox(height: 16),
                _buildCrewSection(career),
                const SizedBox(height: 16),
                _buildOperationsSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInactiveState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.local_police, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Not pursuing a crime path',
              style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Back to Careers'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeatMeter(CareerPath path) {
    final heat = path.heatLevel ?? 0;
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: heat > 70
              ? Border.all(color: Colors.red, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.whatshot, color: heat > 70 ? Colors.red : Colors.orange),
                const SizedBox(width: 8),
                const Text('HEAT LEVEL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Spacer(),
                Text('${heat.toStringAsFixed(0)}/100',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: heat > 70 ? Colors.red : Colors.orange,
                    )),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: heat / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  heat > 70 ? Colors.red : heat > 40 ? Colors.orange : Colors.yellow[700]!,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              heat == 0 ? 'Clean — no police attention' :
              heat < 30 ? 'Low — under the radar' :
              heat < 60 ? 'Moderate — police are noticing' :
              heat < 80 ? 'High — police investigation active' :
              'Critical — raids imminent!',
              style: TextStyle(
                fontSize: 12,
                color: heat > 70 ? Colors.red : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepGrid(CareerPath path) {
    return Row(
      children: [
        Expanded(child: _miniRepCard('Street Cred', path.streetCred ?? 0, Colors.purple)),
        const SizedBox(width: 8),
        Expanded(child: _miniRepCard('Crew Loyalty', path.crewLoyalty ?? 0, Colors.teal)),
      ],
    );
  }

  Widget _miniRepCard(String label, double value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text('${value.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
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
        ),
      ),
    );
  }

  Widget _buildCrewSection(CareerProvider career) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Crew', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (career.crew.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.group_add, color: Colors.grey),
                  const SizedBox(width: 12),
                  const Text('No crew members yet. Recruit some allies.'),
                ],
              ),
            ),
          )
        else
          ...career.crew.map((member) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.crimeRed.withOpacity(0.1),
                    child: Icon(_getRoleIcon(member.role), color: AppTheme.crimeRed, size: 20),
                  ),
                  title: Text('NPC #${member.npcId}'),
                  subtitle: Text('${member.role.replaceAll('_', ' ')} • '
                      'Loyalty: ${member.loyalty.toStringAsFixed(0)} • '
                      'Skill: ${member.skill.toStringAsFixed(0)}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: member.status == 'active' ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(member.status.toUpperCase(), style: const TextStyle(fontSize: 10)),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildOperationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Operations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.attach_money, color: Colors.amber),
                title: const Text('Money Laundering'),
                subtitle: const Text('Clean dirty money through front businesses'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.orange),
                title: const Text('Fence Goods'),
                subtitle: const Text('Sell stolen goods on the black market'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shield, color: Colors.red),
                title: const Text('Territory Expansion'),
                subtitle: const Text('Take control of new areas'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'hacker': return Icons.computer;
      case 'getaway_driver': return Icons.directions_car;
      case 'muscle': return Icons.fitness_center;
      case 'fixer': return Icons.handyman;
      case 'fence': return Icons.store;
      default: return Icons.person;
    }
  }
}
