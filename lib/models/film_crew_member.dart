class FilmCrewMember {
  final int? id;
  final int filmProjectId;
  final int npcId;
  final String role; // director, actor, writer, cinematographer, etc.
  final double salary;
  final double performance;

  FilmCrewMember({
    this.id,
    required this.filmProjectId,
    required this.npcId,
    required this.role,
    this.salary = 0,
    this.performance = 50,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'film_project_id': filmProjectId,
        'npc_id': npcId,
        'role': role,
        'salary': salary,
        'performance': performance,
      };

  factory FilmCrewMember.fromMap(Map<String, dynamic> map) => FilmCrewMember(
        id: map['id'] as int?,
        filmProjectId: map['film_project_id'] as int,
        npcId: map['npc_id'] as int,
        role: map['role'] as String,
        salary: (map['salary'] as num?)?.toDouble() ?? 0,
        performance: (map['performance'] as num?)?.toDouble() ?? 50,
      );
}
