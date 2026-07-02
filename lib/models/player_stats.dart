class PlayerStats {
  final int? id;
  final int playerId;
  final double health;
  final double energy;
  final double happiness;
  final double money;
  final double intelligence;
  final double social;
  final double fitness;
  final double career;
  final double hunger;
  final double stress;
  final double reputation;
  final DateTime updatedAt;

  PlayerStats({
    this.id,
    required this.playerId,
    this.health = 100,
    this.energy = 100,
    this.happiness = 50,
    this.money = 0,
    this.intelligence = 10,
    this.social = 10,
    this.fitness = 10,
    this.career = 0,
    this.hunger = 0,
    this.stress = 0,
    this.reputation = 0,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'health': health,
        'energy': energy,
        'happiness': happiness,
        'money': money,
        'intelligence': intelligence,
        'social': social,
        'fitness': fitness,
        'career': career,
        'hunger': hunger,
        'stress': stress,
        'reputation': reputation,
        'updated_at': updatedAt.toIso8601String(),
      };

  factory PlayerStats.fromMap(Map<String, dynamic> map) => PlayerStats(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        health: (map['health'] as num?)?.toDouble() ?? 100,
        energy: (map['energy'] as num?)?.toDouble() ?? 100,
        happiness: (map['happiness'] as num?)?.toDouble() ?? 50,
        money: (map['money'] as num?)?.toDouble() ?? 0,
        intelligence: (map['intelligence'] as num?)?.toDouble() ?? 10,
        social: (map['social'] as num?)?.toDouble() ?? 10,
        fitness: (map['fitness'] as num?)?.toDouble() ?? 10,
        career: (map['career'] as num?)?.toDouble() ?? 0,
        hunger: (map['hunger'] as num?)?.toDouble() ?? 0,
        stress: (map['stress'] as num?)?.toDouble() ?? 0,
        reputation: (map['reputation'] as num?)?.toDouble() ?? 0,
        updatedAt: DateTime.parse(map['updated_at'] as String),
      );

  double getStat(String name) {
    switch (name.toLowerCase()) {
      case 'health': return health;
      case 'energy': return energy;
      case 'happiness': return happiness;
      case 'money': return money;
      case 'intelligence': return intelligence;
      case 'social': return social;
      case 'fitness': return fitness;
      case 'career': return career;
      case 'hunger': return hunger;
      case 'stress': return stress;
      case 'reputation': return reputation;
      default: return 0;
    }
  }

  PlayerStats copyWith({
    int? id,
    int? playerId,
    double? health,
    double? energy,
    double? happiness,
    double? money,
    double? intelligence,
    double? social,
    double? fitness,
    double? career,
    double? hunger,
    double? stress,
    double? reputation,
    DateTime? updatedAt,
  }) =>
      PlayerStats(
        id: id ?? this.id,
        playerId: playerId ?? this.playerId,
        health: health ?? this.health,
        energy: energy ?? this.energy,
        happiness: happiness ?? this.happiness,
        money: money ?? this.money,
        intelligence: intelligence ?? this.intelligence,
        social: social ?? this.social,
        fitness: fitness ?? this.fitness,
        career: career ?? this.career,
        hunger: hunger ?? this.hunger,
        stress: stress ?? this.stress,
        reputation: reputation ?? this.reputation,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
