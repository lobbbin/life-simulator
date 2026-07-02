import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/inventory_item.dart';
import '../providers/player_provider.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final items = provider.inventory;
          final categories = _groupByCategory(items);

          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No items in inventory', style: TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: categories.entries.map((entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    '${entry.key} (${entry.value.length})',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ...entry.value.map((item) => _buildItemTile(item)),
              ],
            )).toList(),
          );
        },
      ),
    );
  }

  Map<String, List<InventoryItem>> _groupByCategory(List<InventoryItem> items) {
    final map = <String, List<InventoryItem>>{};
    for (final item in items) {
      map.putIfAbsent(item.category, () => []).add(item);
    }
    return map;
  }

  Widget _buildItemTile(InventoryItem item) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCategoryColor(item.category).withOpacity(0.1),
          child: Icon(_getCategoryIcon(item.category), color: _getCategoryColor(item.category), size: 20),
        ),
        title: Text(item.name),
        subtitle: Text(
          '${item.description.isNotEmpty ? '${item.description} • ' : ''}Qty: ${item.quantity}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          '${(item.condition * 100).toStringAsFixed(0)}%',
          style: TextStyle(color: item.condition > 0.7 ? Colors.green : Colors.orange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'food': return Icons.restaurant;
      case 'clothing': return Icons.checkroom;
      case 'electronics': return Icons.devices;
      case 'books': return Icons.book;
      case 'furniture': return Icons.chair;
      case 'tools': return Icons.build;
      case 'documents': return Icons.description;
      case 'key_item': return Icons.vpn_key;
      default: return Icons.inventory_2;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'food': return Colors.orange;
      case 'clothing': return Colors.pink;
      case 'electronics': return Colors.blue;
      case 'books': return Colors.brown;
      case 'furniture': return Colors.deepOrange;
      case 'tools': return Colors.grey;
      case 'documents': return Colors.teal;
      case 'key_item': return Colors.amber;
      default: return Colors.grey;
    }
  }
}
