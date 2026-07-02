class Player {
  final int? id;
  final String name;
  final int age;
  final DateTime createdAt;
  final DateTime lastPlayed;
  final int totalTimePlayed;
  final bool isAlive;
  final String? causeOfDeath;

  Player({
    this.id,
    required this.name,
    this.age = 3,
    DateTime? createdAt,
    DateTime? lastPlayed,
    this.totalTimePlayed = 0,
    this.isAlive = true,
    this.causeOfDeath,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastPlayed = lastPlayed ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'age': age,
        'created_at': createdAt.toIso8601String(),
        'last_played': lastPlayed.toIso8601String(),
        'total_time_played': totalTimePlayed,
        'is_alive': isAlive ? 1 : 0,
        'cause_of_death': causeOfDeath,
      };

  factory Player.fromMap(Map<String, dynamic> map) => Player(
        id: map['id'] as int?,
        name: map['name'] as String,
        age: map['age'] as int? ?? 3,
        createdAt: DateTime.parse(map['created_at'] as String),
        lastPlayed: DateTime.parse(map['last_played'] as String),
        totalTimePlayed: map['total_time_played'] as int? ?? 0,
        isAlive: (map['is_alive'] as int?) == 1,
        causeOfDeath: map['cause_of_death'] as String?,
      );

  Player copyWith({
    int? id,
    String? name,
    int? age,
    DateTime? createdAt,
    DateTime? lastPlayed,
    int? totalTimePlayed,
    bool? isAlive,
    String? causeOfDeath,
  }) =>
      Player(
        id: id ?? this.id,
        name: name ?? this.name,
        age: age ?? this.age,
        createdAt: createdAt ?? this.createdAt,
        lastPlayed: lastPlayed ?? this.lastPlayed,
        totalTimePlayed: totalTimePlayed ?? this.totalTimePlayed,
        isAlive: isAlive ?? this.isAlive,
        causeOfDeath: causeOfDeath ?? this.causeOfDeath,
      );
}
