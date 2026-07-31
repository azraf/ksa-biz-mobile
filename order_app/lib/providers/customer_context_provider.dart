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
  @override
  CustomerContextState build() {
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!next.isAuthenticated) {
        state = const CustomerContextState();
        return;
      }
      if (next.isAuthenticated && !next.isLoading && state.profile == null && !state.isLoading) {
        Future.microtask(load);
      }
    });

    final auth = ref.read(authProvider);
    if (auth.isAuthenticated && !auth.isLoading) {
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

  Future<void> load() async {
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
      final types = await customerRepo.customerTypes();
      final type = types.cast<CustomerTypeModel?>().firstWhere(
            (t) => t?.typeName == role,
            orElse: () => null,
          );
      if (type == null) {
        state = CustomerContextState(
          isLoading: false,
          error: 'Customer type "$role" is not configured on the server.',
        );
        return;
      }

      final email = auth.user?.email?.toLowerCase();
      CustomerProfile? profile;

      if (role == 'customer_shop') {
        final result = await customerRepo.shops(search: email);
        final shop = _matchShop(result.items, email) ?? (result.items.isNotEmpty ? result.items.first : null);
        if (shop == null) {
          state = const CustomerContextState(
            isLoading: false,
            error: 'No shop profile linked to your account.',
          );
          return;
        }
        profile = CustomerProfile(
          role: role,
          customerTypeId: type.id,
          entityId: shop.id,
          displayName: shop.name,
          shop: shop,
        );
      } else if (role == 'customer_van') {
        final result = await customerRepo.vans(search: email);
        final van = _matchVan(result.items, email) ?? (result.items.isNotEmpty ? result.items.first : null);
        if (van == null) {
          state = const CustomerContextState(
            isLoading: false,
            error: 'No van profile linked to your account.',
          );
          return;
        }
        profile = CustomerProfile(
          role: role,
          customerTypeId: type.id,
          entityId: van.id,
          displayName: van.name,
          mobile: van.mobile,
        );
      } else {
        final result = await customerRepo.importers(search: email);
        final importer = _matchImporter(result.items, email) ??
            (result.items.isNotEmpty ? result.items.first : null);
        if (importer == null) {
          state = const CustomerContextState(
            isLoading: false,
            error: 'No importer profile linked to your account.',
          );
          return;
        }
        profile = CustomerProfile(
          role: role,
          customerTypeId: type.id,
          entityId: importer.id,
          displayName: importer.name,
          mobile: importer.mobile,
        );
      }

      state = CustomerContextState(isLoading: false, profile: profile);
    } catch (e) {
      state = CustomerContextState(isLoading: false, error: e.toString());
    }
  }

  CustomerShopModel? _matchShop(List<CustomerShopModel> items, String? email) {
    if (email == null) return null;
    for (final shop in items) {
      for (final contact in shop.contacts) {
        if (contact.contactEmail?.toLowerCase() == email) return shop;
      }
    }
    return null;
  }

  CustomerVanModel? _matchVan(List<CustomerVanModel> items, String? email) {
    if (items.length == 1) return items.first;
    return null;
  }

  CustomerImporterModel? _matchImporter(List<CustomerImporterModel> items, String? email) {
    if (items.length == 1) return items.first;
    return null;
  }
}

final customerContextProvider =
    NotifierProvider<CustomerContextNotifier, CustomerContextState>(CustomerContextNotifier.new);
