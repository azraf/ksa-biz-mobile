import 'package:equatable/equatable.dart';

import 'user.dart';

class ExpenseCategoryModel extends Equatable {
  const ExpenseCategoryModel({
    required this.id,
    required this.name,
    this.slug,
    this.code,
    this.parentId,
    this.type,
    this.isActive = true,
    this.sortOrder = 0,
    this.children = const [],
  });

  final int id;
  final String name;
  final String? slug;
  final String? code;
  final int? parentId;
  final String? type;
  final bool isActive;
  final int sortOrder;
  final List<ExpenseCategoryModel> children;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      ExpenseCategoryModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String?,
        code: json['code'] as String?,
        parentId: json['parent_id'] as int?,
        type: json['type'] as String?,
        isActive: json['is_active'] as bool? ?? true,
        sortOrder: json['sort_order'] as int? ?? 0,
        children: (json['children'] as List<dynamic>? ?? [])
            .map((e) => ExpenseCategoryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        if (slug != null) 'slug': slug,
        if (code != null) 'code': code,
        if (parentId != null) 'parent_id': parentId,
        if (type != null) 'type': type,
        'is_active': isActive,
        'sort_order': sortOrder,
      };

  @override
  List<Object?> get props => [id, name];
}

class ExpenseModel extends Equatable {
  const ExpenseModel({
    required this.id,
    required this.expenseCategoryId,
    required this.amount,
    required this.expenseDate,
    this.currency = 'SAR',
    this.description,
    this.referenceType,
    this.referenceId,
    this.metadata,
    this.status = 'draft',
    this.attachmentUrl,
    this.category,
    this.creator,
  });

  final int id;
  final int expenseCategoryId;
  final double amount;
  final String expenseDate;
  final String currency;
  final String? description;
  final String? referenceType;
  final int? referenceId;
  final Map<String, dynamic>? metadata;
  final String status;
  final String? attachmentUrl;
  final ExpenseCategoryModel? category;
  final UserModel? creator;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'] as int,
        expenseCategoryId: json['expense_category_id'] as int,
        amount: _toDouble(json['amount']),
        expenseDate: json['expense_date']?.toString() ?? '',
        currency: json['currency'] as String? ?? 'SAR',
        description: json['description'] as String?,
        referenceType: json['reference_type'] as String?,
        referenceId: json['reference_id'] as int?,
        metadata: json['metadata'] is Map
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : null,
        status: json['status'] as String? ?? 'draft',
        attachmentUrl: json['attachment_url'] as String?,
        category: json['category'] is Map
            ? ExpenseCategoryModel.fromJson(json['category'] as Map<String, dynamic>)
            : null,
        creator: json['creator'] is Map
            ? UserModel.fromJson(json['creator'] as Map<String, dynamic>)
            : null,
      );

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'expense_category_id': expenseCategoryId,
        'amount': amount,
        'expense_date': expenseDate,
        'currency': currency,
        if (description != null) 'description': description,
        if (referenceType != null) 'reference_type': referenceType,
        if (referenceId != null) 'reference_id': referenceId,
        if (metadata != null) 'metadata': metadata,
        'status': status,
      };

  @override
  List<Object?> get props => [id, amount, expenseDate, status];
}
