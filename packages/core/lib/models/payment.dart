import 'package:equatable/equatable.dart';

class PaymentModel extends Equatable {
  const PaymentModel({
    required this.id,
    required this.orderId,
    required this.amount,
    this.paymentReference,
    this.paidAt,
    this.paymentMethod,
    this.bankReference,
    this.notes,
    this.voidedAt,
  });

  final int id;
  final int orderId;
  final double amount;
  final String? paymentReference;
  final String? paidAt;
  final String? paymentMethod;
  final String? bankReference;
  final String? notes;
  final String? voidedAt;

  bool get isVoided => voidedAt != null;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      amount: _toDouble(json['amount']),
      paymentReference: json['payment_reference'] as String?,
      paidAt: json['paid_at']?.toString(),
      paymentMethod: json['payment_method'] as String?,
      bankReference: json['bank_reference'] as String?,
      notes: json['notes'] as String?,
      voidedAt: json['voided_at']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  @override
  List<Object?> get props => [id, orderId, amount, voidedAt];
}
