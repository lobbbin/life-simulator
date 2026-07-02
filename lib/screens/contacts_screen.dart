import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../providers/player_provider.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final npcs = provider.npcs;

          if (npcs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No contacts yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Meet people through the game!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: npcs.length,
            itemBuilder: (context, index) {
              final npc = npcs[index];
              final rel = provider.getRelationship(npc.id!);

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: npc.isCore ? Colors.amber.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
                    child: Text(
                      npc.name[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: npc.isCore ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                  title: Text(npc.name),
                  subtitle: Text(
                    '${npc.occupation.isNotEmpty ? '${npc.occupation} • ' : ''}'
                    'Age ${npc.age}',
                  ),
                  trailing: rel != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _relScore(Icons.favorite, rel.friendship, Colors.pink),
                            _relScore(Icons.favorite_border, rel.romance, Colors.red),
                          ],
                        )
                      : null,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.npcDetail,
                    arguments: npc.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _relScore(IconData icon, double score, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 2),
        Text('${score.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
