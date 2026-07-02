import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/npc_character.dart';
import '../models/relationship.dart';
import '../providers/player_provider.dart';

class NpcDetailScreen extends StatelessWidget {
  final int npcId;
  const NpcDetailScreen({super.key, required this.npcId});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerProvider>(
      builder: (context, provider, _) {
        final npc = provider.getNpc(npcId);
        if (npc == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('NPC Detail')),
            body: const Center(child: Text('NPC not found')),
          );
        }

        final rel = provider.getRelationship(npcId);

        return Scaffold(
          appBar: AppBar(title: Text(npc.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(npc),
                const SizedBox(height: 16),
                if (rel != null) _buildRelationshipCard(rel),
                const SizedBox(height: 16),
                _buildInfoCard(npc),
                const SizedBox(height: 16),
                _buildPersonalityCard(npc),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(NpcCharacter npc) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: npc.isCore ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
            child: Text(
              npc.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: npc.isCore ? Colors.amber : Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(npc.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('${npc.age} years old • ${npc.gender}', style: TextStyle(color: Colors.grey[600])),
          if (npc.isCore)
            Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('CORE CHARACTER',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber)),
            ),
        ],
      ),
    );
  }

  Widget _buildRelationshipCard(Relationship rel) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Relationship', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _relBar('Friendship', rel.friendship, Colors.pink),
            const SizedBox(height: 8),
            _relBar('Romance', rel.romance, Colors.red),
            const SizedBox(height: 8),
            _relBar('Rivalry', rel.rivalry, Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _relBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13)),
            Text('${value.toStringAsFixed(0)}/100',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
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

  Widget _buildInfoCard(NpcCharacter npc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _infoRow('Occupation', npc.occupation.isNotEmpty ? npc.occupation : 'Unknown'),
            _infoRow('Backstory', npc.backstory.isNotEmpty ? npc.backstory : 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalityCard(NpcCharacter npc) {
    if (npc.personality == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personality', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...npc.personality!.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key),
                  Text('${entry.value}',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
