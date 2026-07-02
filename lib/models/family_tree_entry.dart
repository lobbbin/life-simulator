class FamilyTreeEntry {
  final int? id;
  final int playerId;
  final int npcId;
  final String relationship; // parent, child, sibling, spouse, grandparent, grandchild, cousin

  FamilyTreeEntry({
    this.id,
    required this.playerId,
    required this.npcId,
    required this.relationship,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'npc_id': npcId,
        'relationship': relationship,
      };

  factory FamilyTreeEntry.fromMap(Map<String, dynamic> map) => FamilyTreeEntry(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        npcId: map['npc_id'] as int,
        relationship: map['relationship'] as String,
      );
}
