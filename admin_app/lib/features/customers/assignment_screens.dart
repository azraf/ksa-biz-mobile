import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import 'location_map_screen.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

class AreasScreen extends ConsumerWidget {
  const AreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(customerRepositoryProvider);
    return CrudListScreen<AreaModel>(
      title: 'Areas',
      loadItems: () => repo.areas(),
      itemTitle: (a) => a.name,
      onTap: (a) => _edit(context, ref, a),
      onAdd: () => _edit(context, ref, null),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, AreaModel? area) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CrudFormScreen(
          title: area == null ? 'New Area' : 'Edit Area',
          initialValues: {'name': area?.name ?? '', 'code': area?.code ?? ''},
          fields: const [
            FieldConfig(key: 'name', label: 'Name', required: true),
            FieldConfig(key: 'code', label: 'Code'),
          ],
          onSave: (v) async {
            if (area == null) {
              await ref.read(customerRepositoryProvider).createArea(
                    name: v['name'] as String,
                    code: v['code'] as String?,
                  );
            } else {
              await ref.read(apiClientProvider).put('/areas/${area.id}', body: v);
            }
          },
        ),
      ),
    );
  }
}

class CustomerAssignmentsScreen extends ConsumerStatefulWidget {
  const CustomerAssignmentsScreen({super.key});

  @override
  ConsumerState<CustomerAssignmentsScreen> createState() => _CustomerAssignmentsScreenState();
}

class _CustomerAssignmentsScreenState extends ConsumerState<CustomerAssignmentsScreen> {
  int? _salesPersonFilter;
  List<SalesPersonModel> _salesPersons = [];
  List<CustomerAssignmentModel> _assignments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      _salesPersons = (await repo.salesPersons()).items;
      final result = await repo.assignments(salesPersonId: _salesPersonFilter);
      _assignments = result.items;
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _bulkCover() async {
    final areas = await ref.read(customerRepositoryProvider).areas();
    if (!mounted || areas.isEmpty) return;
    int? areaId = areas.first.id;
    int? fromSpId;
    int? toSpId;
    final reasonController = TextEditingController(text: 'cover');
    final daysController = TextEditingController(text: '7');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Temporary area cover'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  initialValue: areaId,
                  decoration: const InputDecoration(labelText: 'Area'),
                  items: areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                  onChanged: (v) => setLocal(() => areaId = v),
                ),
                DropdownButtonFormField<int?>(
                  initialValue: fromSpId,
                  decoration: const InputDecoration(labelText: 'From salesperson'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Any')),
                    ..._salesPersons.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
                  ],
                  onChanged: (v) => setLocal(() => fromSpId = v),
                ),
                DropdownButtonFormField<int>(
                  initialValue: toSpId,
                  decoration: const InputDecoration(labelText: 'To salesperson *'),
                  items: _salesPersons.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                  onChanged: (v) => setLocal(() => toSpId = v),
                ),
                TextField(controller: reasonController, decoration: const InputDecoration(labelText: 'Reason')),
                TextField(controller: daysController, decoration: const InputDecoration(labelText: 'Days')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Apply')),
          ],
        ),
      ),
    );

    if (ok != true || toSpId == null || areaId == null) return;
    final days = int.tryParse(daysController.text.trim()) ?? 7;
    try {
      final count = await ref.read(customerRepositoryProvider).bulkTemporaryAssignment({
        'area_id': areaId,
        'from_sales_person_id': ?fromSpId,
        'to_sales_person_id': toSpId,
        'starts_at': DateTime.now().toIso8601String(),
        'ends_at': DateTime.now().add(Duration(days: days)).toIso8601String(),
        'reason': reasonController.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Created $count assignments')));
        _load();
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer assignments'),
        actions: [
          IconButton(onPressed: _bulkCover, icon: const Icon(Icons.swap_horiz), tooltip: 'Bulk cover'),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField<int?>(
                    initialValue: _salesPersonFilter,
                    decoration: const InputDecoration(labelText: 'Salesperson'),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ..._salesPersons.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))),
                    ],
                    onChanged: (v) {
                      setState(() => _salesPersonFilter = v);
                      _load();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _assignments.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final a = _assignments[i];
                      return ListTile(
                        title: Text('${a.customerType} · SP ${a.salesPersonName ?? a.salesPersonId}'),
                        subtitle: Text('${a.assignmentKind}${a.endsAt != null ? ' until ${a.endsAt}' : ''}'),
                        trailing: Chip(
                          label: Text(a.active ? 'Active' : 'Ended', style: const TextStyle(fontSize: 10)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class ShopMapScreen extends StatelessWidget {
  const ShopMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminLocationMapScreen();
  }
}

class ChurnRiskScreen extends ConsumerStatefulWidget {
  const ChurnRiskScreen({super.key});

  @override
  ConsumerState<ChurnRiskScreen> createState() => _ChurnRiskScreenState();
}

class _ChurnRiskScreenState extends ConsumerState<ChurnRiskScreen> {
  List<CustomerShopModel> _shops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      _shops = await ref.read(customerRepositoryProvider).churnRisk(days: 90);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Churn risk (90d)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _shops.length,
              itemBuilder: (_, i) => ListTile(
                title: Text(_shops[i].name),
                subtitle: Text(_shops[i].areaName ?? ''),
                trailing: const Chip(label: Text('At risk', style: TextStyle(fontSize: 10))),
              ),
            ),
    );
  }
}

class UnassignedCustomersScreen extends ConsumerStatefulWidget {
  const UnassignedCustomersScreen({super.key});

  @override
  ConsumerState<UnassignedCustomersScreen> createState() => _UnassignedCustomersScreenState();
}

class _UnassignedCustomersScreenState extends ConsumerState<UnassignedCustomersScreen> {
  List<CustomerShopModel> _shops = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _shops = await ref.read(customerRepositoryProvider).unassignedCustomers();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unassigned customers')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              child: _shops.isEmpty
                  ? const ListTile(title: Text('All customers are assigned'))
                  : ListView.builder(
                      itemCount: _shops.length,
                      itemBuilder: (_, i) => ListTile(
                        title: Text(_shops[i].name),
                        subtitle: Text(_shops[i].areaName ?? 'No area'),
                      ),
                    ),
            ),
    );
  }
}

class AssignmentCalendarScreen extends ConsumerStatefulWidget {
  const AssignmentCalendarScreen({super.key});

  @override
  ConsumerState<AssignmentCalendarScreen> createState() => _AssignmentCalendarScreenState();
}

class _AssignmentCalendarScreenState extends ConsumerState<AssignmentCalendarScreen> {
  List<CustomerAssignmentModel> _items = [];
  bool _loading = true;
  String? _overlapWarning;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _items = await ref.read(customerRepositoryProvider).assignmentCalendar();
      _overlapWarning = _detectOverlaps(_items);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  String? _detectOverlaps(List<CustomerAssignmentModel> items) {
    final temporaries = items.where((a) => a.assignmentKind == 'temporary').toList();
    for (var i = 0; i < temporaries.length; i++) {
      for (var j = i + 1; j < temporaries.length; j++) {
        final a = temporaries[i];
        final b = temporaries[j];
        if (a.salesPersonId == b.salesPersonId) continue;
        if (a.customerType == b.customerType &&
            a.customerShopId != null &&
            a.customerShopId == b.customerShopId) {
          return 'Overlap detected for shop #${a.customerShopId}';
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignment calendar')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (_overlapWarning != null)
                  MaterialBanner(
                    content: Text(_overlapWarning!),
                    leading: Icon(Icons.warning_amber, color: AppColors.warning(context)),
                    actions: [TextButton(onPressed: () {}, child: const SizedBox.shrink())],
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final a = _items[i];
                      return ListTile(
                        leading: Icon(
                          a.assignmentKind == 'temporary' ? Icons.event : Icons.person_pin,
                        ),
                        title: Text('${a.salesPersonName ?? 'SP ${a.salesPersonId}'} · ${a.customerType}'),
                        subtitle: Text(
                          '${a.startsAt ?? ''}${a.endsAt != null ? ' → ${a.endsAt}' : ''}${a.reason != null ? ' · ${a.reason}' : ''}',
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class AssignmentAuditScreen extends ConsumerStatefulWidget {
  const AssignmentAuditScreen({super.key});

  @override
  ConsumerState<AssignmentAuditScreen> createState() => _AssignmentAuditScreenState();
}

class _AssignmentAuditScreenState extends ConsumerState<AssignmentAuditScreen> {
  List<Map<String, dynamic>> _logs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      _logs = await ref.read(customerRepositoryProvider).assignmentLogs();
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _exportCsv() async {
    if (_logs.isEmpty) return;
    const header = 'action,customer_type,sales_person_id,assignment_kind,reason,created_at';
    final rows = _logs.map((log) {
      return [
        log['action'],
        log['customer_type'],
        log['sales_person_id'],
        log['assignment_kind'],
        log['reason'],
        log['created_at'],
      ].map((v) => '"${(v ?? '').toString().replaceAll('"', '""')}"').join(',');
    });
    final csv = [header, ...rows].join('\n');
    await Clipboard.setData(ClipboardData(text: csv));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audit log copied to clipboard as CSV')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment audit log'),
        actions: [
          IconButton(onPressed: _logs.isEmpty ? null : _exportCsv, icon: const Icon(Icons.download)),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _logs.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final log = _logs[i];
                return ListTile(
                  title: Text('${log['action']} · ${log['customer_type'] ?? ''}'),
                  subtitle: Text(
                    'SP ${log['sales_person_id']} · ${log['created_at'] ?? ''}',
                  ),
                );
              },
            ),
    );
  }
}

class SalesPersonTerritoryScreen extends ConsumerStatefulWidget {
  const SalesPersonTerritoryScreen({super.key});

  @override
  ConsumerState<SalesPersonTerritoryScreen> createState() => _SalesPersonTerritoryScreenState();
}

class _SalesPersonTerritoryScreenState extends ConsumerState<SalesPersonTerritoryScreen> {
  List<SalesPersonModel> _salesPersons = [];
  List<AreaModel> _areas = [];
  List<SalesPersonAreaModel> _territories = [];
  int? _selectedSp;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final repo = ref.read(customerRepositoryProvider);
      _salesPersons = (await repo.salesPersons()).items;
      _areas = await repo.areas();
      _territories = await repo.salesPersonAreas(salesPersonId: _selectedSp);
    } catch (_) {}
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _assignArea() async {
    if (_selectedSp == null || _areas.isEmpty) return;
    int? areaId = _areas.first.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Assign area to salesperson'),
          content: DropdownButtonFormField<int>(
            initialValue: areaId,
            items: _areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
            onChanged: (v) => setLocal(() => areaId = v),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Assign')),
          ],
        ),
      ),
    );
    if (ok != true || areaId == null) return;
    await ref.read(customerRepositoryProvider).createSalesPersonArea(
          salesPersonId: _selectedSp!,
          areaId: areaId!,
        );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salesperson territories'),
        actions: [
          IconButton(
            onPressed: _selectedSp == null ? null : _assignArea,
            icon: const Icon(Icons.add),
            tooltip: 'Assign area',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: DropdownButtonFormField<int?>(
                    initialValue: _selectedSp,
                    decoration: const InputDecoration(labelText: 'Salesperson'),
                    items: _salesPersons
                        .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                        .toList(),
                    onChanged: (v) {
                      setState(() => _selectedSp = v);
                      _load();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: _territories.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final t = _territories[i];
                      return ListTile(
                        title: Text(t.areaName ?? 'Area ${t.areaId}'),
                        subtitle: Text(t.salesPersonName ?? 'SP ${t.salesPersonId}'),
                        trailing: Chip(
                          label: Text(t.active ? 'Active' : 'Ended', style: const TextStyle(fontSize: 10)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class SalesPersonDashboardScreen extends ConsumerStatefulWidget {
  const SalesPersonDashboardScreen({super.key});

  @override
  ConsumerState<SalesPersonDashboardScreen> createState() => _SalesPersonDashboardScreenState();
}

class _SalesPersonDashboardScreenState extends ConsumerState<SalesPersonDashboardScreen> {
  List<SalesPersonModel> _salesPersons = [];
  int? _selectedSp;
  Map<String, dynamic> _stats = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSalesPersons();
  }

  Future<void> _loadSalesPersons() async {
    try {
      _salesPersons = (await ref.read(customerRepositoryProvider).salesPersons()).items;
      if (_salesPersons.isNotEmpty && _selectedSp == null) {
        _selectedSp = _salesPersons.first.id;
      }
    } catch (_) {}
    await _loadStats();
  }

  Future<void> _loadStats() async {
    if (_selectedSp == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      _stats = await ref.read(customerRepositoryProvider).salesPersonDashboard(
            salesPersonId: _selectedSp!,
          );
    } catch (_) {
      _stats = {};
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final byArea = (_stats['by_area'] as List<dynamic>? ?? []);
    return Scaffold(
      appBar: AppBar(title: const Text('Salesperson dashboard')),
      body: _loading && _salesPersons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DropdownButtonFormField<int?>(
                  initialValue: _selectedSp,
                  decoration: const InputDecoration(labelText: 'Salesperson'),
                  items: _salesPersons
                      .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                      .toList(),
                  onChanged: (v) {
                    setState(() => _selectedSp = v);
                    _loadStats();
                  },
                ),
                const SizedBox(height: 16),
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  _statCard('Total assigned', '${_stats['total_assigned'] ?? 0}'),
                  _statCard('Active (30 days)', '${_stats['active_30d'] ?? 0}'),
                  _statCard('Inactive (60+ days)', '${_stats['inactive_60d_plus'] ?? 0}'),
                  const SizedBox(height: 16),
                  Text('By area', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (byArea.isEmpty)
                    const ListTile(title: Text('No area breakdown'))
                  else
                    ...byArea.map((row) {
                      final m = row as Map<String, dynamic>;
                      return ListTile(
                        title: Text(m['area_name']?.toString() ?? 'Unassigned area'),
                        trailing: Text('${m['count'] ?? 0}'),
                      );
                    }),
                ],
              ],
            ),
    );
  }

  Widget _statCard(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: Theme.of(context).textTheme.headlineSmall),
      ),
    );
  }
}
