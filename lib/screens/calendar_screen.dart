import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_provider.dart';
import '../providers/player_provider.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Consumer2<TimeProvider, PlayerProvider>(
        builder: (context, timeProvider, playerProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateHeader(timeProvider),
                const SizedBox(height: 16),
                _buildSeasonInfo(context, timeProvider),
                const SizedBox(height: 16),
                _buildEventsSection(playerProvider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDateHeader(TimeProvider time) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              time.formattedDateTime,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoChip(Icons.wb_sunny, time.season, Colors.orange),
                const SizedBox(width: 8),
                _infoChip(Icons.cloud, time.weather, Colors.blue),
                const SizedBox(width: 8),
                _infoChip(Icons.schedule, time.timeOfDay, Colors.purple),
              ],
            ),
            const SizedBox(height: 8),
            if (time.holiday.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.celebration, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('${time.holiday}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSeasonInfo(BuildContext context, TimeProvider time) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time Controls',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.speed, size: 20),
                const SizedBox(width: 8),
                const Text('Time Speed: '),
                _speedButton(context, 1, time.timeMultiplier),
                _speedButton(context, 2, time.timeMultiplier),
                _speedButton(context, 5, time.timeMultiplier),
                _speedButton(context, 10, time.timeMultiplier),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              time.isWeekend ? 'It\'s the weekend!' : 'It\'s ${time.dayOfWeek}.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _speedButton(BuildContext context, int speed, int current) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: ChoiceChip(
        label: Text('${speed}x', style: const TextStyle(fontSize: 11)),
        selected: speed == current,
        onSelected: (selected) {
          if (selected) {
            context.read<TimeProvider>().setTimeMultiplier(speed);
          }
        },
      ),
    );
  }

  Widget _buildEventsSection(PlayerProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upcoming Events',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (provider.memories.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No upcoming events', style: TextStyle(color: Colors.grey)),
          ))
        else
          ...provider.memories.take(5).map((memory) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: const Icon(Icons.event, size: 16, color: Colors.blue),
                  ),
                  title: Text(memory.summary, maxLines: 1),
                  subtitle: Text(
                    '${memory.timestamp.month}/${memory.timestamp.day}/${memory.timestamp.year}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              )),
      ],
    );
  }
}
