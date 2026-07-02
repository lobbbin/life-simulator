import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/conversation_message.dart';
import '../providers/settings_provider.dart';

class AiResponse {
  final String narration;
  final List<String> suggestedActions;
  final Map<String, dynamic>? statChanges;

  AiResponse({
    required this.narration,
    this.suggestedActions = const [],
    this.statChanges,
  });
}

class AiService {
  String? _apiKey;
  String _provider = 'openai';
  String _model = 'gpt-4';

  void configure(SettingsProvider settings) {
    _apiKey = settings.apiKey;
    _provider = settings.aiProvider;
    _model = settings.aiModel;
    // streaming setting stored in settings provider
  }

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  String get provider => _provider;
  String get model => _model;

  Future<AiResponse> sendPrompt({
    required String systemPrompt,
    required List<ConversationMessage> recentMessages,
    String? userMessage,
  }) async {
    if (!isConfigured) {
      return _fallbackResponse(userMessage: userMessage ?? '');
    }

    final messages = _buildMessages(systemPrompt, recentMessages, userMessage);
    final endpoint = _getEndpoint();

    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: _getHeaders(),
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'temperature': 0.8,
          'max_tokens': 2048,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'] ?? '';
        return _parseResponse(content);
      } else {
        return _fallbackResponse(userMessage: userMessage ?? '');
      }
    } catch (e) {
      return _fallbackResponse(userMessage: userMessage ?? '');
    }
  }

  List<Map<String, dynamic>> _buildMessages(
    String systemPrompt,
    List<ConversationMessage> recentMessages,
    String? userMessage,
  ) {
    final messages = <Map<String, dynamic>>[
      {'role': 'system', 'content': systemPrompt},
    ];

    for (final msg in recentMessages) {
      String role;
      switch (msg.role) {
        case 'player':
          role = 'user';
          break;
        case 'npc':
          role = 'assistant';
          break;
        default:
          role = 'assistant';
      }
      messages.add({'role': role, 'content': msg.content});
    }

    if (userMessage != null && userMessage.isNotEmpty) {
      messages.add({'role': 'user', 'content': userMessage});
    }

    return messages;
  }

  Map<String, String> _getHeaders() {
    switch (_provider) {
      case 'openai':
        return {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        };
      case 'anthropic':
        return {
          'x-api-key': _apiKey ?? '',
          'anthropic-version': '2023-06-01',
          'Content-Type': 'application/json',
        };
      case 'openrouter':
        return {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        };
      default:
        return {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        };
    }
  }

  String _getEndpoint() {
    switch (_provider) {
      case 'openai':
        return 'https://api.openai.com/v1/chat/completions';
      case 'anthropic':
        return 'https://api.anthropic.com/v1/messages';
      case 'openrouter':
        return 'https://openrouter.ai/api/v1/chat/completions';
      case 'google':
        return 'https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey';
      default:
        return 'https://api.openai.com/v1/chat/completions';
    }
  }

  AiResponse _parseResponse(String content) {
    String narration = content;
    List<String> actions = [];
    Map<String, dynamic>? statChanges;

    // Extract ACTIONS section
    final actionsRegex = RegExp(r'ACTIONS:\s*(.+?)(?:\n|$)', dotAll: true);
    final actionsMatch = actionsRegex.firstMatch(content);
    if (actionsMatch != null) {
      try {
        final actionsJson = actionsMatch.group(1)?.trim() ?? '';
        final parsed = jsonDecode(actionsJson);
        if (parsed is List) {
          actions = parsed.map((e) => e.toString()).toList();
        }
      } catch (_) {
        // If not JSON, treat as comma-separated
        actions = actionsMatch.group(1)?.split(',').map((s) => s.trim()).toList() ?? [];
      }
      narration = narration.replaceAll(actionsMatch.group(0) ?? '', '');
    }

    // Extract STAT_CHANGES section
    final statsRegex = RegExp(r'STAT_CHANGES:\s*(.+?)(?:\n|$)', dotAll: true);
    final statsMatch = statsRegex.firstMatch(content);
    if (statsMatch != null) {
      try {
        statChanges = jsonDecode(statsMatch.group(1)?.trim() ?? '{}') as Map<String, dynamic>;
      } catch (_) {
        statChanges = {};
      }
      narration = narration.replaceAll(statsMatch.group(0) ?? '', '');
    }

    // Clean up NARRATION prefix
    narration = narration.replaceAll(RegExp(r'^NARRATION:\s*'), '').trim();

    return AiResponse(
      narration: narration,
      suggestedActions: actions,
      statChanges: statChanges,
    );
  }

  /// Fallback response when AI is not configured — generates a basic simulation response
  AiResponse _fallbackResponse({required String userMessage}) {
    final actions = ['Check your stats', 'Go for a walk', 'Check your phone', 'Talk to someone'];

    return AiResponse(
      narration: _generateFallbackNarration(userMessage),
      suggestedActions: actions,
      statChanges: {'energy': -5, 'happiness': -2},
    );
  }

  String _generateFallbackNarration(String userMessage) {
    final responses = [
      "The world continues around you. Each moment brings new possibilities and challenges.",
      "Life moves forward. The choices you make today shape the person you become tomorrow.",
      "Another moment passes in the grand tapestry of life. What will you make of it?",
      "Time flows like a river, carrying you along its current. Where will you steer?",
    ];
    return responses[userMessage.length % responses.length];
  }
}
