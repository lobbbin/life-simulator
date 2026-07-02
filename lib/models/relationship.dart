class Relationship {
  final int? id;
  final int playerId;
  final int npcId;
  final double friendship;
  final double romance;
  final double rivalry;
  final DateTime lastUpdated;

  Relationship({
    this.id,
    required this.playerId,
    required this.npcId,
    this.friendship = 0,
    this.romance = 0,
    this.rivalry = 0,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'npc_id': npcId,
        'friendship': friendship,
        'romance': romance,
        'rivalry': rivalry,
        'last_updated': lastUpdated.toIso8601String(),
      };

  factory Relationship.fromMap(Map<String, dynamic> map) => Relationship(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        npcId: map['npc_id'] as int,
        friendship: (map['friendship'] as num?)?.toDouble() ?? 0,
        romance: (map['romance'] as num?)?.toDouble() ?? 0,
        rivalry: (map['rivalry'] as num?)?.toDouble() ?? 0,
        lastUpdated: DateTime.parse(map['last_updated'] as String),
      );

  Relationship copyWith({
    int? id,
    int? playerId,
    int? npcId,
    double? friendship,
    double? romance,
    double? rivalry,
    DateTime? lastUpdated,
  }) =>
      Relationship(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        npcId: npcId ?? this.npcId,
        friendship: friendship ?? this.friendship,
        romance: romance ?? this.romance,
        rivalry: rivalry ?? this.rivalry,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );
}
