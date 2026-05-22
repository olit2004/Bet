import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/buyer_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(buyerDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Dashboard')),
      body: dashboardAsync.when(
        data: (dashboard) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatCard('Total Bids', dashboard.totalBids),
            _buildStatCard('Active Bids', dashboard.activeBids),
            _buildStatCard('Accepted Bids', dashboard.acceptedBids),
            _buildStatCard('Total Proposals', dashboard.totalProposals),
            _buildStatCard('Pending Proposals', dashboard.pendingProposals),
            _buildStatCard('Accepted Proposals', dashboard.acceptedProposals),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildStatCard(String title, int value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value.toString(), style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
