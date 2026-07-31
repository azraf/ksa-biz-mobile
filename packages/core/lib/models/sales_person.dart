import 'package:equatable/equatable.dart';

class SalesPersonModel extends Equatable {
  const SalesPersonModel({
    required this.id,
    required this.name,
    this.userId,
    this.mobile,
    this.email,
    this.address,
  });

  final int id;
  final int? userId;
  final String name;
  final String? mobile;
  final String? email;
  final String? address;

  factory SalesPersonModel.fromJson(Map<String, dynamic> json) {
    return SalesPersonModel(
      id: json['id'] as int,
      userId: json['user_id'] as int?,
      name: json['name'] as String? ?? '',
      mobile: json['mobile'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'mobile': mobile,
        'email': email,
        'address': address,
      };

  @override
  List<Object?> get props => [id, userId, name, mobile, email, address];
}
