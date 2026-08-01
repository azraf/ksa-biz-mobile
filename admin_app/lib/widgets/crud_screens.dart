import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'field_config.dart';

typedef ItemBuilder<T> = Widget Function(BuildContext context, T item);
typedef ItemTitle<T> = String Function(T item);
typedef OnDelete<T> = Future<void> Function(T item);

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

  @override
  State<CrudListScreen<T>> createState() => _CrudListScreenState<T>();
}

class _CrudListScreenState<T> extends State<CrudListScreen<T>> {
  late Future<List<T>> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.loadItems();
  }

  void _reload() => setState(() => _future = widget.loadItems());

  Widget _buildBody() {
    final listPadding = widget.embedded ? shellBottomPadding(context) : EdgeInsets.zero;

    return FutureBuilder<List<T>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.builder(
            padding: listPadding,
            itemCount: 8,
            itemBuilder: (_, __) => const SkeletonListTile(),
          );
        }
        if (snapshot.hasError) {
          return ErrorView(
            message: snapshot.error.toString(),
            error: snapshot.error,
            onRetry: _reload,
          );
        }
        final items = snapshot.data ?? [];
        if (items.isEmpty) {
          return EmptyView(message: 'No items', actionLabel: widget.onAdd != null ? 'Add' : null, onAction: widget.onAdd);
        }
        return RefreshIndicator(
          onRefresh: () async => _reload(),
          child: ListView.separated(
            padding: listPadding,
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              final pending = widget.isPending?.call(item) ?? false;
              return ListTile(
                title: Text(widget.itemTitle(item)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (pending)
                      const StatusChip(label: 'pending_sync', icon: Icons.cloud_upload_outlined),
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.embedded) {
      return Column(
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
                IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
                if (widget.onAdd != null)
                  IconButton(icon: const Icon(Icons.add), onPressed: widget.onAdd),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(child: _buildBody()),
        ],
      );
    }

    return Scaffold(
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
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
          if (widget.onAdd != null)
            IconButton(icon: const Icon(Icons.add), onPressed: widget.onAdd),
        ],
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
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DropdownButtonFormField<dynamic>(
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
            value: value,
            items: field.options
                ?.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label)))
                .toList(),
            onChanged: field.readOnly ? null : (v) => setState(() => _values[field.key] = v),
          ),
        );
      case FieldType.textarea:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
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
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            readOnly: field.readOnly,
            validator: field.required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
            onSaved: (v) => _values[field.key] = double.tryParse(v ?? '') ?? int.tryParse(v ?? ''),
          ),
        );
      case FieldType.password:
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextFormField(
            initialValue: value?.toString(),
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
            obscureText: true,
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
            decoration: InputDecoration(labelText: field.label, border: const OutlineInputBorder()),
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
