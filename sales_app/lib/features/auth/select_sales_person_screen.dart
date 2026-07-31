import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:l10n/l10n.dart';

import '../../providers/auth_provider.dart';
import '../../providers/repositories.dart';

class SelectSalesPersonScreen extends ConsumerStatefulWidget {
  const SelectSalesPersonScreen({super.key});

  @override
  ConsumerState<SelectSalesPersonScreen> createState() => _SelectSalesPersonScreenState();
}

class _SelectSalesPersonScreenState extends ConsumerState<SelectSalesPersonScreen> {
  final _searchController = TextEditingController();
  List<SalesPersonModel> _salesPersons = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await ref.read(customerRepositoryProvider).salesPersons();
      setState(() {
        _salesPersons = result.items;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<SalesPersonModel> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    if (q.isEmpty) return _salesPersons;
    return _salesPersons
        .where((p) => p.name.toLowerCase().contains(q) || (p.email ?? '').toLowerCase().contains(q))
        .toList();
  }

  Future<void> _select(SalesPersonModel person) async {
    await ref.read(authProvider.notifier).selectActiveSalesPerson(person);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.salesSelectSalesperson)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.salesSearchSalesperson,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          Expanded(
            child: _loading
                ? LoadingView(message: l10n.commonLoading)
                : _error != null
                    ? ErrorView(message: _error!, onRetry: _load)
                    : _filtered.isEmpty
                        ? EmptyView(message: l10n.salesNoSalespeople)
                        : ListView.builder(
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) {
                              final person = _filtered[i];
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(person.name),
                                subtitle: Text(person.mobile ?? person.email ?? ''),
                                onTap: () => _select(person),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
