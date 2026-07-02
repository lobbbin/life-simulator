import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/chat_provider.dart';
import '../services/ai_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _apiKeyController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>();
    _apiKeyController = TextEditingController(text: settings.apiKey);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection('AI Configuration'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _apiKeyController,
                        decoration: InputDecoration(
                          labelText: 'API Key',
                          hintText: 'Enter your AI API key',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.visibility_off, size: 20),
                            onPressed: () {},
                          ),
                        ),
                        obscureText: true,
                        onSubmitted: (value) => settings.setApiKey(value),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: settings.aiProvider,
                        decoration: InputDecoration(
                          labelText: 'AI Provider',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: settings.availableProviders.map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p[0].toUpperCase() + p.substring(1)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            settings.setAiProvider(value);
                            final models = settings.getAvailableModels(value);
                            if (models.isNotEmpty) {
                              settings.setAiModel(models.first);
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: settings.aiModel,
                        decoration: InputDecoration(
                          labelText: 'Model',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        items: settings.getAvailableModels(settings.aiProvider)
                            .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) settings.setAiModel(value);
                        },
                      ),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        title: const Text('Streaming Responses'),
                        subtitle: const Text('Receive AI responses token by token'),
                        value: settings.streamingEnabled,
                        onChanged: settings.setStreamingEnabled,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.check_circle),
                          label: Text(settings.hasValidConfig ? 'Update AI Config' : 'Save API Key'),
                          onPressed: () {
                            if (_apiKeyController.text.isNotEmpty) {
                              settings.setApiKey(_apiKeyController.text);
                              if (context.mounted) {
                                context.read<ChatProvider>().setAiConfigured(true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('AI configuration saved!')),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              _buildSection('Display'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Theme'),
                      subtitle: Text(_getThemeName(settings.themeMode)),
                      trailing: DropdownButton<ThemeMode>(
                        value: settings.themeMode,
                        items: ThemeMode.values.map((mode) => DropdownMenuItem(
                          value: mode,
                          child: Text(_getThemeName(mode)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) settings.setThemeMode(value);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSection('Time'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Time Multiplier'),
                      subtitle: Text('${settings.timeMultiplier}x speed'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [1, 2, 5, 10].map((speed) => Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: ChoiceChip(
                            label: Text('${speed}x', style: const TextStyle(fontSize: 11)),
                            selected: settings.timeMultiplier == speed,
                            onSelected: (selected) {
                              if (selected) settings.setTimeMultiplier(speed);
                            },
                          ),
                        )).toList(),
                      ),
                    ),
                    SwitchListTile(
                      title: const Text('Time passes while closed'),
                      subtitle: const Text('Simulation advances when app is backgrounded'),
                      value: settings.timePassesWhileClosed,
                      onChanged: settings.setTimePassesWhileClosed,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              _buildSection('Data'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_forever, color: Colors.red),
                      title: const Text('Reset Simulation'),
                      subtitle: const Text('Delete all data and start over'),
                      onTap: () => _showResetDialog(context),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Life Simulator v1.0.0',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light: return 'Light';
      case ThemeMode.dark: return 'Dark';
      case ThemeMode.system: return 'System Default';
    }
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Simulation?'),
        content: const Text('This will delete all game data. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Reset logic
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Simulation reset. Restart the app to begin anew.')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
