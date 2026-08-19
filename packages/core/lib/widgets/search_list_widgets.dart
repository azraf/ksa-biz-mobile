import 'dart:async';

import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import '../support/list_sort_mode.dart';
import '../support/search_match.dart';
import '../theme/app_colors.dart';
import 'v3_building_blocks.dart';

/// [Text] that lights up every whitespace-separated word of [query] inside
/// [text] (case-insensitive, Arabic-folded — same tokens the server matched).
class HighlightText extends StatelessWidget {
  const HighlightText(
    this.text, {
    super.key,
    required this.query,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final String? query;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final words = SearchMatch.tokens(query ?? '').map(SearchMatch.normalize).toList();
    if (words.isEmpty || text.isEmpty) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }
    // Match on the normalised string; slice the original by the same indices
    // (normalisation only lower-cases / folds single code units, so lengths
    // line up).
    final norm = SearchMatch.normalize(text);
    final ranges = <(int, int)>[];
    for (final w in words) {
      var from = 0;
      while (true) {
        final i = norm.indexOf(w, from);
        if (i < 0) break;
        ranges.add((i, i + w.length));
        from = i + w.length;
      }
    }
    if (ranges.isEmpty || norm.length != text.length) {
      return Text(text, style: style, maxLines: maxLines, overflow: overflow);
    }
    ranges.sort((a, b) => a.$1.compareTo(b.$1));
    final mark = TextStyle(
      backgroundColor: AppColors.warningContainer(context),
      fontWeight: FontWeight.w600,
    );
    final spans = <TextSpan>[];
    var cursor = 0;
    for (final (s, e) in ranges) {
      if (e <= cursor) continue;
      final start = s < cursor ? cursor : s;
      if (start > cursor) spans.add(TextSpan(text: text.substring(cursor, start)));
      spans.add(TextSpan(text: text.substring(start, e), style: mark));
      cursor = e;
    }
    if (cursor < text.length) spans.add(TextSpan(text: text.substring(cursor)));
    return Text.rich(
      TextSpan(children: spans),
      style: style,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Search field with clear button and a built-in 300 ms debounce.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? hint;
  final bool autofocus;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onText);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onText);
    super.dispose();
  }

  void _onText() {
    setState(() {}); // clear-button visibility
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => widget.onChanged(widget.controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        labelText: widget.hint ?? AppLocalizations.of(context).commonSearch,
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                tooltip: AppLocalizations.of(context).commonClear,
                onPressed: () => widget.controller.clear(),
              ),
      ),
      onSubmitted: (v) {
        _debounce?.cancel();
        widget.onChanged(v.trim());
      },
    );
  }
}

/// One-line notice above a list when the server (or the offline matcher)
/// fell back to "most likely" results.
class FuzzyMatchBanner extends StatelessWidget {
  const FuzzyMatchBanner({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.warningContainer(context),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
      child: Text(
        AppLocalizations.of(context).searchNoExactMatch(query),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.warning(context)),
      ),
    );
  }
}

/// Builds `ListView` children from [items], inserting a [SectionHeader]
/// whenever [sectionOf] changes (items must already be ordered by section —
/// the server does that while a search term is active).
List<Widget> sectionedChildren<T>(
  List<T> items, {
  required String? Function(T item) sectionOf,
  required Widget Function(T item) itemBuilder,
  Widget? banner,
}) {
  final out = <Widget>[if (banner != null) banner];
  String? prev;
  for (final item in items) {
    final section = sectionOf(item);
    if (section != null && section != prev) {
      out.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: SectionHeader(title: section),
      ));
    }
    prev = section;
    out.add(itemBuilder(item));
  }
  return out;
}

/// Right-side drawer holding search / status / sort for a list screen, so the
/// list itself gets the full screen height (same shape as OrderFiltersDrawer).
/// Pure UI: the caller owns all state.
class ListFiltersDrawer extends StatelessWidget {
  const ListFiltersDrawer({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.searchHint,
    this.sortModes = const [],
    this.sort,
    this.onSortChanged,
    this.statusOptions = const [],
    this.status,
    this.onStatusChanged,
    required this.onClear,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final String? searchHint;

  final List<ListSortMode> sortModes;
  final ListSortMode? sort;
  final ValueChanged<ListSortMode>? onSortChanged;

  /// value → label. Empty = no status control.
  final List<MapEntry<String, String>> statusOptions;
  final String? status;
  final ValueChanged<String?>? onStatusChanged;

  final VoidCallback onClear;

  String _sortLabel(AppLocalizations l10n, ListSortMode mode) => switch (mode) {
        ListSortMode.date => l10n.commonSortByDate,
        ListSortMode.name => l10n.commonSortAz,
        ListSortMode.area => l10n.commonSortByArea,
        ListSortMode.salesPerson => l10n.commonSortBySalesPerson,
        ListSortMode.distance => l10n.commonSortNearest,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.searchFiltersTitle, style: Theme.of(context).textTheme.titleLarge),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            AppSearchField(controller: searchController, onChanged: onSearchChanged, hint: searchHint, autofocus: true),
            if (statusOptions.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<String?>(
                initialValue: status,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.commonStatus, isDense: true),
                items: statusOptions.map((e) => DropdownMenuItem<String?>(value: e.key, child: Text(e.value))).toList(),
                onChanged: onStatusChanged,
              ),
            ],
            if (sortModes.isNotEmpty && sort != null) ...[
              const SizedBox(height: AppSpacing.lg),
              DropdownButtonFormField<ListSortMode>(
                initialValue: sort,
                isExpanded: true,
                decoration: InputDecoration(labelText: l10n.commonSort, isDense: true),
                items: sortModes.map((m) => DropdownMenuItem(value: m, child: Text(_sortLabel(l10n, m)))).toList(),
                onChanged: (v) {
                  if (v != null) onSortChanged?.call(v);
                },
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear),
              label: Text(l10n.commonClearFilters),
            ),
          ],
        ),
      ),
    );
  }
}

/// App-bar button that opens the end drawer; shows a dot when a filter is active.
class FiltersDrawerButton extends StatelessWidget {
  const FiltersDrawerButton({super.key, required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) => IconButton(
        tooltip: AppLocalizations.of(ctx).searchFiltersTitle,
        icon: Badge(isLabelVisible: active, smallSize: 8, child: const Icon(Icons.tune)),
        onPressed: () => Scaffold.of(ctx).openEndDrawer(),
      ),
    );
  }
}
