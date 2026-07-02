import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Map')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final locations = provider.locations;
          final current = provider.currentLocation;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map, size: 64, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            '${locations.length} known locations',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          if (current != null)
                            Text(
                              'Currently at: ${current.name}',
                              style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ...locations.map((loc) => ListTile(
                      leading: Icon(
                        Icons.place,
                        color: loc.id == current?.id ? Colors.blue : Colors.grey,
                      ),
                      title: Text(loc.name),
                      subtitle: Text(loc.locationType.replaceAll('_', ' ')),
                      trailing: loc.id == current?.id
                          ? const Icon(Icons.my_location, color: Colors.blue, size: 16)
                          : const Icon(Icons.near_me, size: 16),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
