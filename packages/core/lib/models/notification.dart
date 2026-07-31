import 'package:equatable/equatable.dart';

class InAppNotificationModel extends Equatable {
  const InAppNotificationModel({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.data,
    this.readAt,
    this.createdAt,
  });

  final int id;
  final String type;
  final String title;
  final String? body;
  final Map<String, dynamic>? data;
  final String? readAt;
  final String? createdAt;

  bool get isRead => readAt != null;

  factory InAppNotificationModel.fromJson(Map<String, dynamic> json) {
    return InAppNotificationModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String?,
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data'] as Map) : null,
      readAt: json['read_at']?.toString(),
      createdAt: json['created_at']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, type, readAt];
}
