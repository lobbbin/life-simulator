import 'dart:math';
import '../database/app_database.dart';
import '../models/player.dart';
import '../models/player_stats.dart';
import '../models/player_skill.dart';
import '../models/location.dart';
import '../models/career_path.dart';
import '../models/career_milestone.dart';
import '../models/education_stage.dart';
import '../models/memory.dart';
import '../models/will.dart';
import 'time_service.dart';
import 'memory_service.dart';
import 'event_service.dart';
import 'ai_service.dart';

class SimulationEngine {
  final AppDatabase _database;
  final MemoryService _memoryService;
  final TimeService _timeService;
  final EventService _eventService;
  final Random _random = Random();

  int? _currentPlayerId;
  Player? _player;
  PlayerStats? _stats;

  SimulationEngine(this._database, AiService aiService, this._memoryService,
      this._timeService, this._eventService);

  int? get currentPlayerId => _currentPlayerId;
  Player? get player => _player;
  PlayerStats? get stats => _stats;

  Future<void> initialize() async {
    // Check if there's an existing player
    final players = await _database.query('players', orderBy: 'last_played DESC', limit: 1);
    if (players.isNotEmpty) {
      _player = Player.fromMap(players.first);
      _currentPlayerId = _player!.id!;
      _stats = await _getStats(_currentPlayerId!);
    }
  }

  Future<int> createPlayer(String name) async {
    final now = DateTime.now();
    _player = Player(
      name: name,
      age: 3,
      createdAt: now,
      lastPlayed: now,
    );

    final id = await _database.insert('players', _player!.toMap());
    _currentPlayerId = id;
    _player = _player!.copyWith(id: id);

    // Create initial stats
    _stats = PlayerStats(playerId: id);
    await _database.insert('player_stats', _stats!.toMap());

    // Create initial skills
    final skillNames = ['Communication', 'Physical', 'Intellectual', 'Practical', 'Artistic', 'Social'];
    for (final name in skillNames) {
      final skill = PlayerSkill(playerId: id, skillName: name, skillLevel: 1);
      await _database.insert('player_skills', skill.toMap());
    }

    // Create initial education stage (Kindergarten)
    final stage = EducationStage(
      playerId: id,
      stage: 'kindergarten',
      isCurrent: true,
    );
    await _database.insert('education_stages', stage.toMap());

    // Create core locations
    await _createCoreLocations(id);

    // Create initial memories
    await _memoryService.saveMemory(
      playerId: id,
      content: 'You were born into this world, ready to live your life.',
      summary: 'Born and started the journey of life.',
      importance: 10,
      isCore: true,
    );

    await _startEducation(id, 'kindergarten');

    return id;
  }

  Future<void> _createCoreLocations(int playerId) async {
    final locations = [
      Location(name: 'Home', description: 'Your cozy home where you feel safe and comfortable.', locationType: 'home', isCore: true),
      Location(name: 'Neighborhood', description: 'The streets and houses of your local community.', locationType: 'neighborhood', isCore: true),
      Location(name: 'Local Café', description: 'A warm, welcoming café with great coffee and pastries.', locationType: 'cafe', isCore: true),
      Location(name: 'City Park', description: 'A beautiful green space with walking paths and playgrounds.', locationType: 'park', isCore: true),
      Location(name: 'Grocery Store', description: 'Your local supermarket for all your shopping needs.', locationType: 'grocery', isCore: true),
      Location(name: 'Gym', description: 'A well-equipped fitness center to stay in shape.', locationType: 'gym', isCore: true),
      Location(name: 'Hospital', description: 'The local medical center for health needs.', locationType: 'hospital', isCore: true),
    ];

    for (final loc in locations) {
      await _database.insert('locations', loc.toMap());
    }
  }

  Future<PlayerStats> _getStats(int playerId) async {
    final result = await _database.queryFirst('player_stats',
        where: 'player_id = ?', whereArgs: [playerId]);
    return result != null ? PlayerStats.fromMap(result) : PlayerStats(playerId: playerId);
  }

  Future<void> applyStatChanges(Map<String, dynamic>? changes) async {
    if (changes == null || _currentPlayerId == null) return;

    final currentStats = await _getStats(_currentPlayerId!);
    var newStats = currentStats;

    for (final entry in changes.entries) {
      final value = (entry.value as num).toDouble();
      switch (entry.key.toLowerCase()) {
        case 'health':
          newStats = newStats.copyWith(
              health: (currentStats.health + value).clamp(0, 100));
          break;
        case 'energy':
          newStats = newStats.copyWith(
              energy: (currentStats.energy + value).clamp(0, 100));
          break;
        case 'happiness':
          newStats = newStats.copyWith(
              happiness: (currentStats.happiness + value).clamp(0, 100));
          break;
        case 'money':
          newStats = newStats.copyWith(
              money: (currentStats.money + value).clamp(0, double.infinity));
          break;
        case 'intelligence':
          newStats = newStats.copyWith(
              intelligence: (currentStats.intelligence + value).clamp(0, 100));
          break;
        case 'social':
          newStats = newStats.copyWith(
              social: (currentStats.social + value).clamp(0, 100));
          break;
        case 'fitness':
          newStats = newStats.copyWith(
              fitness: (currentStats.fitness + value).clamp(0, 100));
          break;
        case 'career':
          newStats = newStats.copyWith(
              career: (currentStats.career + value).clamp(0, 100));
          break;
        case 'hunger':
          newStats = newStats.copyWith(
              hunger: (currentStats.hunger + value).clamp(0, 100));
          break;
        case 'stress':
          newStats = newStats.copyWith(
              stress: (currentStats.stress + value).clamp(0, 100));
          break;
        case 'reputation':
          newStats = newStats.copyWith(
              reputation: (currentStats.reputation + value).clamp(0, 100));
          break;
      }
    }

    newStats = newStats.copyWith(updatedAt: DateTime.now());

    await _database.update('player_stats', newStats.toMap(),
        where: 'player_id = ?', whereArgs: [_currentPlayerId]);
    _stats = newStats;
  }

  Future<void> advanceAge() async {
    if (_currentPlayerId == null || _player == null) return;

    final newAge = _player!.age + 1;
    _player = _player!.copyWith(age: newAge);
    await _database.update('players', _player!.toMap(),
        where: 'id = ?', whereArgs: [_currentPlayerId]);

    // Check for education stage transitions
    await _checkEducationTransition(newAge);

    // Birthday memory — only save milestone birthdays (every 5 years) to avoid clutter
    if (newAge % 5 == 0 || newAge <= 10) {
      await _memoryService.saveMemory(
        playerId: _currentPlayerId!,
        content: 'You turned $newAge years old.',
        summary: 'Birthday — turned $newAge',
        importance: 6,
      );
    }
  }

  Future<void> _checkEducationTransition(int age) async {
    if (_currentPlayerId == null) return;

    String? newStage;
    if (age == 6) newStage = 'elementary';
    else if (age == 11) newStage = 'middle_school';
    else if (age == 14) newStage = 'high_school';
    else if (age == 18) newStage = 'university';

    if (newStage != null) {
      await _startEducation(_currentPlayerId!, newStage);
    }
  }

  Future<void> _startEducation(int playerId, String stage) async {
    // Mark all current stages as not current
    await _database.update('education_stages', {'is_current': 0},
        where: 'player_id = ? AND is_current = 1', whereArgs: [playerId]);

    // Start new stage
    final newStage = EducationStage(
      playerId: playerId,
      stage: stage,
      isCurrent: true,
    );
    await _database.insert('education_stages', newStage.toMap());

    await _memoryService.saveMemory(
      playerId: playerId,
      content: 'You started ${stage.replaceAll('_', ' ')}.',
      summary: 'Started ${stage.replaceAll('_', ' ')}',
      importance: 8,
      isCore: true,
    );
  }

  Future<void> advanceTime({int minutes = 30}) async {
    _timeService.advanceTime(minutes: minutes);

    // Passive stat changes
    final passiveChanges = <String, dynamic>{
      'energy': -1,
      'hunger': 0.5,
      'stress': -0.5,
    };

    await applyStatChanges(passiveChanges);

    // Check for daily event
    if (_timeService.timeOfDay == 'Morning' && _random.nextDouble() < 0.15) {
      final event = _eventService.getDailyEvent(
        _player?.age ?? 3,
        _timeService.season,
      );
      if (event != null) {
        await applyStatChanges(event.statEffects);
      }
    }
  }

  Future<void> addSkillExperience(int playerId, String skillName, double amount) async {
    final result = await _database.queryFirst('player_skills',
        where: 'player_id = ? AND skill_name = ?',
        whereArgs: [playerId, skillName]);

    if (result != null) {
      final skill = PlayerSkill.fromMap(result);
      final newExp = skill.experience + amount;
      final newLevel = skill.skillLevel + (newExp / 100).floor();
      final remainingExp = newExp % 100;

      await _database.update('player_skills', {
        'skill_level': newLevel.clamp(1, 100),
        'experience': remainingExp,
      }, where: 'id = ?', whereArgs: [skill.id]);
    }
  }

  Future<int> startCareerPath(int playerId, String pathType) async {
    // Check max active paths
    final activePaths = await getActiveCareerPaths(playerId);
    if (activePaths.length >= 3) {
      throw Exception('Maximum of 3 active career paths reached');
    }

    final path = CareerPath(
      playerId: playerId,
      pathType: pathType,
      isActive: true,
      status: 'active',
    );

    final pathId = await _database.insert('career_paths', path.toMap());

    await _memoryService.saveMemory(
      playerId: playerId,
      content: 'You started pursuing a career in ${pathType.replaceAll('_', ' ')}.',
      summary: 'Started career path: ${pathType.replaceAll('_', ' ')}',
      importance: 9,
      isCore: true,
    );

    return pathId;
  }

  Future<List<CareerPath>> getActiveCareerPaths(int playerId) async {
    final results = await _database.query('career_paths',
        where: 'player_id = ? AND is_active = 1 AND status = \'active\'',
        whereArgs: [playerId]);
    return results.map((r) => CareerPath.fromMap(r)).toList();
  }

  Future<void> addMilestone(int careerPathId, String type, String title,
      {String description = '', int importance = 5}) async {
    final milestone = CareerMilestone(
      careerPathId: careerPathId,
      milestoneType: type,
      title: title,
      description: description,
      importance: importance,
    );
    await _database.insert('career_milestones', milestone.toMap());
  }

  Future<void> addMemory(int playerId, String content, String summary,
      {int importance = 5, bool isCore = false}) async {
    await _memoryService.saveMemory(
      playerId: playerId,
      content: content,
      summary: summary,
      importance: importance,
      isCore: isCore,
    );
  }

  Future<List<Memory>> getLifeTimeline(int playerId) async {
    return _memoryService.getRecentMemories(playerId, limit: 100);
  }

  // Death & Inheritance
  Future<void> processDeath(String cause) async {
    if (_currentPlayerId == null || _player == null) return;

    _player = _player!.copyWith(isAlive: false, causeOfDeath: cause);
    await _database.update('players', _player!.toMap(),
        where: 'id = ?', whereArgs: [_currentPlayerId]);

    await _memoryService.saveMemory(
      playerId: _currentPlayerId!,
      content: 'You died: $cause.',
      summary: 'Death: $cause',
      importance: 10,
      isCore: true,
    );
  }

  Future<List<Map<String, dynamic>>> getHeirs(int playerId) async {
    // Get children from family tree
    final results = await _database.query('family_tree',
        where: 'player_id = ? AND relationship = \'child\'',
        whereArgs: [playerId]);

    final heirs = <Map<String, dynamic>>[];
    for (final entry in results) {
      final npcResult = await _database.queryFirst('npc_characters',
          where: 'id = ?', whereArgs: [entry['npc_id']]);
      if (npcResult != null) {
        heirs.add(npcResult);
      }
    }
    return heirs;
  }

  Future<void> executeWill(int deceasedPlayerId) async {
    // Find active will
    final willResult = await _database.queryFirst('wills',
        where: 'player_id = ? AND is_active = 1',
        whereArgs: [deceasedPlayerId]);

    if (willResult != null) {
      final will = Will.fromMap(willResult);
      final bequests = await _database.query('will_bequests',
          where: 'will_id = ?', whereArgs: [will.id]);

      // Execute each bequest (asset transfer logic to be implemented)
    } else {
      // Intestate defaults
      final spouse = await _database.queryFirst('family_tree',
          where: 'player_id = ? AND relationship = \'spouse\'',
          whereArgs: [deceasedPlayerId]);

      if (spouse != null) {
        // Spouse inherits majority
      } else {
        // Children split equally
      }
    }
  }

  Future<int> startAsHeir(int heirNpcId, String newName) async {
    // Create new player character as the heir
    final heirNpc = await _database.queryFirst('npc_characters',
        where: 'id = ?', whereArgs: [heirNpcId]);

    if (heirNpc == null) throw Exception('Heir NPC not found');

    final now = DateTime.now();
    final heirPlayer = Player(
      name: newName,
      age: (heirNpc['age'] as int?) ?? 18,
      createdAt: now,
      lastPlayed: now,
    );

    final id = await _database.insert('players', heirPlayer.toMap());
    _currentPlayerId = id;
    _player = heirPlayer.copyWith(id: id);

    // Create stats for heir (inherited partially)
    if (_stats != null) {
      final heirStats = PlayerStats(
        playerId: id,
        money: _stats!.money * 0.5, // Inherit half the money
        reputation: _stats!.reputation * 0.3, // Carry some reputation
      );
      await _database.insert('player_stats', heirStats.toMap());
      _stats = heirStats;
    }

    await _memoryService.saveMemory(
      playerId: id,
      content: 'You continue the family legacy as $newName.',
      summary: 'Continued as heir: $newName',
      importance: 10,
      isCore: true,
    );

    return id;
  }
}
