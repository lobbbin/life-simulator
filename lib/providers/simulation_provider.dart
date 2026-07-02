import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/player.dart';
import '../models/player_stats.dart';
import '../models/career_path.dart';
import '../services/ai_service.dart';
import '../services/memory_service.dart';
import '../services/time_service.dart';
import '../services/event_service.dart';
import '../services/simulation_engine.dart';

class SimulationProvider extends ChangeNotifier {
  final SimulationEngine _engine;

  bool _isInitialized = false;
  bool _isNewGame = false;

  SimulationProvider(
    AppDatabase database,
    AiService aiService,
    MemoryService memoryService,
    TimeService timeService,
    EventService eventService,
  ) : _engine = SimulationEngine(
          database, aiService, memoryService, timeService, eventService,
        );

  SimulationEngine get engine => _engine;
  bool get isInitialized => _isInitialized;
  bool get hasActivePlayer => _engine.player != null;
  bool get isNewGame => _isNewGame;
  int? get currentPlayerId => _engine.currentPlayerId;

  Future<void> initialize() async {
    await _engine.initialize();
    _isInitialized = true;
    notifyListeners();
  }

  Future<int> startNewGame(String playerName) async {
    _isNewGame = true;
    final id = await _engine.createPlayer(playerName);
    _isNewGame = false;
    notifyListeners();
    return id;
  }

  Future<void> advanceTime({int minutes = 30}) async {
    await _engine.advanceTime(minutes: minutes);
    notifyListeners();
  }

  Future<void> applyStatChanges(Map<String, dynamic>? changes) async {
    await _engine.applyStatChanges(changes);
    notifyListeners();
  }

  Future<int> startCareerPath(String pathType) async {
    if (_engine.currentPlayerId == null) throw Exception('No active player');
    final pathId = await _engine.startCareerPath(_engine.currentPlayerId!, pathType);
    notifyListeners();
    return pathId;
  }

  Future<List<CareerPath>> getActiveCareerPaths() async {
    if (_engine.currentPlayerId == null) return [];
    return _engine.getActiveCareerPaths(_engine.currentPlayerId!);
  }

  Future<void> processDeath(String cause) async {
    await _engine.processDeath(cause);
    notifyListeners();
  }

  Future<int> startAsHeir(int heirNpcId, String newName) async {
    final id = await _engine.startAsHeir(heirNpcId, newName);
    notifyListeners();
    return id;
  }

  Future<Player> getPlayer() async {
    if (_engine.player != null) return _engine.player!;
    throw Exception('No active player');
  }

  Future<PlayerStats> getStats() async {
    if (_engine.stats != null) return _engine.stats!;
    throw Exception('No stats available');
  }

  Future<void> addMemory(int playerId, String content, String summary,
      {int importance = 5, bool isCore = false}) async {
    await _engine.addMemory(playerId, content, summary,
        importance: importance, isCore: isCore);
    notifyListeners();
  }
}
