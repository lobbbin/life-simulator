class EducationStage {
  final int? id;
  final int playerId;
  final String stage; // kindergarten, elementary, middle_school, high_school, university
  final bool isCurrent;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String status; // enrolled, graduated, dropped_out, expelled
  final double academicPerformance; // 0-100
  final double socialStatus; // 0-100

  // University-specific
  final String? major;
  final String? minor;
  final double? gpa; // 0.0-4.0
  final int? completedSemesters;

  EducationStage({
    this.id,
    required this.playerId,
    required this.stage,
    this.isCurrent = false,
    DateTime? startedAt,
    this.completedAt,
    this.status = 'enrolled',
    this.academicPerformance = 50,
    this.socialStatus = 50,
    this.major,
    this.minor,
    this.gpa,
    this.completedSemesters,
  }) : startedAt = startedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'stage': stage,
        'is_current': isCurrent ? 1 : 0,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
        'status': status,
        'academic_performance': academicPerformance,
        'social_status': socialStatus,
        'major': major,
        'minor': minor,
        'gpa': gpa,
        'completed_semesters': completedSemesters,
      };

  factory EducationStage.fromMap(Map<String, dynamic> map) => EducationStage(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        stage: map['stage'] as String,
        isCurrent: (map['is_current'] as int?) == 1,
        startedAt: DateTime.parse(map['started_at'] as String),
        completedAt: map['completed_at'] != null
            ? DateTime.parse(map['completed_at'] as String)
            : null,
        status: map['status'] as String? ?? 'enrolled',
        academicPerformance: (map['academic_performance'] as num?)?.toDouble() ?? 50,
        socialStatus: (map['social_status'] as num?)?.toDouble() ?? 50,
        major: map['major'] as String?,
        minor: map['minor'] as String?,
        gpa: (map['gpa'] as num?)?.toDouble(),
        completedSemesters: map['completed_semesters'] as int?,
      );
}
