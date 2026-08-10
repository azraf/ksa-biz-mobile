import 'package:flutter/material.dart';

import '../models/sales_person.dart';
import '../support/list_sort_mode.dart';
import 'sales_person_multi_select_tile.dart';

const orderFilterStatuses = ['draft', 'confirmed', 'modified', 'cancelled'];
const orderFilterPaymentStatuses = ['pending', 'partial'];

/// Filter/sort/search drawer for the admin & monitor order list — same shape
/// as `ShopMapFiltersDrawer` (packages/maps_ui), so filtering/sorting/search
/// live in a drawer instead of the app bar and the list gets the full screen.
///
/// Pure UI: the caller owns all filter state and reacts to the `on*`
/// callbacks, same convention as the map's drawer.
class OrderFiltersDrawer extends StatelessWidget {
  const OrderFiltersDrawer({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.status,
    required this.onStatusChanged,
    required this.paymentStatus,
    required this.onPaymentStatusChanged,
    required this.fromDate,
    required this.onFromDateChanged,
    required this.toDate,
    required this.onToDateChanged,
    required this.salesPersons,
    required this.selectedSalesPersonIds,
    required this.onSalesPersonsChanged,
    required this.archived,
    required this.onArchivedChanged,
    required this.sort,
    required this.onSortChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final VoidCallback onSearchSubmitted;

  final String? status;
  final ValueChanged<String?> onStatusChanged;

  final String? paymentStatus;
  final ValueChanged<String?> onPaymentStatusChanged;

  final DateTime? fromDate;
  final ValueChanged<DateTime?> onFromDateChanged;

  final DateTime? toDate;
  final ValueChanged<DateTime?> onToDateChanged;

  final List<SalesPersonModel> salesPersons;
  final Set<int> selectedSalesPersonIds;
  final ValueChanged<Set<int>> onSalesPersonsChanged;

  /// Fully paid orders auto-archive; this toggles between the default
  /// (active only) and archived-only views.
  final bool archived;
  final ValueChanged<bool> onArchivedChanged;

  final ListSortMode sort;
  final ValueChanged<ListSortMode> onSortChanged;

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Filters & sort', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search by order #',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => onSearchSubmitted(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Archived (fully paid)'),
              subtitle: Text(archived ? 'Showing archived orders only' : 'Hidden — showing active orders'),
              value: archived,
              onChanged: onArchivedChanged,
            ),
            const SizedBox(height: 12),
            if (salesPersons.isNotEmpty) ...[
              SalesPersonMultiSelectTile(
                salesPersons: salesPersons,
                selectedIds: selectedSalesPersonIds,
                onChanged: onSalesPersonsChanged,
              ),
              const SizedBox(height: 12),
            ],
            _dropdown<String?>(
              label: 'Status',
              value: status,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any status')),
                ...orderFilterStatuses.map((s) => DropdownMenuItem(value: s, child: Text(_titleCase(s)))),
              ],
              onChanged: onStatusChanged,
            ),
            const SizedBox(height: 12),
            _dropdown<String?>(
              label: 'Payment status',
              value: paymentStatus,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any payment status')),
                ...orderFilterPaymentStatuses.map((s) => DropdownMenuItem(value: s, child: Text(_titleCase(s)))),
              ],
              onChanged: onPaymentStatusChanged,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _dateField(context, label: 'From', value: fromDate, onChanged: onFromDateChanged)),
                const SizedBox(width: 8),
                Expanded(child: _dateField(context, label: 'To', value: toDate, onChanged: onToDateChanged)),
              ],
            ),
            const Divider(height: 32),
            _dropdown<ListSortMode>(
              label: 'Sort',
              value: sort,
              items: const [
                DropdownMenuItem(value: ListSortMode.date, child: Text('Date')),
                DropdownMenuItem(value: ListSortMode.name, child: Text('Customer name')),
                DropdownMenuItem(value: ListSortMode.area, child: Text('Area')),
                DropdownMenuItem(value: ListSortMode.salesPerson, child: Text('Sales person')),
              ],
              onChanged: (v) {
                if (v != null) onSortChanged(v);
              },
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear),
              label: const Text('Clear filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField(
    BuildContext context, {
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime?> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label, isDense: true),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value == null ? 'Any' : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}'),
            if (value != null)
              InkWell(
                onTap: () => onChanged(null),
                child: const Icon(Icons.clear, size: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label, isDense: true),
      items: items,
      onChanged: onChanged,
    );
  }

  String _titleCase(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
