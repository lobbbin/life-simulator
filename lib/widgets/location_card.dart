import 'package:flutter/material.dart';
import '../models/location.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final bool isCurrent;
  final VoidCallback? onTap;

  const LocationCard({
    super.key,
    required this.location,
    this.isCurrent = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isCurrent
          ? Theme.of(context).colorScheme.primary.withOpacity(0.08)
          : null,
      child: ListTile(
        leading: Icon(
          _getIcon(location.locationType),
          color: isCurrent ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        title: Text(location.name),
        subtitle: Text(location.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrent)
              const Icon(Icons.my_location, size: 16, color: Colors.blue),
            if (location.isCore) ...[
              const SizedBox(width: 4),
              const Icon(Icons.star, size: 14, color: Colors.amber),
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  IconData _getIcon(String type) {
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
