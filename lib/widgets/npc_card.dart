import 'package:flutter/material.dart';
import '../models/npc_character.dart';
import '../models/relationship.dart';

class NpcCard extends StatelessWidget {
  final NpcCharacter npc;
  final Relationship? relationship;
  final VoidCallback? onTap;

  const NpcCard({
    super.key,
    required this.npc,
    this.relationship,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          '${npc.occupation.isNotEmpty ? npc.occupation : 'No occupation'} • Age ${npc.age}',
        ),
        trailing: relationship != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _scoreIndicator('F', relationship!.friendship, Colors.pink),
                  _scoreIndicator('R', relationship!.romance, Colors.red),
                ],
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _scoreIndicator(String prefix, double score, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$prefix: ', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        Text(
          '${score.toStringAsFixed(0)}',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
}
