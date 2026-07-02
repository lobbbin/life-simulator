class PlayerTrait {
  final int? id;
  final int playerId;
  final String traitName;
  final String traitType; // innate, acquired
  final DateTime acquiredAt;
  final String description;

  PlayerTrait({
    this.id,
    required this.playerId,
    required this.traitName,
    required this.traitType,
    DateTime? acquiredAt,
    this.description = '',
  }) : acquiredAt = acquiredAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'trait_name': traitName,
        'trait_type': traitType,
        'acquired_at': acquiredAt.toIso8601String(),
        'description': description,
      };

  factory PlayerTrait.fromMap(Map<String, dynamic> map) => PlayerTrait(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        traitName: map['trait_name'] as String,
        traitType: map['trait_type'] as String,
        acquiredAt: DateTime.parse(map['acquired_at'] as String),
        description: map['description'] as String? ?? '',
      );
}
