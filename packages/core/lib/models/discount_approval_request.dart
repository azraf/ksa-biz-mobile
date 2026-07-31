import 'package:equatable/equatable.dart';

class DiscountApprovalRequestModel extends Equatable {
  const DiscountApprovalRequestModel({
    required this.id,
    required this.orderId,
    required this.requestedAmount,
    required this.status,
    this.previousAmount = 0,
    this.autoApproved = false,
    this.reason,
    this.reviewNotes,
    this.createdAt,
  });

  final int id;
  final int orderId;
  final double requestedAmount;
  final double previousAmount;
  final String status;
  final bool autoApproved;
  final String? reason;
  final String? reviewNotes;
  final String? createdAt;

  factory DiscountApprovalRequestModel.fromJson(Map<String, dynamic> json) {
    return DiscountApprovalRequestModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      requestedAmount: _toDouble(json['requested_amount']),
      previousAmount: _toDouble(json['previous_amount']),
      status: json['status'] as String? ?? 'pending',
      autoApproved: json['auto_approved'] as bool? ?? false,
      reason: json['reason'] as String?,
      reviewNotes: json['review_notes'] as String?,
      createdAt: json['created_at']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [id, orderId, status, requestedAmount];
}
