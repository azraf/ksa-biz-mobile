import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MoreHubScreen extends StatelessWidget {
  const MoreHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('More', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        _section(context, 'Reports', [
          _tile(context, 'Sales Report', Icons.bar_chart, '/more/reports/sales'),
          _tile(context, 'Profit Report', Icons.trending_up, '/more/reports/profit'),
          _tile(context, 'Expense Report', Icons.pie_chart, '/more/reports/expenses'),
          _tile(context, 'Expense Summary', Icons.summarize, '/more/reports/expense-summary'),
        ]),
        _section(context, 'Expenses', [
          _tile(context, 'Expenses', Icons.payments, '/more/expenses/list'),
          _tile(context, 'Expense Categories', Icons.account_tree, '/more/expenses/categories'),
          _tile(context, 'Vehicles', Icons.directions_car, '/more/expenses/vehicles'),
        ]),
        _section(context, 'Catalog', [
          _tile(context, 'Products', Icons.inventory_2, '/more/catalog/products'),
          _tile(context, 'Categories', Icons.category, '/more/catalog/categories'),
          _tile(context, 'Tags', Icons.label, '/more/catalog/tags'),
          _tile(context, 'Brands', Icons.branding_watermark, '/more/catalog/brands'),
          _tile(context, 'Units', Icons.straighten, '/more/catalog/units'),
          _tile(context, 'Promotions', Icons.local_offer, '/more/catalog/promotions'),
        ]),
        _section(context, 'Shipping', [
          _tile(context, 'Countries', Icons.public, '/more/shipping/countries'),
          _tile(context, 'Suppliers', Icons.factory, '/more/shipping/suppliers'),
          _tile(context, 'Containers', Icons.all_inbox, '/more/shipping/containers'),
          _tile(context, 'Purchases', Icons.shopping_cart, '/more/shipping/purchases'),
        ]),
        _section(context, 'Admin', [
          _tile(context, 'Discount approval', Icons.percent, '/more/approval/discount'),
          _tile(context, 'Sales Persons', Icons.people, '/sales/persons'),
          _tile(context, 'Customer Types', Icons.badge, '/customers/types'),
          _tile(context, 'Users', Icons.manage_accounts, '/more/users'),
        ]),
      ],
    );
  }

  Widget _section(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _tile(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(route),
    );
  }
}
