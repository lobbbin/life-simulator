class Memory {
  final int? id;
  final int playerId;
  final String content;
  final String summary;
  final String? embedding;
  final DateTime timestamp;
  final int? locationId;
  final String? involvedNpcs; // JSON array of NPC IDs
  final int importance;
  final bool isCore;

  Memory({
    this.id,
    required this.playerId,
    required this.content,
    required this.summary,
    this.embedding,
    DateTime? timestamp,
    this.locationId,
    this.involvedNpcs,
    this.importance = 5,
    this.isCore = false,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'content': content,
        'summary': summary,
        'embedding': embedding,
        'timestamp': timestamp.toIso8601String(),
        'location_id': locationId,
        'involved_npcs': involvedNpcs,
        'importance': importance,
        'is_core': isCore ? 1 : 0,
      };

  factory Memory.fromMap(Map<String, dynamic> map) => Memory(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        content: map['content'] as String,
        summary: map['summary'] as String? ?? '',
        embedding: map['embedding'] as String?,
        timestamp: DateTime.parse(map['timestamp'] as String),
        locationId: map['location_id'] as int?,
        involvedNpcs: map['involved_npcs'] as String?,
        importance: map['importance'] as int? ?? 5,
        isCore: (map['is_core'] as int?) == 1,
  );
}
