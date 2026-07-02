class ConversationMessage {
  final int? id;
  final int playerId;
  final String sessionId;
  final String role; // player, ai, narrator, npc
  final int? npcId;
  final String content;
  final DateTime timestamp;
  final String? statChanges; // JSON of stat changes

  ConversationMessage({
    this.id,
    required this.playerId,
    required this.sessionId,
    required this.role,
    this.npcId,
    required this.content,
    DateTime? timestamp,
    this.statChanges,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'session_id': sessionId,
        'role': role,
        'npc_id': npcId,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'stat_changes': statChanges,
      };

  factory ConversationMessage.fromMap(Map<String, dynamic> map) => ConversationMessage(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        sessionId: map['session_id'] as String,
        role: map['role'] as String,
        npcId: map['npc_id'] as int?,
        content: map['content'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
        statChanges: map['stat_changes'] as String?,
      );
}
