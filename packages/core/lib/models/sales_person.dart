import 'package:equatable/equatable.dart';

class SalesPersonModel extends Equatable {
  const SalesPersonModel({
    required this.id,
    required this.name,
    this.userId,
    this.mobile,
    this.email,
    this.address,
    this.status = 'active',
  });

  final int id;
  final int? userId;
  final String name;
  final String? mobile;
  final String? email;
  final String? address;
  final String status;

  bool get isActive => status == 'active';

  factory SalesPersonModel.fromJson(Map<String, dynamic> json) {
    return SalesPersonModel(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'mobile': mobile,
        'email': email,
        'address': address,
        'status': status,
      };

  @override
  List<Object?> get props => [id, userId, name, mobile, email, address, status];
}
