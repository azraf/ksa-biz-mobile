import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Reports', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('Read-only business reports'),
        const SizedBox(height: 16),
        _ReportTile(
          title: 'Watch-list',
          subtitle: 'Prospect locations with photos and recordings',
          icon: Icons.bookmark_border,
          onTap: () => context.push('/watchlist'),
        ),
        _ReportTile(
          title: 'Location map',
          subtitle: 'Shops and watch-list pins on map',
          icon: Icons.map_outlined,
          onTap: () => context.push('/reports/map'),
        ),
        _ReportTile(
          title: 'Sales report',
          subtitle: 'Orders and revenue by period',
          icon: Icons.receipt_long,
          onTap: () => context.push('/reports/sales'),
        ),
        _ReportTile(
          title: 'Profit report',
          subtitle: 'Revenue, cost, and profit',
          icon: Icons.trending_up,
          onTap: () => context.push('/reports/profit'),
        ),
        _ReportTile(
          title: 'Expense report',
          subtitle: 'Totals by category',
          icon: Icons.payments_outlined,
          onTap: () => context.push('/reports/expenses'),
        ),
        _ReportTile(
          title: 'Expense summary',
          subtitle: 'Year-to-date by period',
          icon: Icons.summarize_outlined,
          onTap: () => context.push('/reports/expense-summary'),
        ),
      ],
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
