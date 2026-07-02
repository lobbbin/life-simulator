import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/business.dart';
import '../providers/career_provider.dart';
import '../providers/player_provider.dart';

class BusinessScreen extends StatelessWidget {
  const BusinessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business'),
        backgroundColor: AppTheme.businessBlue,
      ),
      body: Consumer<CareerProvider>(
        builder: (context, career, _) {
          final businesses = career.businesses;

          if (businesses.isEmpty) {
            return _buildEmptyState(context);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...businesses.map((b) => _buildBusinessCard(b)),
                const SizedBox(height: 16),
                _buildFinancialOverview(businesses),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.store_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No businesses yet', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Start a business through the chat interface.',
              style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildBusinessCard(Business business) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.store, color: AppTheme.businessBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(business.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(business.businessType.replaceAll('_', ' '),
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: business.status == 'operating'
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(business.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: business.status == 'operating' ? Colors.green : Colors.red,
                      )),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _financialRow('Revenue', '\$${business.revenue.toStringAsFixed(0)}', Colors.green),
            _financialRow('Profit', '\$${business.profit.toStringAsFixed(0)}', AppTheme.businessBlue),
            _financialRow('Employees', '${business.employees}', Colors.orange),
            const SizedBox(height: 8),
            _progressRow('Customer Satisfaction', business.customerSatisfaction, Colors.green),
            _progressRow('Industry Reputation', business.industryRep, AppTheme.businessBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialOverview(List<Business> businesses) {
    final totalRevenue = businesses.fold(0.0, (sum, b) => sum + b.revenue);
    final totalProfit = businesses.fold(0.0, (sum, b) => sum + b.profit);
    final totalEmployees = businesses.fold(0, (sum, b) => sum + b.employees);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Financial Overview',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: _overviewItem('Total Revenue', '\$${totalRevenue.toStringAsFixed(0)}', Colors.green)),
                Expanded(child: _overviewItem('Total Profit', '\$${totalProfit.toStringAsFixed(0)}', AppTheme.businessBlue)),
                Expanded(child: _overviewItem('Employees', '$totalEmployees', Colors.orange)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _overviewItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _financialRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _progressRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              Text('${value.toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }
}
