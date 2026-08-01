import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/repositories.dart';
import '../../widgets/crud_screens.dart';
import '../../widgets/field_config.dart';

void _showOfflineWriteError(BuildContext context, Object e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(AppErrorMapper.localize(context, e))),
  );
}

class UsersScreen extends ConsumerWidget {
  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = cachedCrud<AdminUserModel>(
      ref: ref,
      remote: ref.watch(adminRepositoriesProvider).users,
      cacheKey: 'users',
      toJson: (u) => {'name': u.name, 'email': u.email, 'language': u.language},
    );
    return CrudListScreen<AdminUserModel>(
      title: 'Users',
      loadItems: () async => (await repo.listParsed(fromJson: AdminUserModel.fromJson)).items,
      itemTitle: (u) => '${u.name} (${u.email ?? ''}) — ${u.roles.join(', ')}',
      onTap: (u) => _edit(context, ref, u),
      onAdd: () => _edit(context, ref, null),
      onDelete: (u) async {
        try {
          await repo.delete(u.id);
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    );
  }

  void _edit(BuildContext context, WidgetRef ref, AdminUserModel? user) async {
    await ref.read(adminRepositoriesProvider).listRoles();
    if (!context.mounted) return;
    final userRepo = cachedCrud<AdminUserModel>(
      ref: ref,
      remote: ref.read(adminRepositoriesProvider).users,
      cacheKey: 'users',
      toJson: (u) => {'name': u.name, 'email': u.email, 'language': u.language},
    );
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
        FieldConfig(
          key: 'roles',
          label: 'Roles (comma-separated)',
          type: FieldType.text,
        ),
      ],
      onSave: (v) async {
        try {
          final admin = ref.read(adminRepositoriesProvider);
          final rolesStr = v.remove('roles')?.toString() ?? '';
          final roleList = rolesStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
          if (user == null) {
            v['roles'] = roleList.isEmpty ? ['admin'] : roleList;
            await userRepo.create(v);
          } else {
            await userRepo.update(user.id, v);
            if (roleList.isNotEmpty) {
              await admin.syncUserRoles(user.id, roleList);
            }
          }
        } catch (e) {
          _showOfflineWriteError(context, e);
          rethrow;
        }
      },
    )));
  }
}
