import 'package:equatable/equatable.dart';

import '../models/sales_person.dart';
import '../models/user.dart';

class AuthState extends Equatable {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.salesPerson,
    this.activeSalesPerson,
    this.roles = const [],
    this.canPickSalesPerson = false,
    this.token,
    this.apiBaseUrl,
    this.error,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final SalesPersonModel? salesPerson;
  final SalesPersonModel? activeSalesPerson;
  final List<String> roles;
  final bool canPickSalesPerson;
  final String? token;
  final String? apiBaseUrl;
  final String? error;

  bool get hasSalesPerson => salesPerson != null;
  bool get hasActiveSalesPerson => activeSalesPerson != null;
  int? get effectiveSalesPersonId => activeSalesPerson?.id ?? salesPerson?.id;

  bool get needsSalesPersonSelection =>
      canPickSalesPerson && activeSalesPerson == null;

  bool get isAdmin => roles.contains('admin');

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    SalesPersonModel? salesPerson,
    SalesPersonModel? activeSalesPerson,
    List<String>? roles,
    bool? canPickSalesPerson,
    String? token,
    String? apiBaseUrl,
    String? error,
    bool clearError = false,
    bool clearSalesPerson = false,
    bool clearActiveSalesPerson = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      salesPerson: clearSalesPerson ? null : (salesPerson ?? this.salesPerson),
      activeSalesPerson: clearActiveSalesPerson
          ? null
          : (activeSalesPerson ?? this.activeSalesPerson),
      roles: roles ?? this.roles,
      canPickSalesPerson: canPickSalesPerson ?? this.canPickSalesPerson,
      token: token ?? this.token,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isAuthenticated,
        user,
        salesPerson,
        activeSalesPerson,
        roles,
        canPickSalesPerson,
        token,
        apiBaseUrl,
        error,
      ];
}
