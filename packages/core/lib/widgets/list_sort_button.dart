import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../support/list_sort_mode.dart';

class ListSortButton extends StatelessWidget {
  const ListSortButton({
    super.key,
    required this.modes,
    required this.selected,
    required this.onSelected,
  });

  final List<ListSortMode> modes;
  final ListSortMode selected;
  final ValueChanged<ListSortMode> onSelected;

  String _label(BuildContext context, ListSortMode mode) {
    final l10n = AppLocalizations.of(context);
    switch (mode) {
      case ListSortMode.date:
        return l10n.commonSortByDate;
      case ListSortMode.name:
        return l10n.commonSortAz;
      case ListSortMode.area:
        return l10n.commonSortByArea;
      case ListSortMode.salesPerson:
        return l10n.commonSortBySalesPerson;
      case ListSortMode.distance:
        return l10n.commonSortNearest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ListSortMode>(
      tooltip: AppLocalizations.of(context).commonSort,
      icon: const Icon(Icons.sort),
      initialValue: selected,
      onSelected: onSelected,
      itemBuilder: (context) => modes
          .map(
            (mode) => PopupMenuItem(
              value: mode,
              child: Row(
                children: [
                  if (mode == selected)
                    const Icon(Icons.check, size: 18)
                  else
                    const SizedBox(width: 18),
                  const SizedBox(width: 8),
                  Text(_label(context, mode)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Block customer create when offline; show go-online message.
bool tryOpenQuickCreateCustomer({
  required BuildContext context,
  required bool isOnline,
}) {
  if (isOnline) return true;
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.salesCustomerCreateGoOnline)),
  );
  return false;
}
