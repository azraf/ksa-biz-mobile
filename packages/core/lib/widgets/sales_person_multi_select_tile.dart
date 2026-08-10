import 'package:flutter/material.dart';

import '../models/sales_person.dart';

/// Multi-select "sales person" filter, shown as an expandable checklist —
/// used by both the shop map filter drawer and the order list filter drawer.
class SalesPersonMultiSelectTile extends StatelessWidget {
  const SalesPersonMultiSelectTile({
    super.key,
    required this.salesPersons,
    required this.selectedIds,
    required this.onChanged,
  });

  final List<SalesPersonModel> salesPersons;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final count = selectedIds.length;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        title: Text(count == 0 ? 'Sales person' : 'Sales person ($count)'),
        children: [
          for (final sp in salesPersons)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(sp.name),
              value: selectedIds.contains(sp.id),
              onChanged: (checked) {
                final next = Set<int>.from(selectedIds);
                if (checked == true) {
                  next.add(sp.id);
                } else {
                  next.remove(sp.id);
                }
                onChanged(next);
              },
            ),
        ],
      ),
    );
  }
}
