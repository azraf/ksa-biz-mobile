import 'package:equatable/equatable.dart';

import '../support/json_parse.dart';

class UserModel extends Equatable {
  const UserModel({required this.id, required this.name, this.email, this.phone});

  final int id;
  final String name;
  final String? email;
  final String? phone;

  String? get loginIdentifier => email?.isNotEmpty == true ? email : phone;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      };

  @override
  List<Object?> get props => [id, name, email, phone];
}

class LinkedCustomerModel extends Equatable {
  const LinkedCustomerModel({
    required this.type,
    required this.id,
    required this.name,
    this.customerTypeId,
  });

  final String type;
  final int id;
  final String name;
  final int? customerTypeId;

  factory LinkedCustomerModel.fromJson(Map<String, dynamic> json) {
    return LinkedCustomerModel(
      type: json['type'] as String? ?? '',
      id: parseJsonInt(json['id']),
      name: json['name'] as String? ?? '',
      customerTypeId: parseJsonIntOrNull(json['customer_type_id']),
    );
  }

  @override
  List<Object?> get props => [type, id, name, customerTypeId];
}

class CustomerLinkedUserModel extends Equatable {
  const CustomerLinkedUserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
  });

  final int id;
  final String name;
  final String? email;
  final String? phone;

  factory CustomerLinkedUserModel.fromJson(Map<String, dynamic> json) {
    return CustomerLinkedUserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, name, email, phone];
}

Map<String, dynamic>? buildCreateUserPayload({
  required bool createUser,
  String? email,
  String? phone,
  String? password,
  String? passwordConfirmation,
}) {
  if (!createUser) return null;
  return {
    'create_user': true,
    'user': {
      if (email != null && email.isNotEmpty) 'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation ?? password,
    },
  };
}

CustomerLinkedUserModel? parseCustomerLinkedUser(dynamic json) {
  if (json is! Map<String, dynamic>) return null;
  return CustomerLinkedUserModel.fromJson(json);
}
