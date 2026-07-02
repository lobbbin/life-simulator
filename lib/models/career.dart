class Career {
  final int? id;
  final int playerId;
  final String jobTitle;
  final String company;
  final String industry;
  final double salary;
  final double performanceRating;
  final DateTime startedAt;
  final bool isCurrent;

  Career({
    this.id,
    required this.playerId,
    this.jobTitle = '',
    this.company = '',
    this.industry = '',
    this.salary = 0,
    this.performanceRating = 50,
    DateTime? startedAt,
    this.isCurrent = true,
  }) : startedAt = startedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'job_title': jobTitle,
        'company': company,
        'industry': industry,
        'salary': salary,
        'performance_rating': performanceRating,
        'started_at': startedAt.toIso8601String(),
        'is_current': isCurrent ? 1 : 0,
      };

  factory Career.fromMap(Map<String, dynamic> map) => Career(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        jobTitle: map['job_title'] as String? ?? '',
        company: map['company'] as String? ?? '',
        industry: map['industry'] as String? ?? '',
        salary: (map['salary'] as num?)?.toDouble() ?? 0,
        performanceRating: (map['performance_rating'] as num?)?.toDouble() ?? 50,
        startedAt: DateTime.parse(map['started_at'] as String),
        isCurrent: (map['is_current'] as int?) == 1,
      );
}
