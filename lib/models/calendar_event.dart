class CalendarEvent {
  final int? id;
  final int playerId;
  final String title;
  final String description;
  final DateTime eventDate;
  final String eventType;
  final String recurring; // none, daily, weekly, yearly
  final int? locationId;
  final String? involvedNpcs; // JSON array
  final bool isCompleted;

  CalendarEvent({
    this.id,
    required this.playerId,
    required this.title,
    this.description = '',
    required this.eventDate,
    this.eventType = 'general',
    this.recurring = 'none',
    this.locationId,
    this.involvedNpcs,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'player_id': playerId,
        'title': title,
        'description': description,
        'event_date': eventDate.toIso8601String(),
        'event_type': eventType,
        'recurring': recurring,
        'location_id': locationId,
        'involved_npcs': involvedNpcs,
        'is_completed': isCompleted ? 1 : 0,
      };

  factory CalendarEvent.fromMap(Map<String, dynamic> map) => CalendarEvent(
        id: map['id'] as int?,
        playerId: map['player_id'] as int,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        eventDate: DateTime.parse(map['event_date'] as String),
        eventType: map['event_type'] as String? ?? 'general',
        recurring: map['recurring'] as String? ?? 'none',
        locationId: map['location_id'] as int?,
        involvedNpcs: map['involved_npcs'] as String?,
        isCompleted: (map['is_completed'] as int?) == 1,
      );
}
