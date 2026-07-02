class Scandal {
  final int? id;
  final int playerId;
  final String title;
  final String description;
  final int severity; // 1-10
  final DateTime exposedAt;
  final bool isResolved;
  final String? resolution;

  Scandal({
    this.id,
    required this.playerId,
    required this.title,
    this.description = '',
    this.severity = 5,
    DateTime? exposedAt,
    this.isResolved = false,
    this.resolution,
  }) : exposedAt = exposedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'title': title,
        'description': description,
        'severity': severity,
        'exposed_at': exposedAt.toIso8601String(),
        'is_resolved': isResolved ? 1 : 0,
        'resolution': resolution,
      };

  factory Scandal.fromMap(Map<String, dynamic> map) => Scandal(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        severity: map['severity'] as int? ?? 5,
        exposedAt: DateTime.parse(map['exposed_at'] as String),
        isResolved: (map['is_resolved'] as int?) == 1,
        resolution: map['resolution'] as String?,
      );
}
