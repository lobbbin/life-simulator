import 'dart:convert';

class NpcCharacter {
  final int? id;
  final String name;
  final int age;
  final String gender;
  final Map<String, dynamic>? personality; // Big 5 traits
  final String backstory;
  final String occupation;
  final int? currentLocationId;
  final Map<String, dynamic>? schedule; // daily routine
  final bool isCore;
  final DateTime createdAt;

  NpcCharacter({
    this.id,
    required this.name,
    this.age = 30,
    this.gender = 'unknown',
    this.personality,
    this.backstory = '',
    this.occupation = '',
    this.currentLocationId,
    this.schedule,
    this.isCore = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'name': name,
        'age': age,
        'gender': gender,
        'personality': personality != null ? jsonEncode(personality) : null,
        'backstory': backstory,
        'occupation': occupation,
        'current_location_id': currentLocationId,
        'schedule': schedule != null ? jsonEncode(schedule) : null,
        'is_core': isCore ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory NpcCharacter.fromMap(Map<String, dynamic> map) => NpcCharacter(
        id: map['id'] as int?,
        name: map['name'] as String,
        age: map['age'] as int? ?? 30,
        gender: map['gender'] as String? ?? 'unknown',
        personality: map['personality'] != null
            ? jsonDecode(map['personality'] as String) as Map<String, dynamic>
            : null,
        backstory: map['backstory'] as String? ?? '',
        occupation: map['occupation'] as String? ?? '',
        currentLocationId: map['current_location_id'] as int?,
        schedule: map['schedule'] != null
            ? jsonDecode(map['schedule'] as String) as Map<String, dynamic>
            : null,
        isCore: (map['is_core'] as int?) == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}
