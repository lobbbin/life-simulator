import 'dart:convert';
import 'dart:math';
import '../database/app_database.dart';
import '../models/memory.dart';

class MemoryService {
  final AppDatabase _database;

  MemoryService(this._database);

  Future<void> saveMemory({
    required int playerId,
    required String content,
    String summary = '',
    int? locationId,
    List<int>? involvedNpcs,
    int importance = 5,
    bool isCore = false,
  }) async {
    final memory = Memory(
      playerId: playerId,
      content: content,
      summary: summary.isEmpty ? _generateSummary(content) : summary,
      locationId: locationId,
      involvedNpcs: involvedNpcs != null ? jsonEncode(involvedNpcs) : null,
      importance: importance,
      isCore: isCore,
    );

    await _database.insert('memories', memory.toMap());

    // Trim old low-importance memories if too many
    await _trimMemories(playerId);
  }

  Future<List<Memory>> getCoreMemories(int playerId) async {
    final results = await _database.query('memories',
        where: 'player_id = ? AND is_core = 1',
        whereArgs: [playerId],
        orderBy: 'importance DESC');
    return results.map((m) => Memory.fromMap(m)).toList();
  }

  Future<List<Memory>> getRecentMemories(int playerId, {int limit = 20}) async {
    final results = await _database.query('memories',
        where: 'player_id = ?',
        whereArgs: [playerId],
        orderBy: 'timestamp DESC',
        limit: limit);
    return results.map((m) => Memory.fromMap(m)).toList();
  }

  Future<List<Memory>> getImportantMemories(int playerId,
      {int minImportance = 5, int limit = 10}) async {
    final results = await _database.query('memories',
        where: 'player_id = ? AND importance >= ?',
        whereArgs: [playerId, minImportance],
        orderBy: 'importance DESC',
        limit: limit);
    return results.map((m) => Memory.fromMap(m)).toList();
  }

  Future<List<Memory>> searchMemories(int playerId, String query) async {
    // Simple keyword search — in production, use embeddings
    final results = await _database.query('memories',
        where: 'player_id = ? AND (content LIKE ? OR summary LIKE ?)',
        whereArgs: [playerId, '%$query%', '%$query%'],
        orderBy: 'importance DESC',
        limit: 20);
    return results.map((m) => Memory.fromMap(m)).toList();
  }

  Future<List<Memory>> getRelevantMemories(int playerId,
      {int? locationId, List<int>? npcIds, int limit = 5}) async {
    // Get memories by location or NPC involvement
    final results = await _database.query('memories',
        where: 'player_id = ?',
        whereArgs: [playerId],
        orderBy: 'importance DESC, timestamp DESC',
        limit: limit * 3);

    var memories = results.map((m) => Memory.fromMap(m)).toList();

    // Score and rank memories by relevance
    if (locationId != null || npcIds != null) {
      for (int i = 0; i < memories.length; i++) {
        int score = 0;
        final mem = memories[i];

        if (locationId != null && mem.locationId == locationId) {
          score += 3;
        }

        if (npcIds != null && mem.involvedNpcs != null) {
          try {
            final involved = jsonDecode(mem.involvedNpcs!) as List;
            if (involved.any((id) => npcIds.contains(id))) {
              score += 3;
            }
          } catch (_) {}
        }

        // Re-sort not needed for simple approach
      }
    }

    return memories.take(limit).toList();
  }

  Future<void> _trimMemories(int playerId) async {
    final results = await _database.query('memories',
        where: 'player_id = ? AND is_core = 0',
        whereArgs: [playerId]);

    if (results.length > 1000) {
      // Delete oldest low-importance memories
      await _database.delete('memories',
          where: 'player_id = ? AND is_core = 0 AND importance <= 3',
          whereArgs: [playerId]);
    }

    // Re-summarize if still too many
    final remaining = await _database.query('memories',
        where: 'player_id = ? AND is_core = 0',
        whereArgs: [playerId]);
    if (remaining.length > 800) {
      // Keep top 500 by importance, then oldest
      await _database.delete('memories',
          where:
              'player_id = ? AND is_core = 0 AND id NOT IN (SELECT id FROM memories WHERE player_id = ? ORDER BY importance DESC, timestamp DESC LIMIT 500)',
          whereArgs: [playerId, playerId]);
    }
  }

  String _generateSummary(String content) {
    if (content.length <= 80) return content;
    return '${content.substring(0, 80)}...';
  }
}
