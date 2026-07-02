import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/player_provider.dart';
import '../models/memory.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Life Timeline')),
      body: Consumer<PlayerProvider>(
        builder: (context, provider, _) {
          final memories = provider.memories;

          if (memories.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timeline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No memories yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text('Live your life to create memories!', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: memories.length,
            itemBuilder: (context, index) {
              final memory = memories[index];
              return _buildTimelineItem(memory, index == 0);
            },
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(Memory memory, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: memory.isCore
                        ? Colors.amber
                        : memory.importance >= 7
                            ? Colors.blue
                            : Colors.grey[400],
                  ),
                  child: Center(
                    child: Icon(
                      memory.isCore ? Icons.star : Icons.circle,
                      size: memory.isCore ? 10 : 8,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (!isFirst)
                  Expanded(
                    child: Container(width: 2, color: Colors.grey[300]),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${memory.timestamp.year}/${memory.timestamp.month}/${memory.timestamp.day}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          ),
                          const Spacer(),
                          if (memory.importance >= 7)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'IMPORTANT',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ),
                          if (memory.isCore) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.star, size: 12, color: Colors.amber),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(memory.summary,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      if (memory.content != memory.summary) ...[
                        const SizedBox(height: 4),
                        Text(memory.content,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
