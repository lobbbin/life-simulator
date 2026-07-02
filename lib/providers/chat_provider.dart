import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/conversation_message.dart';
import '../services/ai_service.dart';
import '../services/memory_service.dart';

class ChatProvider extends ChangeNotifier {
  final AiService _aiService;
  final MemoryService _memoryService;
  List<ConversationMessage> _messages = [];
  List<String> _suggestedActions = [];
  bool _isLoading = false;
  String _sessionId = const Uuid().v4();
  String _systemPrompt = '';
  bool _aiConfigured = false;

  ChatProvider(this._aiService, this._memoryService);

  List<ConversationMessage> get messages => _messages;
  List<String> get suggestedActions => _suggestedActions;
  bool get isLoading => _isLoading;
  String get sessionId => _sessionId;
  bool get aiConfigured => _aiConfigured;

  void setSystemPrompt(String prompt) {
    _systemPrompt = prompt;
    _aiConfigured = prompt.isNotEmpty;
  }

  void setAiConfigured(bool configured) {
    _aiConfigured = configured;
    notifyListeners();
  }

  Future<void> addMessage({
    required String content,
    required String role,
    int? npcId,
    Map<String, dynamic>? statChanges,
  }) async {
    final message = ConversationMessage(
      playerId: 0, // Will be set by parent
      sessionId: _sessionId,
      role: role,
      npcId: npcId,
      content: content,
      statChanges: statChanges != null ? _encodeJson(statChanges) : null,
    );

    _messages.add(message);
    notifyListeners();
  }

  Future<String> sendPlayerMessage(String content, {int playerId = 0}) async {
    if (content.trim().isEmpty) return '';

    _isLoading = true;
    notifyListeners();

    // Add player message
    final playerMsg = ConversationMessage(
      playerId: playerId,
      sessionId: _sessionId,
      role: 'player',
      content: content,
    );
    _messages.add(playerMsg);

    try {
      // Get recent messages for context
      final recentMessages = _messages.length > 20
          ? _messages.sublist(_messages.length - 20)
          : _messages;

      // Send to AI
      final response = await _aiService.sendPrompt(
        systemPrompt: _systemPrompt,
        recentMessages: recentMessages,
        userMessage: content,
      );

      // Add AI response
      final aiMsg = ConversationMessage(
        playerId: playerId,
        sessionId: _sessionId,
        role: 'ai',
        content: response.narration,
        statChanges: response.statChanges != null ? _encodeJson(response.statChanges!) : null,
      );
      _messages.add(aiMsg);

      _suggestedActions = response.suggestedActions;

      _isLoading = false;
      notifyListeners();

      return response.narration;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  void clearMessages() {
    _messages.clear();
    _suggestedActions.clear();
    _sessionId = const Uuid().v4();
    notifyListeners();
  }

  void selectSuggestedAction(String action) {
    sendPlayerMessage(action);
  }

  String _encodeJson(Map<String, dynamic> map) {
    return jsonEncode(map);
  }
}
