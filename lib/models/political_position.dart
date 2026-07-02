class PoliticalPosition {
  final int? id;
  final int playerId;
  final String officeTitle;
  final String jurisdiction; // local, state, national
  final String district;
  final String party;
  final DateTime startedAt;
  final DateTime? endedAt;
  final double performance;

  PoliticalPosition({
    this.id,
    required this.playerId,
    required this.officeTitle,
    this.jurisdiction = 'local',
    this.district = '',
    this.party = 'independent',
    DateTime? startedAt,
    this.endedAt,
    this.performance = 50,
  }) : startedAt = startedAt ?? DateTime.now();

  bool get isCurrent => endedAt == null;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'office_title': officeTitle,
        'jurisdiction': jurisdiction,
        'district': district,
        'party': party,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt?.toIso8601String(),
        'performance': performance,
      };

  factory PoliticalPosition.fromMap(Map<String, dynamic> map) => PoliticalPosition(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        officeTitle: map['office_title'] as String,
        jurisdiction: map['jurisdiction'] as String? ?? 'local',
        district: map['district'] as String? ?? '',
        party: map['party'] as String? ?? 'independent',
        startedAt: DateTime.parse(map['started_at'] as String),
        endedAt: map['ended_at'] != null ? DateTime.parse(map['ended_at'] as String) : null,
        performance: (map['performance'] as num?)?.toDouble() ?? 50,
      );
}
