import 'dart:convert';

class ParsedResponse {
  final String narration;
  final List<String> actions;
  final Map<String, dynamic> statChanges;
  final String? memoryContent;
  final String? memorySummary;
  final int? memoryImportance;

  ParsedResponse({
    required this.narration,
    this.actions = const [],
    this.statChanges = const {},
    this.memoryContent,
    this.memorySummary,
    this.memoryImportance,
  });
}

class ResponseParser {
  ParsedResponse parse(String content) {
    String text = content.trim();
    List<String> actions = [];
    Map<String, dynamic> statChanges = {};
    String? memoryContent;
    String? memorySummary;
    int? memoryImportance;

    // Extract NARRATION
    final narrationRegex = RegExp(r'^NARRATION:\s*(.*?)(?=\n(ACTIONS|STAT_CHANGES|MEMORY)|\Z)', dotAll: true);
    final narrationMatch = narrationRegex.firstMatch(text);
    String narration;
    if (narrationMatch != null) {
      narration = narrationMatch.group(1)?.trim() ?? text;
    } else {
      narration = text;
    }

    // Extract ACTIONS
    final actionsRegex = RegExp(r'ACTIONS:\s*(.+?)(?=\n(STAT_CHANGES|MEMORY)|\Z)', dotAll: true);
    final actionsMatch = actionsRegex.firstMatch(text);
    if (actionsMatch != null) {
      final raw = actionsMatch.group(1)?.trim() ?? '';
      try {
        final parsed = jsonDecode(raw);
        if (parsed is List) {
          actions = parsed.map((e) => e.toString()).toList();
        }
      } catch (_) {
        actions = raw.split('\n').map((s) => s.trim().replaceAll(RegExp(r'^-\s*'), '')).where((s) => s.isNotEmpty).toList();
      }
    }

    // Extract STAT_CHANGES
    final statsRegex = RegExp(r'STAT_CHANGES:\s*(.+?)(?=\n(MEMORY)|\Z)', dotAll: true);
    final statsMatch = statsRegex.firstMatch(text);
    if (statsMatch != null) {
      try {
        statChanges = jsonDecode(statsMatch.group(1)?.trim() ?? '{}') as Map<String, dynamic>;
      } catch (_) {
        statChanges = {};
      }
    }

    // Extract MEMORY
    final memoryRegex = RegExp(r'MEMORY:\s*Content:\s*(.+?)(?:\n\s*Summary:\s*(.+?))?(?:\n\s*Importance:\s*(\d+))?', dotAll: true);
    final memoryMatch = memoryRegex.firstMatch(text);
    if (memoryMatch != null) {
      memoryContent = memoryMatch.group(1)?.trim();
      memorySummary = memoryMatch.group(2)?.trim();
      memoryImportance = int.tryParse(memoryMatch.group(3) ?? '');
    }

    return ParsedResponse(
      narration: narration,
      actions: actions,
      statChanges: statChanges,
      memoryContent: memoryContent,
      memorySummary: memorySummary,
      memoryImportance: memoryImportance,
    );
  }
}
