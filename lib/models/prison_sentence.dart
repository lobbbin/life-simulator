class PrisonSentence {
  final int? id;
  final int playerId;
  final int? crimePathId;
  final DateTime startedAt;
  final int sentenceLength; // in days
  final double goodConduct;
  final double inmateRespect;
  final double guardRapport;
  final String status; // serving, paroled, escaped, released

  PrisonSentence({
    this.id,
    required this.playerId,
    this.crimePathId,
    DateTime? startedAt,
    required this.sentenceLength,
    this.goodConduct = 50,
    this.inmateRespect = 0,
    this.guardRapport = 0,
    this.status = 'serving',
  }) : startedAt = startedAt ?? DateTime.now();

  DateTime get estimatedReleaseDate =>
      startedAt.add(Duration(days: sentenceLength));

  int get daysServed => DateTime.now().difference(startedAt).inDays;
  int get daysRemaining => sentenceLength - daysServed;
  bool get isEligibleForParole => daysServed >= sentenceLength ~/ 3;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'crime_path_id': crimePathId,
        'started_at': startedAt.toIso8601String(),
        'sentence_length': sentenceLength,
        'good_conduct': goodConduct,
        'inmate_respect': inmateRespect,
        'guard_rapport': guardRapport,
        'status': status,
      };

  factory PrisonSentence.fromMap(Map<String, dynamic> map) => PrisonSentence(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        crimePathId: map['crime_path_id'] as int?,
        startedAt: DateTime.parse(map['started_at'] as String),
        sentenceLength: map['sentence_length'] as int,
        goodConduct: (map['good_conduct'] as num?)?.toDouble() ?? 50,
        inmateRespect: (map['inmate_respect'] as num?)?.toDouble() ?? 0,
        guardRapport: (map['guard_rapport'] as num?)?.toDouble() ?? 0,
        status: map['status'] as String? ?? 'serving',
      );
}
