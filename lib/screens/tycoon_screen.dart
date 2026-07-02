import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/investment.dart';
import '../providers/career_provider.dart';

class TycoonScreen extends StatelessWidget {
  const TycoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tycoon'),
        backgroundColor: AppTheme.tycoonGreen,
      ),
      body: Consumer<CareerProvider>(
        builder: (context, career, _) {
          final investments = career.investments;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPortfolioOverview(investments),
                const SizedBox(height: 16),
                _buildReputationCards(career),
                const SizedBox(height: 16),
                _buildInvestmentsList(investments),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortfolioOverview(List<Investment> investments) {
    final totalValue = investments.fold(0.0, (sum, inv) => sum + inv.totalValue);
    final totalCost = investments.fold(0.0, (sum, inv) => sum + (inv.purchasePrice * inv.quantity));
    final totalReturn = totalValue - totalCost;
    final returnPercent = totalCost > 0 ? ((totalValue - totalCost) / totalCost * 100) : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Portfolio Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('\$${totalValue.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.tycoonGreen)),
                      const Text('Total Value', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        totalReturn >= 0 ? '+\$${totalReturn.toStringAsFixed(0)}' : '-\$${(-totalReturn).toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: totalReturn >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const Text('Return', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${returnPercent.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: returnPercent >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                      const Text('Return %', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReputationCards(CareerProvider career) {
    final paths = career.paths.where((p) => p.pathType == 'tycoon').toList();
    if (paths.isEmpty) return const SizedBox.shrink();

    final path = paths.first;
    return Row(
      children: [
        Expanded(child: _repCard('Investor Cred', path.investorCred ?? 0, Colors.indigo)),
        const SizedBox(width: 8),
        Expanded(child: _repCard('Market Savvy', path.marketSavvy ?? 0, Colors.teal)),
        const SizedBox(width: 8),
        Expanded(child: _repCard('Public Image', path.publicImage ?? 0, Colors.amber)),
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

  Widget _buildInvestmentsList(List<Investment> investments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Investments',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (investments.isEmpty)
          const Card(child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('No investments yet', style: TextStyle(color: Colors.grey)),
          ))
        else
          ...investments.map((inv) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getAssetColor(inv.assetType).withOpacity(0.1),
                    child: Icon(_getAssetIcon(inv.assetType), color: _getAssetColor(inv.assetType)),
                  ),
                  title: Text(inv.name),
                  subtitle: Text('${inv.assetType.replaceAll('_', ' ')} • Qty: ${inv.quantity.toStringAsFixed(0)}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${inv.totalValue.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '${inv.returnPercentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: inv.returnPercentage >= 0 ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
      ],
    );
  }

  IconData _getAssetIcon(String type) {
    switch (type) {
      case 'stock': return Icons.trending_up;
      case 'real_estate': return Icons.home;
      case 'crypto': return Icons.currency_bitcoin;
      case 'bond': return Icons.description;
      case 'startup': return Icons.rocket_launch;
      case 'art': return Icons.palette;
      default: return Icons.attach_money;
    }
  }

  Color _getAssetColor(String type) {
    switch (type) {
      case 'stock': return Colors.blue;
      case 'real_estate': return Colors.brown;
      case 'crypto': return Colors.orange;
      case 'bond': return Colors.teal;
      case 'startup': return Colors.purple;
      case 'art': return Colors.pink;
      default: return Colors.grey;
    }
  }
}
