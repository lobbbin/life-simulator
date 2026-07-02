import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/player.dart';
import '../models/player_stats.dart';
import '../models/player_skill.dart';
import '../models/player_trait.dart';
import '../models/inventory_item.dart';
import '../models/career.dart';
import '../models/relationship.dart';
import '../models/npc_character.dart';
import '../models/location.dart';
import '../models/career_path.dart';
import '../models/education_stage.dart';
import '../models/memory.dart';

class PlayerProvider extends ChangeNotifier {
  final AppDatabase _database;
  Player? _player;
  PlayerStats? _stats;
  List<PlayerSkill> _skills = [];
  List<PlayerTrait> _traits = [];
  List<InventoryItem> _inventory = [];
  List<Career> _careers = [];
  List<Relationship> _relationships = [];
  List<NpcCharacter> _npcs = [];
  List<Location> _locations = [];
  List<CareerPath> _careerPaths = [];
  List<EducationStage> _educationStages = [];
  List<Memory> _memories = [];
  Location? _currentLocation;

  PlayerProvider(this._database);

  Player? get player => _player;
  PlayerStats? get stats => _stats;
  List<PlayerSkill> get skills => _skills;
  List<PlayerTrait> get traits => _traits;
  List<InventoryItem> get inventory => _inventory;
  List<Career> get careers => _careers;
  List<Relationship> get relationships => _relationships;
  List<NpcCharacter> get npcs => _npcs;
  List<Location> get locations => _locations;
  List<CareerPath> get careerPaths => _careerPaths;
  List<EducationStage> get educationStages => _educationStages;
  List<Memory> get memories => _memories;
  Location? get currentLocation => _currentLocation;

  Future<void> loadPlayer(int playerId) async {
    final playerResult = await _database.queryFirst('players',
        where: 'id = ?', whereArgs: [playerId]);
    if (playerResult == null) return;

    _player = Player.fromMap(playerResult);
    await refreshStats();
    await refreshSkills();
    await refreshTraits();
    await refreshInventory();
    await refreshCareers();
    await refreshRelationships();
    await refreshNpcs();
    await refreshLocations();
    await refreshCareerPaths();
    await refreshEducation();
    await refreshMemories();

    if (_locations.isNotEmpty) {
      _currentLocation = _locations.first;
    }

    notifyListeners();
  }

  Future<void> refreshStats() async {
    if (_player?.id == null) return;
    final result = await _database.queryFirst('player_stats',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    if (result != null) {
      _stats = PlayerStats.fromMap(result);
    }
  }

  Future<void> refreshSkills() async {
    if (_player?.id == null) return;
    final results = await _database.query('player_skills',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _skills = results.map((r) => PlayerSkill.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshTraits() async {
    if (_player?.id == null) return;
    final results = await _database.query('player_traits',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _traits = results.map((r) => PlayerTrait.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshInventory() async {
    if (_player?.id == null) return;
    final results = await _database.query('inventory_items',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _inventory = results.map((r) => InventoryItem.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshCareers() async {
    if (_player?.id == null) return;
    final results = await _database.query('careers',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _careers = results.map((r) => Career.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshRelationships() async {
    if (_player?.id == null) return;
    final results = await _database.query('relationships',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _relationships = results.map((r) => Relationship.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshNpcs() async {
    final results = await _database.query('npc_characters');
    _npcs = results.map((r) => NpcCharacter.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshLocations() async {
    final results = await _database.query('locations');
    _locations = results.map((r) => Location.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshCareerPaths() async {
    if (_player?.id == null) return;
    final results = await _database.query('career_paths',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _careerPaths = results.map((r) => CareerPath.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshEducation() async {
    if (_player?.id == null) return;
    final results = await _database.query('education_stages',
        where: 'player_id = ?', whereArgs: [_player!.id]);
    _educationStages = results.map((r) => EducationStage.fromMap(r)).toList();
    notifyListeners();
  }

  Future<void> refreshMemories() async {
    if (_player?.id == null) return;
    final results = await _database.query('memories',
        where: 'player_id = ?', whereArgs: [_player!.id],
        orderBy: 'timestamp DESC', limit: 50);
    _memories = results.map((r) => Memory.fromMap(r)).toList();
    notifyListeners();
  }

  void setCurrentLocation(Location location) {
    _currentLocation = location;
    notifyListeners();
  }

  NpcCharacter? getNpc(int npcId) {
    try {
      return _npcs.firstWhere((n) => n.id == npcId);
    } catch (_) {
      return null;
    }
  }

  Relationship? getRelationship(int npcId) {
    try {
      return _relationships.firstWhere((r) => r.npcId == npcId);
    } catch (_) {
      return null;
    }
  }

  EducationStage? get currentEducationStage {
    try {
      return _educationStages.firstWhere((s) => s.isCurrent);
    } catch (_) {
      return null;
    }
  }

  double getNetWorth() {
    double total = _stats?.money ?? 0;
    return total;
  }
}
