class CrimeCrew {
  final int? id;
  final int playerId;
  final int npcId;
  final String role; // hacker, getaway_driver, muscle, fixer, fence
  final double loyalty;
  final double skill;
  final DateTime joinedAt;
  final String status; // active, arrested, deceased, betrayed

  CrimeCrew({
    this.id,
    required this.playerId,
    required this.npcId,
    required this.role,
    this.loyalty = 50,
    this.skill = 50,
    DateTime? joinedAt,
    this.status = 'active',
  }) : joinedAt = joinedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'npc_id': npcId,
        'role': role,
        'loyalty': loyalty,
        'skill': skill,
        'joined_at': joinedAt.toIso8601String(),
        'status': status,
      };

  factory CrimeCrew.fromMap(Map<String, dynamic> map) => CrimeCrew(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        npcId: map['npc_id'] as int,
        role: map['role'] as String,
        loyalty: (map['loyalty'] as num?)?.toDouble() ?? 50,
        skill: (map['skill'] as num?)?.toDouble() ?? 50,
        joinedAt: DateTime.parse(map['joined_at'] as String),
        status: map['status'] as String? ?? 'active',
      );
}
