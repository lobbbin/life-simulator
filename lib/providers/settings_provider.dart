import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _apiKey = '';
  String _aiProvider = 'openai';
  String _aiModel = 'gpt-4';
  bool _streamingEnabled = false;
  ThemeMode _themeMode = ThemeMode.system;
  int _timeMultiplier = 1;
  bool _timePassesWhileClosed = true;
  int _timePassMinutesOnClose = 60;

  String get apiKey => _apiKey;
  String get aiProvider => _aiProvider;
  String get aiModel => _aiModel;
  bool get streamingEnabled => _streamingEnabled;
  ThemeMode get themeMode => _themeMode;
  int get timeMultiplier => _timeMultiplier;
  bool get timePassesWhileClosed => _timePassesWhileClosed;
  int get timePassMinutesOnClose => _timePassMinutesOnClose;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('api_key') ?? '';
    _aiProvider = prefs.getString('ai_provider') ?? 'openai';
    _aiModel = prefs.getString('ai_model') ?? 'gpt-4';
    _streamingEnabled = prefs.getBool('streaming') ?? false;
    final themeIndex = prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeIndex.clamp(0, ThemeMode.values.length - 1)];
    _timeMultiplier = prefs.getInt('time_multiplier') ?? 1;
    _timePassesWhileClosed = prefs.getBool('time_passes') ?? true;
    _timePassMinutesOnClose = prefs.getInt('time_pass_minutes') ?? 60;
    notifyListeners();
  }

  Future<void> setApiKey(String key) async {
    _apiKey = key;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_key', key);
    notifyListeners();
  }

  Future<void> setAiProvider(String provider) async {
    _aiProvider = provider;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_provider', provider);
    notifyListeners();
  }

  Future<void> setAiModel(String model) async {
    _aiModel = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ai_model', model);
    notifyListeners();
  }

  Future<void> setStreamingEnabled(bool value) async {
    _streamingEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('streaming', value);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }

  Future<void> setTimeMultiplier(int multiplier) async {
    _timeMultiplier = multiplier;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('time_multiplier', multiplier);
    notifyListeners();
  }

  Future<void> setTimePassesWhileClosed(bool value) async {
    _timePassesWhileClosed = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('time_passes', value);
    notifyListeners();
  }

  Future<void> setTimePassMinutesOnClose(int minutes) async {
    _timePassMinutesOnClose = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('time_pass_minutes', minutes);
    notifyListeners();
  }

  bool get hasValidConfig => _apiKey.isNotEmpty;

  List<String> get availableProviders => ['openai', 'anthropic', 'openrouter', 'google'];
  List<String> getAvailableModels(String provider) {
    switch (provider) {
      case 'openai':
        return ['gpt-4', 'gpt-4-turbo', 'gpt-3.5-turbo'];
      case 'anthropic':
        return ['claude-3-opus', 'claude-3-sonnet', 'claude-3-haiku'];
      case 'openrouter':
        return ['openrouter/auto'];
      case 'google':
        return ['gemini-1.5-pro', 'gemini-1.5-flash'];
      default:
        return ['gpt-4'];
    }
  }
}
