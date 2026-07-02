class FilmProject {
  final int? id;
  final int playerId;
  final String title;
  final String genre;
  final double budget;
  final double? boxOffice;
  final double? criticalScore;
  final double? audienceScore;
  final String stage; // development, pre_production, production, post, distribution, released
  final int artScore; // 1-10
  final int commerceScore; // 1-10
  final DateTime startedAt;
  final DateTime? releasedAt;

  FilmProject({
    this.id,
    required this.playerId,
    required this.title,
    this.genre = 'drama',
    this.budget = 0,
    this.boxOffice,
    this.criticalScore,
    this.audienceScore,
    this.stage = 'development',
    this.artScore = 5,
    this.commerceScore = 5,
    DateTime? startedAt,
    this.releasedAt,
  }) : startedAt = startedAt ?? DateTime.now();

  double get profitability =>
      boxOffice != null && budget > 0 ? ((boxOffice! - budget) / budget) * 100 : 0;
  bool get isReleased => stage == 'released';

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'title': title,
        'genre': genre,
        'budget': budget,
        'box_office': boxOffice,
        'critical_score': criticalScore,
        'audience_score': audienceScore,
        'stage': stage,
        'art_score': artScore,
        'commerce_score': commerceScore,
        'started_at': startedAt.toIso8601String(),
        'released_at': releasedAt?.toIso8601String(),
      };

  factory FilmProject.fromMap(Map<String, dynamic> map) => FilmProject(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        title: map['title'] as String,
        genre: map['genre'] as String? ?? 'drama',
        budget: (map['budget'] as num?)?.toDouble() ?? 0,
        boxOffice: (map['box_office'] as num?)?.toDouble(),
        criticalScore: (map['critical_score'] as num?)?.toDouble(),
        audienceScore: (map['audience_score'] as num?)?.toDouble(),
        stage: map['stage'] as String? ?? 'development',
        artScore: map['art_score'] as int? ?? 5,
        commerceScore: map['commerce_score'] as int? ?? 5,
        startedAt: DateTime.parse(map['started_at'] as String),
        releasedAt: map['released_at'] != null
            ? DateTime.parse(map['released_at'] as String)
            : null,
      );
}
