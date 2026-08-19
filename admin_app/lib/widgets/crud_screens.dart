import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:l10n/l10n.dart';

import 'field_config.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef ItemTitle<T> = String Function(T item);
typedef ItemSubtitle<T> = String Function(T item);
typedef OnDelete<T> = Future<void> Function(T item);
typedef SortItems<T> = List<T> Function(List<T> items, ListSortMode mode);

class CrudListScreen<T> extends StatefulWidget {
  const CrudListScreen({
    super.key,
    required this.title,
    required this.loadItems,
    required this.itemTitle,
    required this.onTap,
    this.onAdd,
    this.onDelete,
    this.trailing,
    this.isPending,
    this.embedded = false,
    this.showDrawerButton = false,
    this.itemSubtitle,
    this.sortModes,
    this.initialSortMode,
    this.onSortChanged,
    this.sortItems,
    this.emptyMessage,
    this.emptyActionLabel,
    this.onEmptyAction,
    this.extraActions,
    this.itemLeading,
    this.searchItems,
    this.searchHint,
    this.sectionOf,
  });

  final String title;
  final Future<List<T>> Function() loadItems;
  final ItemTitle<T> itemTitle;
  final void Function(T item) onTap;
  final VoidCallback? onAdd;
  final OnDelete<T>? onDelete;
  final Widget Function(T item)? trailing;
  final bool Function(T item)? isPending;
  final bool embedded;
  final bool showDrawerButton;
  final ItemSubtitle<T>? itemSubtitle;
  final List<ListSortMode>? sortModes;
  final ListSortMode? initialSortMode;
  final ValueChanged<ListSortMode>? onSortChanged;
  final SortItems<T>? sortItems;
  final String? emptyMessage;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;
  final List<Widget>? extraActions;
  final Widget Function(T item)? itemLeading;

  /// Server-side search. When set, the screen gets an end drawer holding the
  /// search field (+ sort), a filter button in the app bar, and the list is
  /// loaded from here instead of [loadItems] while a term is present.
  final Future<PaginatedResponse<T>> Function(String search)? searchItems;
  final String? searchHint;

  /// Section label per item while a search term is active (items arrive
  /// pre-ordered by section from the server).
  final String? Function(T item)? sectionOf;

  @override
  State<CrudListScreen<T>> createState() => _CrudListScreenState<T>();
}

class _CrudListScreenState<T> extends State<CrudListScreen<T>> {
  late Future<List<T>> _future;
  ListSortMode? _sortMode;
  final _searchController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isFuzzy = false;

  String get _search => _searchController.text.trim();
  bool get _searching => widget.searchItems != null && _search.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _sortMode = widget.initialSortMode;
    _future = _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<T>> _load() async {
    if (!_searching) {
      _isFuzzy = false;
      return widget.loadItems();
    }
    final page = await widget.searchItems!(_search);
    _isFuzzy = page.isFuzzy;
    return page.items;
  }

  void _reload() => setState(() => _future = _load());

  List<T> _applySort(List<T> items) {
    // While searching the server orders sections (Active first); keep it.
    if (_searching || _sortMode == null || widget.sortItems == null) return items;
    return widget.sortItems!(items, _sortMode!);
  }

  Widget _buildBody() {
    return FutureBuilder<List<T>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final items = _applySort(snapshot.data ?? []);
        if (items.isEmpty) {
          return EmptyView(
            message: widget.emptyMessage ?? 'No items',
            actionLabel: widget.emptyActionLabel,
            onAction: widget.onEmptyAction,
          );
        }
        final highlight = _searching ? _search : null;
        final children = sectionedChildren<T>(
          items,
          banner: _searching && _isFuzzy ? FuzzyMatchBanner(query: _search) : null,
          sectionOf: (item) => _searching ? widget.sectionOf?.call(item) : null,
          itemBuilder: (item) {
              final pending = widget.isPending?.call(item) ?? false;
              final subtitle = widget.itemSubtitle?.call(item);
              return ListTile(
                leading: widget.itemLeading?.call(item),
                title: HighlightText(widget.itemTitle(item), query: highlight),
                subtitle: subtitle != null && subtitle.isNotEmpty ? HighlightText(subtitle, query: highlight) : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pending)
                      const Chip(
                        label: Text('Pending', style: TextStyle(fontSize: 10)),
                        visualDensity: VisualDensity.compact,
                      ),
                    if (widget.trailing != null) widget.trailing!(item),
                    if (widget.onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await widget.onDelete!(item);
                          _reload();
                        },
                      ),
                  ],
                ),
                onTap: () => widget.onTap(item),
              );
          },
        );
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.separated(
            itemCount: children.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) => children[index],
          ),
        );
      },
    );
  }

  Widget? _filtersDrawer() {
    if (widget.searchItems == null) return null;
    return ListFiltersDrawer(
      searchController: _searchController,
      onSearchChanged: (_) => _reload(),
      searchHint: widget.searchHint,
      sortModes: widget.sortModes ?? const [],
      sort: _sortMode,
      onSortChanged: _onSortSelected,
      onClear: () {
        _searchController.clear();
        _reload();
      },
    );
  }

  void _onSortSelected(ListSortMode mode) {
    setState(() => _sortMode = mode);
    widget.onSortChanged?.call(mode);
    if (widget.sortItems != null && !_searching) {
      setState(() {});
    } else {
      _reload();
    }
  }

  List<Widget> _headerActions() {
    final actions = <Widget>[
      IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
    ];
    if (widget.searchItems == null &&
        widget.sortModes != null &&
        widget.sortModes!.isNotEmpty &&
        _sortMode != null &&
        widget.onSortChanged != null) {
      actions.add(
        ListSortButton(
          modes: widget.sortModes!,
          selected: _sortMode!,
          onSelected: _onSortSelected,
        ),
      );
    }
    if (widget.extraActions != null) {
      actions.addAll(widget.extraActions!);
    }
    if (widget.onAdd != null) {
      actions.add(IconButton(icon: const Icon(Icons.add), onPressed: widget.onAdd));
    }
    if (widget.searchItems != null) {
      // Search + sort live in the end drawer so the list gets the full height.
      actions.add(IconButton(
        tooltip: AppLocalizations.of(context).searchFiltersTitle,
        icon: Badge(isLabelVisible: _searching, smallSize: 8, child: const Icon(Icons.tune)),
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
      ));
    }
    return actions;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      final column = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 8, 0),
            child: Row(
              children: [
                if (widget.showDrawerButton)
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                Expanded(
                  child: Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
                ),
                ..._headerActions(),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      );
      if (widget.searchItems == null) return column;
      return Scaffold(key: _scaffoldKey, endDrawer: _filtersDrawer(), body: column);
    }

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _filtersDrawer(),
      appBar: AppBar(
        leading: widget.showDrawerButton
            ? Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              )
            : null,
        title: Text(widget.title),
        actions: _headerActions(),
      ),
      body: _buildBody(),
    );
  }
}

class CrudFormScreen extends StatefulWidget {
  const CrudFormScreen({
    super.key,
    required this.title,
    required this.fields,
    required this.onSave,
    this.initialValues = const {},
  });

  final String title;
  final List<FieldConfig> fields;
  final Future<void> Function(Map<String, dynamic> values) onSave;
  final Map<String, dynamic> initialValues;

  @override
  State<CrudFormScreen> createState() => _CrudFormScreenState();
}

class _CrudFormScreenState extends State<CrudFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, dynamic> _values;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _values = Map<String, dynamic>.from(widget.initialValues);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: widget.fields.map(_buildField).toList(),
        ),
      ),
    );
  }

  Widget _buildField(FieldConfig field) {
    final value = _values[field.key];
    switch (field.type) {
      case FieldType.boolean:
        return SwitchListTile(
          title: Text(field.label),
          value: value as bool? ?? false,
          onChanged: field.readOnly ? null : (v) => setState(() => _values[field.key] = v),
        );
      case FieldType.dropdown:
        final items = <DropdownMenuItem<dynamic>>[
          if (!field.required)
            const DropdownMenuItem<dynamic>(value: null, child: Text('None')),
          ...?field.options
              ?.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label))),
        ];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(labelText: field.label),
            initialValue: value,
            items: items,
            validator: field.required
                ? (v) => v == null ? 'Required' : null
                : null,
            onChanged: field.readOnly
                ? null
                : (v) => setState(() => _values[field.key] = v),
          ),
        );
      case FieldType.textarea:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label),
            maxLines: 3,
            readOnly: field.readOnly,
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
            onSaved: (v) => _values[field.key] = v,
          ),
        );
      case FieldType.number:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            readOnly: field.readOnly,
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
            onSaved: (v) => _values[field.key] = double.tryParse(v ?? '') ?? int.tryParse(v ?? ''),
          ),
        );
      case FieldType.password:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PasswordTextField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label),
            readOnly: field.readOnly,
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
            onSaved: (v) => _values[field.key] = v,
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label),
            keyboardType: field.type == FieldType.email ? TextInputType.emailAddress : TextInputType.text,
            readOnly: field.readOnly,
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
            onSaved: (v) => _values[field.key] = v,
          ),
        );
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _saving = true);
    try {
      await widget.onSave(_values);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}