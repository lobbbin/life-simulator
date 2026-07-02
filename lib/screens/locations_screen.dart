import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locations')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final locations = provider.locations;
          final currentLocation = provider.currentLocation;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (currentLocation != null) ...[
                Card(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: ListTile(
                    leading: const Icon(Icons.my_location, color: Colors.blue),
                    title: Text(currentLocation.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Current location'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              ...locations.map((loc) => Card(
                    child: ListTile(
                      leading: Icon(
                        _getLocationIcon(loc.locationType),
                        color: loc.id == currentLocation?.id ? Colors.blue : Colors.grey,
                      ),
                      title: Text(loc.name),
                      subtitle: Text(loc.locationType.replaceAll('_', ' ')),
                      trailing: loc.isCore
                          ? const Icon(Icons.star, color: Colors.amber, size: 16)
                          : null,
                      onTap: loc.id != currentLocation?.id
                          ? () {
                              provider.setCurrentLocation(loc);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Moved to ${loc.name}')),
                              );
                            }
                          : null,
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }

  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'home': return Icons.home;
      case 'neighborhood': return Icons.near_me;
      case 'cafe': return Icons.local_cafe;
      case 'park': return Icons.park;
      case 'grocery': return Icons.shopping_cart;
      case 'gym': return Icons.fitness_center;
      case 'hospital': return Icons.local_hospital;
      case 'school': return Icons.school;
      default: return Icons.place;
    }
  }
}
