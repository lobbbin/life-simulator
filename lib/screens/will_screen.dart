import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/player_provider.dart';

class WillScreen extends StatefulWidget {
  const WillScreen({super.key});

  @override
  State<WillScreen> createState() => _WillScreenState();
}

class _WillScreenState extends State<WillScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Will & Inheritance')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final player = provider.player;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.description, size: 48, color: AppTheme.careerTeal),
                        const SizedBox(height: 12),
                        Text(
                          player?.isAlive == true
                              ? 'Last Will & Testament'
                              : 'Will Execution',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          player?.isAlive == true
                              ? 'Plan what happens to your assets after you pass away.'
                              : 'The will is being executed for the deceased.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (player?.isAlive == true) ...[
                  const Text('Your Assets',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Column(
                      children: [
                        _assetTile('Cash', '\$${provider.stats?.money.toStringAsFixed(0) ?? "0"}', Icons.attach_money),
                        const Divider(),
                        _assetTile('Total Net Worth', '\$${provider.getNetWorth().toStringAsFixed(0)}', Icons.account_balance_wallet),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text('Draft Will',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text(
                            'Will drafting allows you to specify who inherits your assets.\n\n'
                            'In the full version, you can assign each asset to specific beneficiaries.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Will'),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Will editor coming soon!')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  const Text('Will Execution',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, size: 48, color: Colors.green),
                          const SizedBox(height: 12),
                          const Text('The will is being processed.',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Text('Assets are being distributed to beneficiaries.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 16),
                const Text('Intestate Defaults',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _defaultRow('Spouse', 'Majority of assets'),
                        _defaultRow('Children', 'Split remainder equally'),
                        _defaultRow('Parents/Siblings', 'If no spouse/children'),
                        _defaultRow('State', 'If no living family'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _assetTile(String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.careerTeal),
      title: Text(label),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _defaultRow(String heir, String share) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(heir, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(share, style: TextStyle(color: Colors.grey[600], fontSize: 13))),
        ],
      ),
    );
  }
}
