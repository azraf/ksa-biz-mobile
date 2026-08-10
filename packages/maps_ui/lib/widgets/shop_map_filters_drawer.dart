import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Same sort options as sales_app's Field Map — kept here so admin_app and
/// monitor_app share one definition instead of redeclaring it each.
enum ShopMapSort { name, priority, distance }

const shopMapFrequencyBands = ['frequent', 'regular', 'occasional', 'dormant', 'never'];
const shopMapPaymentReliabilities = ['good', 'fair', 'poor'];

/// Filter/sort/search drawer for the admin & monitor shop map — the same
/// shape as sales_app's `FieldMapScreen._buildFiltersDrawer()`, plus a
/// multi-select "sales person" filter neither app-scoped sales_app screen
/// needs (a rep only ever sees their own book).
///
/// Pure UI: the caller owns all filter state and reacts to the `on*`
/// callbacks (mirrors sales_app's plain `setState` + immediate reload on
/// every change, except search which reloads on submit and sort which is
/// client-side only).
class ShopMapFiltersDrawer extends StatelessWidget {
  const ShopMapFiltersDrawer({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.areas,
    required this.areaId,
    required this.onAreaChanged,
    required this.frequencyBand,
    required this.onFrequencyChanged,
    required this.paymentReliability,
    required this.onPaymentReliabilityChanged,
    required this.priorityMin,
    required this.onPriorityMinChanged,
    required this.inactiveDays,
    required this.onInactiveDaysChanged,
    required this.hasDue,
    required this.onHasDueChanged,
    required this.salesPersons,
    required this.selectedSalesPersonIds,
    required this.onSalesPersonsChanged,
    required this.sort,
    required this.onSortChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final VoidCallback onSearchSubmitted;

  final List<AreaModel> areas;
  final int? areaId;
  final ValueChanged<int?> onAreaChanged;

  final String? frequencyBand;
  final ValueChanged<String?> onFrequencyChanged;

  final String? paymentReliability;
  final ValueChanged<String?> onPaymentReliabilityChanged;

  final int? priorityMin;
  final ValueChanged<int?> onPriorityMinChanged;

  final int? inactiveDays;
  final ValueChanged<int?> onInactiveDaysChanged;

  final bool? hasDue;
  final ValueChanged<bool?> onHasDueChanged;

  final List<SalesPersonModel> salesPersons;
  final Set<int> selectedSalesPersonIds;
  final ValueChanged<Set<int>> onSalesPersonsChanged;

  final ShopMapSort sort;
  final ValueChanged<ShopMapSort> onSortChanged;

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
                labelText: 'Search by name or phone',
                prefixIcon: Icon(Icons.search),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => onSearchSubmitted(),
            ),
            const SizedBox(height: 16),
            if (areas.isNotEmpty) ...[
              _dropdown<int?>(
                label: 'Area',
                value: areaId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All areas')),
                  ...areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
                ],
                onChanged: onAreaChanged,
              ),
              const SizedBox(height: 12),
            ],
            if (salesPersons.isNotEmpty) ...[
              SalesPersonMultiSelectTile(
                salesPersons: salesPersons,
                selectedIds: selectedSalesPersonIds,
                onChanged: onSalesPersonsChanged,
              ),
              const SizedBox(height: 12),
            ],
            _dropdown<String?>(
              label: 'Frequency',
              value: frequencyBand,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any frequency')),
                ...shopMapFrequencyBands.map(
                  (b) => DropdownMenuItem(
                    value: b,
                    child: Text(CustomerMetricsFields(frequencyBand: b).frequencyLabel),
                  ),
                ),
              ],
              onChanged: onFrequencyChanged,
            ),
            const SizedBox(height: 12),
            _dropdown<String?>(
              label: 'Payment',
              value: paymentReliability,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any reliability')),
                ...shopMapPaymentReliabilities.map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(CustomerMetricsFields(paymentReliability: p).paymentLabel),
                  ),
                ),
              ],
              onChanged: onPaymentReliabilityChanged,
            ),
            const SizedBox(height: 12),
            _dropdown<int?>(
              label: 'Min rating',
              value: priorityMin,
              items: [
                const DropdownMenuItem(value: null, child: Text('Any rating')),
                ...List.generate(5, (i) => i + 1).map((r) => DropdownMenuItem(value: r, child: Text('$r+ stars'))),
              ],
              onChanged: onPriorityMinChanged,
            ),
            const SizedBox(height: 12),
            _dropdown<int?>(
              label: 'Inactive for',
              value: inactiveDays,
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(value: 30, child: Text('30+ days')),
                DropdownMenuItem(value: 60, child: Text('60+ days')),
                DropdownMenuItem(value: 90, child: Text('90+ days')),
              ],
              onChanged: onInactiveDaysChanged,
            ),
            const SizedBox(height: 12),
            _dropdown<bool?>(
              label: 'Due',
              value: hasDue,
              items: const [
                DropdownMenuItem(value: null, child: Text('Any')),
                DropdownMenuItem(value: true, child: Text('Has due')),
                DropdownMenuItem(value: false, child: Text('No due')),
              ],
              onChanged: onHasDueChanged,
            ),
            const Divider(height: 32),
            _dropdown<ShopMapSort>(
              label: 'Sort',
              value: sort,
              items: const [
                DropdownMenuItem(value: ShopMapSort.name, child: Text('Name')),
                DropdownMenuItem(value: ShopMapSort.priority, child: Text('Priority rating')),
                DropdownMenuItem(value: ShopMapSort.distance, child: Text('Nearest first')),
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
}
