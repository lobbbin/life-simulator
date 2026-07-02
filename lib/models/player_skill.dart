class PlayerSkill {
  final int? id;
  final int playerId;
  final String skillName;
  final int skillLevel;
  final double experience;

  PlayerSkill({
    this.id,
    required this.playerId,
    required this.skillName,
    this.skillLevel = 1,
    this.experience = 0,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'skill_name': skillName,
        'skill_level': skillLevel,
        'experience': experience,
      };

  factory PlayerSkill.fromMap(Map<String, dynamic> map) => PlayerSkill(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        skillName: map['skill_name'] as String,
        skillLevel: map['skill_level'] as int? ?? 1,
        experience: (map['experience'] as num?)?.toDouble() ?? 0,
      );

  PlayerSkill copyWith({
    int? id,
    int? playerId,
    String? skillName,
    int? skillLevel,
    double? experience,
  }) =>
      PlayerSkill(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        skillName: skillName ?? this.skillName,
        skillLevel: skillLevel ?? this.skillLevel,
        experience: experience ?? this.experience,
      );
}
