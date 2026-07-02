import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/political_position.dart';
import '../models/policy_stance.dart';
import '../models/scandal.dart';
import '../providers/career_provider.dart';

class PoliticsScreen extends StatelessWidget {
  const PoliticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Politics'),
        backgroundColor: AppTheme.politicsGold,
        foregroundColor: Colors.black,
      ),
      body: Consumer<CareerProvider>(
        builder: (context, career, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCurrentPosition(career.positions),
                const SizedBox(height: 16),
                _buildApprovalRatings(career),
                const SizedBox(height: 16),
                _buildPolicyStances(career.stances),
                const SizedBox(height: 16),
                _buildScandals(career.scandals),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentPosition(List<PoliticalPosition> positions) {
    final current = positions.where((p) => p.isCurrent).firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.account_balance, color: AppTheme.politicsGold, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current?.officeTitle ?? 'No Current Office',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        current != null
                            ? '${current.jurisdiction} • ${current.party}'
                            : 'Not holding political office',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalRatings(CareerProvider career) {
    final paths = career.paths.where((p) => p.pathType == 'politics').toList();
    if (paths.isEmpty) return const SizedBox.shrink();

    final path = paths.first;
    return Row(
      children: [
        Expanded(child: _approvalCard('Voter Approval', path.voterApproval ?? 0, Colors.green)),
        const SizedBox(width: 8),
        Expanded(child: _approvalCard('Party Standing', path.partyStanding ?? 0, Colors.blue)),
        const SizedBox(width: 8),
        Expanded(child: _approvalCard('Media Favor', path.mediaFavorability ?? 0, Colors.purple)),
      ],
    );
  }

  Widget _approvalCard(String label, double value, Color color) {
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

  Widget _buildPolicyStances(List<PolicyStance> stances) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Policy Stances',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (stances.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No policy stances defined yet', style: TextStyle(color: Colors.grey)),
          ))
        else
          Card(
            child: Column(
              children: stances.map((s) => ListTile(
                title: Text(s.issue.replaceAll('_', ' ')),
                subtitle: Text('${s.stance} (Strength: ${s.strength}/10)'),
                trailing: _stanceBadge(s.stance),
              )).toList(),
            ),
          ),
      ],
    );
  }

  Widget _stanceBadge(String stance) {
    Color color;
    switch (stance.toLowerCase()) {
      case 'conservative':
        color = Colors.red;
        break;
      case 'liberal':
        color = Colors.blue;
        break;
      case 'moderate':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(stance, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildScandals(List<Scandal> scandals) {
    final activeScandals = scandals.where((s) => !s.isResolved).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Scandals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (activeScandals.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${activeScandals.length} active',
                    style: const TextStyle(fontSize: 12, color: Colors.red)),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        if (scandals.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No scandals. Keep it clean!', style: TextStyle(color: Colors.grey)),
          ))
        else
          ...scandals.map((s) => Card(
                child: ListTile(
                  leading: Icon(
                    s.isResolved ? Icons.check_circle : Icons.warning,
                    color: s.isResolved ? Colors.green : Colors.red,
                  ),
                  title: Text(s.title),
                  subtitle: Text('Severity: ${s.severity}/10'),
                  trailing: s.isResolved
                      ? const Text('Resolved', style: TextStyle(color: Colors.green, fontSize: 12))
                      : null,
                ),
              )),
      ],
    );
  }
}
