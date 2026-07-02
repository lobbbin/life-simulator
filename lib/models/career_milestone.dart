class CareerMilestone {
  final int? id;
  final int careerPathId;
  final String milestoneType;
  final String title;
  final String description;
  final DateTime achievedAt;
  final int importance;

  CareerMilestone({
    this.id,
    required this.careerPathId,
    required this.milestoneType,
    required this.title,
    this.description = '',
    DateTime? achievedAt,
    this.importance = 5,
  }) : achievedAt = achievedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'career_path_id': careerPathId,
        'milestone_type': milestoneType,
        'title': title,
        'description': description,
        'achieved_at': achievedAt.toIso8601String(),
        'importance': importance,
      };

  factory CareerMilestone.fromMap(Map<String, dynamic> map) => CareerMilestone(
        id: map['id'] as int?,
        careerPathId: map['career_path_id'] as int,
        milestoneType: map['milestone_type'] as String,
        title: map['title'] as String,
        description: map['description'] as String? ?? '',
        achievedAt: DateTime.parse(map['achieved_at'] as String),
        importance: map['importance'] as int? ?? 5,
      );
}
