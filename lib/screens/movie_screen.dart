import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/film_project.dart';
import '../providers/career_provider.dart';

class MovieScreen extends StatelessWidget {
  const MovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Producer'),
        backgroundColor: AppTheme.moviePurple,
      ),
      body: Consumer<CareerProvider>(
        builder: (context, career, _) {
          final projects = career.filmProjects;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRepCards(career),
                const SizedBox(height: 16),
                _buildProjectPipeline(projects),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRepCards(CareerProvider career) {
    final paths = career.paths.where((p) => p.pathType == 'movie').toList();
    if (paths.isEmpty) return const SizedBox.shrink();

    final path = paths.first;
    return Row(
      children: [
        Expanded(child: _repCard('Critical', path.criticalRep ?? 0, Colors.amber)),
        const SizedBox(width: 8),
        Expanded(child: _repCard('Box Office', path.boxOfficeTrack ?? 0, Colors.green)),
        const SizedBox(width: 8),
        Expanded(child: _repCard('Industry', path.industryStatus ?? 0, AppTheme.moviePurple)),
      ],
    );
  }

  Widget _repCard(String label, double value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('${value.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: value / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectPipeline(List<FilmProject> projects) {
    final stages = ['development', 'pre_production', 'production', 'post', 'distribution', 'released'];
    final stageLabels = {
      'development': 'Development',
      'pre_production': 'Pre-Production',
      'production': 'Production',
      'post': 'Post-Production',
      'distribution': 'Distribution',
      'released': 'Released',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Project Pipeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (projects.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No film projects yet', style: TextStyle(color: Colors.grey)),
          ))
        else
          ...stages.map((stage) {
            final stageProjects = projects.where((p) => p.stage == stage).toList();
            if (stageProjects.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 12, height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStageColor(stage),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(stageLabels[stage] ?? stage,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text('(${stageProjects.length})',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
                ...stageProjects.map((project) => _buildFilmCard(project)),
              ],
            );
          }),
      ],
    );
  }

  Widget _buildFilmCard(FilmProject project) {
    return Card(
      margin: const EdgeInsets.only(left: 20, bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(project.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                if (project.isReleased) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('RELEASED', style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Text('${project.genre} • Budget: \$${project.budget.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                _filmMetric('Art', project.artScore, Icons.auto_awesome, Colors.amber),
                const SizedBox(width: 16),
                _filmMetric('Commerce', project.commerceScore, Icons.attach_money, Colors.green),
                if (project.criticalScore != null) ...[
                  const SizedBox(width: 16),
                  _filmMetric('Critics', project.criticalScore!.toInt(), Icons.star, Colors.purple),
                ],
                if (project.boxOffice != null) ...[
                  const SizedBox(width: 16),
                  Text('\$${project.boxOffice!.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.green)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _filmMetric(String label, int value, IconData icon, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text('$label: $value/10', style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Color _getStageColor(String stage) {
    switch (stage) {
      case 'development': return Colors.grey;
      case 'pre_production': return Colors.blue;
      case 'production': return Colors.orange;
      case 'post': return Colors.purple;
      case 'distribution': return Colors.teal;
      case 'released': return Colors.green;
      default: return Colors.grey;
    }
  }
}
