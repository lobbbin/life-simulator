class Location {
  final int? id;
  final String name;
  final String description;
  final String locationType; // home, neighborhood, cafe, park, grocery, gym, hospital, generated
  final bool isCore;
  final DateTime createdAt;

  Location({
    this.id,
    required this.name,
    this.description = '',
    required this.locationType,
    this.isCore = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'description': description,
        'location_type': locationType,
        'is_core': isCore ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory Location.fromMap(Map<String, dynamic> map) => Location(
        id: map['id'] as int?,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        locationType: map['location_type'] as String,
        isCore: (map['is_core'] as int?) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
