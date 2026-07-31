import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({required this.id, required this.name, this.email});

  final int id;
  final String name;
  final String? email;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'email': email};

  @override
  List<Object?> get props => [id, name, email];
}
