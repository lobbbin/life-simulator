import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../providers/simulation_provider.dart';
import '../config/routes.dart';

class HeirSelectionScreen extends StatefulWidget {
  const HeirSelectionScreen({super.key});

  @override
  State<HeirSelectionScreen> createState() => _HeirSelectionScreenState();
}

class _HeirSelectionScreenState extends State<HeirSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  int? _selectedHeirId;
  List<Map<String, dynamic>> _heirs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHeirs();
  }

  Future<void> _loadHeirs() async {
    final simProvider = context.read<SimulationProvider>();
    if (simProvider.currentPlayerId != null) {
      final heirs = await simProvider.engine.getHeirs(simProvider.currentPlayerId!);
      setState(() {
        _heirs = heirs;
        _loading = false;
      });
    } else {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Your Heir'),
        backgroundColor: Colors.grey[800],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(Icons.family_restroom, size: 48, color: Colors.amber),
                          const SizedBox(height: 12),
                          const Text(
                            'Continue the Legacy',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Choose a descendant to continue playing as. '
                            'They will inherit a portion of the family assets and reputation.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Potential Heirs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  if (_heirs.isEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Icon(Icons.people_outline, size: 48, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text('No family members found',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text(
                              'Since you have no heir, your legacy ends here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[500], fontSize: 13),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.chat, (route) => false),
                              child: const Text('Start New Life'),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._heirs.map((npc) => Card(
                          color: _selectedHeirId == npc['id']
                              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                              : null,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber.withOpacity(0.2),
                              child: Text(
                                (npc['name'] as String?)?.substring(0, 1).toUpperCase() ?? '?',
                                style: const TextStyle(color: Colors.amber),
                              ),
                            ),
                            title: Text(npc['name'] as String? ?? 'Unknown'),
                            subtitle: Text(
                              'Age ${npc['age'] ?? '?'}'
                              '${(npc['occupation'] as String?)?.isNotEmpty == true ? ' • ${npc['occupation']}' : ''}',
                            ),
                            trailing: Radio<int>(
                              value: npc['id'] as int,
                              groupValue: _selectedHeirId,
                              onChanged: (value) {
                                setState(() => _selectedHeirId = value);
                                _nameController.text = npc['name'] as String? ?? '';
                              },
                            ),
                            onTap: () {
                              setState(() => _selectedHeirId = npc['id'] as int);
                              _nameController.text = npc['name'] as String? ?? '';
                            },
                          ),
                        )),
                  if (_selectedHeirId != null) ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Character Name',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Continue as Heir'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[700],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          if (_nameController.text.trim().isNotEmpty) {
                            final simProvider = context.read<SimulationProvider>();
                            await simProvider.startAsHeir(
                              _selectedHeirId!,
                              _nameController.text.trim(),
                            );
                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.chat, (route) => false);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}
