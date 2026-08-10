import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

const _customerRoles = {'customer_shop', 'customer_van', 'customer_importer'};

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(adminRepositoriesProvider).users;
    return CrudListScreen<AdminUserModel>(
      title: 'Users',
      loadItems: () async => (await repo.listPaginated()).items,
      itemTitle: (u) => '${u.name} (${u.email ?? ''}) — ${u.roles.join(', ')}',
      onTap: (u) => _edit(context, ref, u),
      onAdd: () => _edit(context, ref, null),
      onDelete: (u) => repo.delete(u.id),
      trailing: (u) => u.roles.any(_customerRoles.contains)
          ? const SizedBox.shrink()
          : IconButton(
              icon: const Icon(Icons.swap_horiz),
              tooltip: 'Convert to customer',
              onPressed: () => _convertToCustomer(context, ref, u),
            ),
    );
  }

  void _edit(BuildContext context, WidgetRef ref, AdminUserModel? user) async {
    await ref.read(adminRepositoriesProvider).listRoles();
    if (!context.mounted) return;
    Navigator.push(context, MaterialPageRoute(builder: (_) => CrudFormScreen(
      title: user == null ? 'New User' : 'Edit User',
      initialValues: user == null
          ? {}
          : {'name': user.name, 'email': user.email, 'language': user.language},
      fields: [
        const FieldConfig(key: 'name', label: 'Name', required: true),
        const FieldConfig(key: 'email', label: 'Email', type: FieldType.email, required: true),
        if (user == null) ...[
          const FieldConfig(key: 'password', label: 'Password', type: FieldType.password, required: true),
          const FieldConfig(key: 'password_confirmation', label: 'Confirm Password', type: FieldType.password, required: true),
        ],
        const FieldConfig(
          key: 'roles',
          label: 'Roles (comma-separated)',
          type: FieldType.text,
        ),
      ],
      onSave: (v) async {
        final admin = ref.read(adminRepositoriesProvider);
        final rolesStr = v.remove('roles')?.toString() ?? '';
        final roleList = rolesStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
        if (user == null) {
          v['roles'] = roleList.isEmpty ? ['admin'] : roleList;
          await admin.users.create(v);
        } else {
          await admin.users.update(user.id, v);
          if (roleList.isNotEmpty) {
            await admin.syncUserRoles(user.id, roleList);
          }
        }
      },
    )));
  }

  Future<void> _convertToCustomer(BuildContext context, WidgetRef ref, AdminUserModel user) async {
    final areas = await ref.read(customerRepositoryProvider).areas();
    if (!context.mounted) return;

    String customerType = 'customer_shop';
    int? areaId;
    final nameController = TextEditingController(text: user.name);

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('Convert ${user.name} to a customer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: customerType,
                  decoration: const InputDecoration(labelText: 'Customer type'),
                  items: const [
                    DropdownMenuItem(value: 'customer_shop', child: Text('Shop')),
                    DropdownMenuItem(value: 'customer_van', child: Text('Van')),
                    DropdownMenuItem(value: 'customer_importer', child: Text('Importer')),
                  ],
                  onChanged: (v) => setLocal(() => customerType = v ?? 'customer_shop'),
                ),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                DropdownButtonFormField<int?>(
                  initialValue: areaId,
                  decoration: const InputDecoration(labelText: 'Area'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('None')),
                    ...areas.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
                  ],
                  onChanged: (v) => setLocal(() => areaId = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Convert')),
          ],
        ),
      ),
    );

    if (ok != true || !context.mounted) return;
    try {
      await ref.read(adminRepositoriesProvider).convertUserToCustomer(
            user.id,
            customerType: customerType,
            name: nameController.text.trim(),
            areaId: areaId,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.name} converted to a customer')));
      }
    } catch (e) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}
