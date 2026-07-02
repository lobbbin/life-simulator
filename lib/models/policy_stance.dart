class PolicyStance {
  final int? id;
  final int playerId;
  final String issue; // taxes, healthcare, education, crime, foreign_policy, environment
  final String stance; // conservative, moderate, liberal, etc.
  final int strength; // 1-10

  PolicyStance({
    this.id,
    required this.playerId,
    required this.issue,
    required this.stance,
    this.strength = 5,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'issue': issue,
        'stance': stance,
        'strength': strength,
      };

  factory PolicyStance.fromMap(Map<String, dynamic> map) => PolicyStance(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        issue: map['issue'] as String,
        stance: map['stance'] as String,
        strength: map['strength'] as int? ?? 5,
      );
}
