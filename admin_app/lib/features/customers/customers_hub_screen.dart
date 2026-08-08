import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

class CustomersHubScreen extends StatelessWidget {
  const CustomersHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.adminCustomersHubTitle, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        ListTile(
          leading: const Icon(Icons.store),
          title: Text(l10n.salesCustomersShops),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/customers/shops'),
        ),
        ListTile(
          leading: const Icon(Icons.map_outlined),
          title: Text(l10n.salesCustomersNearby),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/customers/map'),
        ),
        ListTile(
          leading: const Icon(Icons.assignment_ind),
          title: Text(l10n.adminNavAssignments),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/customers/assignments'),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outline),
          title: Text(l10n.salesCardWatchlist),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/customers/watchlist'),
        ),
      ],
    );
  }
}
