import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/routes.dart';
import '../config/theme.dart';
import '../models/career_path.dart';
import '../providers/career_provider.dart';
import '../providers/player_provider.dart';
import '../providers/simulation_provider.dart';

class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Career')),
      body: Consumer2<CareerProvider, PlayerProvider>(
        builder: (context, careerProvider, playerProvider, _) {
          final paths = careerProvider.paths.where((p) => p.isActive).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Career Paths',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'You can pursue up to 3 career paths simultaneously.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),

                if (paths.isEmpty)
                  _buildEmptyState(context)
                else
                  ...paths.map((path) => _buildPathCard(context, path)),

                if (paths.length < 3) ...[
                  const SizedBox(height: 16),
                  _buildNewPathSection(context),
                ],

                const SizedBox(height: 24),
                _buildPathGrid(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const Icon(Icons.work_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No active career paths',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 8),
            const Text('Start a career to begin your professional journey.',
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPathCard(BuildContext context, CareerPath path) {
    final color = AppTheme.getPathColor(path.pathType);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToPath(context, path.pathType),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_getPathIcon(path.pathType), color: color, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPathTitle(path.pathType),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Status: ${path.status}',
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 12),
              _buildRepBars(path),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRepBars(CareerPath path) {
    final reps = _getPathReps(path);
    if (reps.isEmpty) return const SizedBox.shrink();

    return Column(
      children: reps.map((rep) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(rep.label, style: const TextStyle(fontSize: 12)),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: (rep.value ?? 0) / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.getPathColor(path.pathType).withOpacity(0.7),
                  ),
                  minHeight: 6,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 30,
              child: Text('${(rep.value ?? 0).toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      )).toList(),
    );
  }

  List<_RepInfo> _getPathReps(CareerPath path) {
    switch (path.pathType) {
      case 'crime':
        return [
          _RepInfo('Street Cred', path.streetCred),
          _RepInfo('Heat Level', path.heatLevel),
          _RepInfo('Crew Loyalty', path.crewLoyalty),
        ];
      case 'politics':
        return [
          _RepInfo('Approval', path.voterApproval),
          _RepInfo('Party Standing', path.partyStanding),
          _RepInfo('Media Favor', path.mediaFavorability),
        ];
      case 'business':
        return [
          _RepInfo('Industry Rep', path.industryRep),
          _RepInfo('Customer Trust', path.customerTrust),
          _RepInfo('Morale', path.employeeMorale),
        ];
      case 'tycoon':
        return [
          _RepInfo('Investor Cred', path.investorCred),
          _RepInfo('Market Savvy', path.marketSavvy),
          _RepInfo('Public Image', path.publicImage),
        ];
      case 'movie':
        return [
          _RepInfo('Critical Rep', path.criticalRep),
          _RepInfo('Box Office', path.boxOfficeTrack),
          _RepInfo('Industry Status', path.industryStatus),
        ];
      case 'prison':
        return [
          _RepInfo('Inmate Respect', path.inmateRespect),
          _RepInfo('Guard Rapport', path.guardRapport),
        ];
      default:
        return [];
    }
  }

  Widget _buildNewPathSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Start a New Career Path',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...['crime', 'politics', 'business', 'tycoon', 'movie'].map((pathType) {
              final alreadyActive = context
                  .read<CareerProvider>()
                  .paths
                  .any((p) => p.pathType == pathType && p.isActive);

              return ListTile(
                leading: Icon(_getPathIcon(pathType),
                    color: alreadyActive ? Colors.grey : AppTheme.getPathColor(pathType)),
                title: Text(_getPathTitle(pathType)),
                subtitle: Text(_getPathDescription(pathType)),
                enabled: !alreadyActive,
                trailing: alreadyActive
                    ? const Icon(Icons.check, color: Colors.green)
                    : const Icon(Icons.add_circle_outline),
                onTap: alreadyActive
                    ? null
                    : () => _startPath(context, pathType),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPathGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Access', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...['crime', 'politics', 'business', 'tycoon', 'movie', 'prison'].map((pathType) {
          final color = AppTheme.getPathColor(pathType);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(_getPathIcon(pathType), color: color),
              ),
              title: Text(_getPathTitle(pathType)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _navigateToPath(context, pathType),
            ),
          );
        }),
      ],
    );
  }

  void _navigateToPath(BuildContext context, String pathType) {
    final route = _getPathRoute(pathType);
    if (route != null) {
      Navigator.pushNamed(context, route);
    }
  }

  void _startPath(BuildContext context, String pathType) async {
    final simProvider = context.read<SimulationProvider>();
    await simProvider.startCareerPath(pathType);
    await context.read<CareerProvider>().loadCareerData(
          context.read<PlayerProvider>().player!.id!,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Started ${_getPathTitle(pathType)} path!')),
      );
    }
  }

  String? _getPathRoute(String pathType) {
    switch (pathType) {
      case 'crime': return AppRoutes.crime;
      case 'politics': return AppRoutes.politics;
      case 'business': return AppRoutes.business;
      case 'tycoon': return AppRoutes.tycoon;
      case 'movie': return AppRoutes.movie;
      case 'prison': return AppRoutes.prison;
      default: return null;
    }
  }

  IconData _getPathIcon(String pathType) {
    switch (pathType) {
      case 'crime': return Icons.local_police;
      case 'politics': return Icons.account_balance;
      case 'business': return Icons.store;
      case 'tycoon': return Icons.trending_up;
      case 'movie': return Icons.movie;
      case 'prison': return Icons.lock;
      default: return Icons.work;
    }
  }

  String _getPathTitle(String pathType) {
    switch (pathType) {
      case 'crime': return 'Crime';
      case 'politics': return 'Politics';
      case 'business': return 'Business';
      case 'tycoon': return 'Tycoon';
      case 'movie': return 'Movie Producer';
      case 'prison': return 'Prison';
      default: return pathType;
    }
  }

  String _getPathDescription(String pathType) {
    switch (pathType) {
      case 'crime': return 'Street crime, organized crime, white collar crime';
      case 'politics': return 'Local to national political career';
      case 'business': return 'Start and grow a company';
      case 'tycoon': return 'Investments, real estate, markets';
      case 'movie': return 'Become a Hollywood producer';
      default: return '';
    }
  }
}

class _RepInfo {
  final String label;
  final double? value;
  _RepInfo(this.label, this.value);
}
