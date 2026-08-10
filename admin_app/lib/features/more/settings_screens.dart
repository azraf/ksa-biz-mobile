import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

/// Pricing visibility + VAT policy — the mobile equivalent of the desktop
/// panel's Settings page. Same `settings` key/value rows, same admin-only gate.
class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  Map<String, dynamic>? _settings;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final settings = await ref.read(adminRepositoriesProvider).getSettings();
      setState(() => _settings = settings);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pricing & VAT Settings')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!),
              const SizedBox(height: 12),
              FilledButton(onPressed: _load, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    final settings = _settings;
    if (settings == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return CrudFormScreen(
      title: 'Pricing & VAT Settings',
      initialValues: {
        'hide_supplier_cost_price': settings['hide_supplier_cost_price'] == '1',
        'order_include_vat_default': settings['order_include_vat_default'] == '1',
        'order_vat_always_include_ids': settings['order_vat_always_include_ids'] ?? '',
        'order_vat_always_exclude_ids': settings['order_vat_always_exclude_ids'] ?? '',
      },
      fields: const [
        FieldConfig(
          key: 'hide_supplier_cost_price',
          label: 'Hide supplier cost price',
          type: FieldType.boolean,
        ),
        FieldConfig(
          key: 'order_include_vat_default',
          label: 'Include VAT by default',
          type: FieldType.boolean,
        ),
        FieldConfig(
          key: 'order_vat_always_include_ids',
          label: 'Always include VAT for customer IDs (comma-separated)',
        ),
        FieldConfig(
          key: 'order_vat_always_exclude_ids',
          label: 'Always exclude VAT for customer IDs (comma-separated)',
        ),
      ],
      onSave: (v) => ref.read(adminRepositoriesProvider).updateSettings(v),
    );
  }
}
