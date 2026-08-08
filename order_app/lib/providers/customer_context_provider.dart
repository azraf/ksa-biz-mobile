import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'repositories.dart';

class CustomerProfile {
  const CustomerProfile({
    required this.role,
    required this.customerTypeId,
    required this.entityId,
    required this.displayName,
    this.mobile,
    this.email,
    this.shop,
  });

  final String role;
  final int customerTypeId;
  final int entityId;
  final String displayName;
  final String? mobile;
  final String? email;
  final CustomerShopModel? shop;

  bool get isShop => role == 'customer_shop';
  bool get isVan => role == 'customer_van';
  bool get isImporter => role == 'customer_importer';

  Map<String, dynamic> orderCustomerFields() {
    return switch (role) {
      'customer_shop' => {'customer_shop_id': entityId},
      'customer_van' => {'customer_van_id': entityId},
      'customer_importer' => {'customer_importer_id': entityId},
      _ => {},
    };
  }
}

class CustomerContextState {
  const CustomerContextState({
    this.isLoading = false,
    this.profile,
    this.error,
  });

  final bool isLoading;
  final CustomerProfile? profile;
  final String? error;

  CustomerContextState copyWith({
    bool? isLoading,
    CustomerProfile? profile,
    String? error,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return CustomerContextState(
      isLoading: isLoading ?? this.isLoading,
      profile: clearProfile ? null : (profile ?? this.profile),
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class CustomerContextNotifier extends Notifier<CustomerContextState> {
  Future<void>? _loadFuture;

  @override
  CustomerContextState build() {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isAuthenticated) {
        _loadFuture = null;
        state = const CustomerContextState();
        return;
      }
      if (next.isAuthenticated && !next.isLoading && state.profile == null && !state.isLoading) {
        unawaited(load());
      }
    });

    final auth = ref.read(authProvider);
    if (auth.isAuthenticated && !auth.isLoading && state.profile == null) {
      Future.microtask(load);
    }
    return const CustomerContextState(isLoading: true);
  }

  String? _customerRole(AuthState auth) {
    for (final role in customerRoles) {
      if (auth.roles.contains(role)) return role;
    }
    return null;
  }

  Future<void> load() {
    return _loadFuture ??= _loadInternal().whenComplete(() => _loadFuture = null);
  }

  Future<void> _loadInternal() async {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) {
      state = const CustomerContextState();
      return;
    }

    final role = _customerRole(auth);
    if (role == null) {
      state = const CustomerContextState(
        isLoading: false,
        error: 'This account is not a customer (shop, van, or importer).',
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final customerRepo = ref.read(customerRepositoryProvider);
      final linked = await _resolveLinkedCustomer(auth, customerRepo, role);
      if (linked == null) {
        state = CustomerContextState(
          isLoading: false,
          error: 'No ${role.replaceFirst('customer_', '')} profile linked to your account.',
        );
        return;
      }

      final customerTypeId = await _resolveCustomerTypeId(customerRepo, role, linked);
      if (customerTypeId == null) {
        state = CustomerContextState(
          isLoading: false,
          error: 'Customer type "$role" is not configured on the server.',
        );
        return;
      }

      state = CustomerContextState(
        isLoading: false,
        profile: linked.copyWith(customerTypeId: customerTypeId),
      );
    } catch (e) {
      state = CustomerContextState(isLoading: false, error: e.toString());
    }
  }

  Future<int?> _resolveCustomerTypeId(
    CustomerRepository customerRepo,
    String role,
    CustomerProfile linked,
  ) async {
    final session = await ref.read(authRepositoryProvider).prepareRestore();
    final typeId = session.session?.linkedCustomer?.customerTypeId;
    if (typeId != null) return typeId;

    final types = await customerRepo.customerTypes();
    final type = types.cast<CustomerTypeModel?>().firstWhere(
          (t) => t?.typeName == role,
          orElse: () => null,
        );
    return type?.id;
  }

  Future<CustomerProfile?> _resolveLinkedCustomer(
    AuthState auth,
    CustomerRepository customerRepo,
    String role,
  ) async {
    final session = await ref.read(authRepositoryProvider).prepareRestore();
    final linked = session.session?.linkedCustomer;
    if (linked != null && linked.type == role) {
      return _profileFromLinked(customerRepo, linked);
    }

    try {
      final userResponse = await ref.read(apiClientProvider).get('/user');
      final linkedJson = userResponse['linked_customer'];
      if (linkedJson is Map<String, dynamic>) {
        final parsed = LinkedCustomerModel.fromJson(linkedJson);
        if (parsed.type == role) {
          return _profileFromLinked(customerRepo, parsed);
        }
      }
    } catch (_) {}

    return null;
  }

  Future<CustomerProfile> _profileFromLinked(
    CustomerRepository customerRepo,
    LinkedCustomerModel linked,
  ) async {
    switch (linked.type) {
      case 'customer_shop':
        final shop = await customerRepo.getShop(linked.id);
        return CustomerProfile(
          role: linked.type,
          customerTypeId: linked.customerTypeId ?? 0,
          entityId: shop.id,
          displayName: shop.name,
          shop: shop,
        );
      case 'customer_van':
        final van = await customerRepo.getVan(linked.id);
        return CustomerProfile(
          role: linked.type,
          customerTypeId: linked.customerTypeId ?? 0,
          entityId: van.id,
          displayName: van.name,
          mobile: van.mobile,
        );
      case 'customer_importer':
        final importer = await customerRepo.getImporter(linked.id);
        return CustomerProfile(
          role: linked.type,
          customerTypeId: linked.customerTypeId ?? 0,
          entityId: importer.id,
          displayName: importer.name,
          mobile: importer.mobile,
        );
      default:
        return CustomerProfile(
          role: linked.type,
          customerTypeId: linked.customerTypeId ?? 0,
          entityId: linked.id,
          displayName: linked.name,
        );
    }
  }
}

extension on CustomerProfile {
  CustomerProfile copyWith({required int customerTypeId}) {
    return CustomerProfile(
      role: role,
      customerTypeId: customerTypeId,
      entityId: entityId,
      displayName: displayName,
      mobile: mobile,
      email: email,
      shop: shop,
    );
  }
}

final customerContextProvider =
    NotifierProvider<CustomerContextNotifier, CustomerContextState>(CustomerContextNotifier.new);
